package lime._internal.backend.native;

import haxe.Int64;

import sys.thread.Thread;
import sys.thread.Mutex;

import lime.app.Application;
import lime.app.Event;
import lime.math.Vector2;
import lime.math.Vector4;
import lime.media.openal.AL;
import lime.media.openal.ALBuffer;
import lime.media.openal.ALC;
import lime.media.openal.ALFilter;
import lime.media.openal.ALSource;
import lime.media.AudioBuffer;
import lime.media.AudioDecoder;
import lime.media.AudioEffect;
import lime.media.AudioManager;
import lime.media.AudioSource;
import lime.system.System;
import lime.utils.ArrayBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.ArrayBufferView.ArrayBufferIO;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;

@:access(lime.media.AudioBuffer)
@:access(lime.media.AudioManager)
@:access(lime.media.AudioSource)
@:access(lime.utils.ArrayBufferView)
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NativeAudioSource
{
	/**
		What size the buffers (in hertz, excluding channels, bitsPerSample) will be to use for stream processing.
	**/
	public static final STREAM_BUFFER_SAMPLES:Int = 0x4000;

	/**
		How much length in bytes can a buffer hold maximum (have to be pow of 2).
		This is used when converting `STREAM_BUFFER_SAMPLES` to byteLength in intialize.
	**/
	public static final STREAM_BUFFER_MAX_LENGTH:Int = 0x10000;

	/**
		How much buffers can the stream processing hold minimally.
	**/
	public static final STREAM_MIN_BUFFERS:Int = 3;

	/**
		What buffer limit can a stream processing hold maximally, must be higher than `STREAM_MIN_BUFFERS`.
	**/
	public static final STREAM_MAX_BUFFERS:Int = 8;

	/**
		How much buffers can it be used to be passed into stream processing.
		This is for to preserve previous buffers to use whenever a seeking/small rewinding is requested.
		Recommended to be below and not equal to `STREAM_MAX_BUFFERS`.
	**/
	public static final STREAM_USABLE_BUFFERS:Int = 6;

	/**
		How much buffers can it be played in stream processing tick.
		This is to prevent to hit the max hardware buffer limit which is usually `1024`, and hxvlc can sometime uses more buffers maximum of `512`.
	**/
	public static final STREAM_FLUSH_BUFFERS:Int = 4;

	/**
		How much buffers to be prepared in normal starting.
	**/
	public static final STREAM_START_BUFFERS:Int = 1;

	/**
		How much buffers to be processed and prepared in `prepare()` function before playing.
	**/
	public static final STREAM_PREPARE_BUFFERS:Int = 3;

	/**
		How much buffers can be processed in a stream processing tick.
	**/
	public static final STREAM_PROCESS_BUFFERS:Int = 1;

	/**
		What delay (in seconds) to wait between updating the buffers.
	**/
	public static final STREAM_UPDATE_DELAY:Float = 0.04;

	/**
		What ticks it need to be passed in stream flush tick to process, unless a source doesnt have much buffers to play.
	**/
	public static final STREAM_PROCESS_TICKS:Int = 3;

	/**
		How much buffer views to be reused for the next audio source.
		This is for to prevent reallocating potentially the same buffer size constantly.
	**/
	public static final POOL_MAX_BUFFERS:Int = 32;

	public static function playSources(sources:Array<AudioSource>):Void
	{
		var alSources = [], streams:Array<NativeAudioSource> = [], backend:NativeAudioSource;
		for (source in sources)
		{
			backend = source.__backend;
			if (backend != null && backend.loaded && !backend.playing && !backend.completed)
			{
				if (!backend.prepared) backend.prepare(backend.getCurrentTime());
				alSources.push(backend.source);

				backend.playing = true;
				backend.prepared = false;

				// We have to resume the stream processing after it plays, or it'll throw away prepared buffers.
				if (backend.streamed && !backend.streamEnded) streams.push(backend);

				backend.resetTimer((backend.loopPoints[1] - backend.pauseSample)
					* 1000.0 / source.buffer.sampleRate / backend.getPitch());
			}
		}

		AL.sourcePlayv(alSources);

		for (backend in streams) backend.resumeStream(false);
	}

	public static function pauseSources(sources:Array<AudioSource>):Void
	{
		var alSources = [], backend:NativeAudioSource;
		for (source in sources)
		{
			backend = source.__backend;
			if (backend != null && backend.loaded)
			{
				backend.stopTimer();
				if (backend.streamed) backend.stopStream(false);

				backend.pauseSample = backend.getCurrentSampleOffset();
				backend.playing = false;
				backend.completed = false;

				alSources.push(backend.source);
			}
		}

		AL.sourcePausev(alSources);
	}

	public static function stopSources(sources:Array<AudioSource>):Void
	{
		var alSources = [], backend:NativeAudioSource;
		for (source in sources)
		{
			backend = source.__backend;
			if (backend != null)
			{
				backend.playing = false;
				backend.completed = false;

				if (backend.loaded)
				{
					alSources.push(backend.source);
					backend.pauseSample = 0;

					backend.stopTimer();
					if (backend.streamed) backend.stopStream(false);
				}
			}
		}

		AL.sourceStopv(alSources);
	}

	private static var bufferViewPool:Array<ArrayBufferView> = [];
	private static var streamAudios:Array<NativeAudioSource> = [];
	private static var queuedStreamAudios:Array<NativeAudioSource> = [];
	private static var playingAudios:Array<NativeAudioSource> = [];
	private static var threadRunning:Bool = false;
	private static var streamThread:Thread;
	private static var streamMutex:Mutex = new Mutex();
	private static var queueMutex:Mutex = new Mutex();

	public var onRefresh = new Event<NativeAudioSource->Void>();
	public var parent:AudioSource;
	public var source:ALSource;

	private var completed:Bool;
	private var format:Int;
	private var loops:Int;
	private var pauseSample:Int;
	private var peaks:Array<Float>;
	private var playing:Bool;
	private var position:Vector4;
	private var samples:Int;
	private var streamed:Bool;
	private var timeEnd:Float;
	private var lastReadSampleOffset:Int;
	private var lastReadTime:Float;

	private var standaloneBuffer:Bool;
	private var buffer:ALBuffer;
	private var standaloneDecoder:Bool;
	private var decoder:AudioDecoder;
	private var anglesArray:Array<Float>;
	private var loopPoints:Array<Int>;
	private var mins:Array<Int>;
	private var maxs:Array<Int>;

	public var bufferLen:Int;
	public var queuedBuffers:Int;
	public var filledBuffers:Int;
	public var streamLoops:Int;
	public var streamEnded:Bool;
	public var streaming:Bool;
	public var loaded:Bool;
	public var pending:Bool;

	// ORDERING IS CURRENT TO NEXT, STARTS FROM THE LENGTH OF THE ARRAYS
	public var bufferViews:Array<ArrayBufferView>;
	public var bufferCurs:Array<Int>;
	public var bufferLens:Array<Int>;

	public var mutex:Mutex;
	public var seekMutex:Mutex;
	private var prepared:Bool;
	private var buffers:Array<ALBuffer>;
	private var nextBuffer:Int = 0;

	public function new(parent:AudioSource)
	{
		this.parent = parent;
		init();
	}

	private function init():Void
	{
		if (source != null) return;

		source = AL.createSource();
		if (source == null) return;

		AL.sourcef(source, AL.MAX_GAIN, 10);
		AL.sourcef(source, AL.MAX_DISTANCE, 1);

		if (loopPoints == null) loopPoints = [0, 0];
		if (anglesArray == null) anglesArray = [Math.PI / 6, -Math.PI / 6];

		if (AudioManager.__directChannelsExtSupported) AL.sourcei(source, AL.DIRECT_CHANNELS_SOFT, AL.REMIX_UNMATCHED_SOFT);
		if (AudioManager.__spatializeSupported) AL.sourcei(source, AL.SOURCE_SPATIALIZE_SOFT, AL.FALSE);
		if (AudioManager.__stereoAnglesSupported) AL.sourcefv(source, AL.STEREO_ANGLES, anglesArray);

		onRefresh.dispatch(this);
	}

	public function dispose():Void
	{
		loopPoints = null;
		mins = null;
		maxs = null;

		position = null;

		if (buffers != null)
		{
			AL.deleteBuffers(buffers);
			buffers = null;
		}

		bufferCurs = null;
		bufferLens = null;

		if (source != null)
		{
			AL.deleteSource(source);
			source = null;
		}

		mutex = null;
		seekMutex = null;
	}

	public function load():Void
	{
		init();
		if (source == null) return;

		format = AudioBuffer.__getALFormat(parent.buffer.bitsPerSample, parent.buffer.channels);
		streamed = parent.buffer.data == null && parent.buffer.decoder != null && !parent.buffer.decoder.disposed;

		if (streamed)
		{
			if (mutex == null) mutex = new Mutex();
			if (seekMutex == null) seekMutex = new Mutex();
			mutex.acquire();

			decoder = parent.buffer.decoder.clone();
			standaloneDecoder = decoder != null;
			if (!standaloneDecoder) decoder = parent.buffer.decoder;

			samples = Int64.toInt(decoder.total());

			bufferLen = STREAM_BUFFER_SAMPLES * parent.buffer.channels * (parent.buffer.bitsPerSample >> 3);
			if (bufferLen > STREAM_BUFFER_MAX_LENGTH) bufferLen = STREAM_BUFFER_MAX_LENGTH;

			if (buffers == null) buffers = AL.genBuffers(STREAM_FLUSH_BUFFERS);
			if (bufferCurs == null) bufferCurs = [for (i in 0...STREAM_MAX_BUFFERS) 0];
			if (bufferLens == null) bufferLens = [for (i in 0...STREAM_MAX_BUFFERS) 0];

			bufferViews = [for (i in 0...STREAM_MAX_BUFFERS)
			{
				var data = bufferViewPool.pop();
				if (data == null) data = new UInt8Array(bufferLen);
				else
				{
					if (data.byteLength < bufferLen) data.buffer = new ArrayBuffer(bufferLen);
					data.byteLength = bufferLen;
					data.length = bufferLen;
				}
				data;
			}];

			// Initialize the openal buffers first by allocating, before processing them.
			for (i in 0...STREAM_FLUSH_BUFFERS) AL.bufferData(buffers[i], format, bufferViews[i], bufferLen, parent.buffer.sampleRate);

			nextBuffer = 0;
			loaded = true;

			mutex.release();
		}
		else if (parent.buffer.data != null)
		{
			samples = idiv(parent.buffer.data.byteLength, (parent.buffer.bitsPerSample >> 3) * parent.buffer.channels);

			var shouldGenerateBuffer = parent.buffer.__srcBuffer == null;
			if (!shouldGenerateBuffer && AL.getBufferi(parent.buffer.__srcBuffer, AL.SIZE) != parent.buffer.data.byteLength)
			{
				AL.deleteBuffer(parent.buffer.__srcBuffer);
				shouldGenerateBuffer = true;
			}

			if (shouldGenerateBuffer)
			{
				parent.buffer.__srcBuffer = AL.createBuffer();
				if (parent.buffer.__srcBuffer != null)
				{
					AL.bufferData(parent.buffer.__srcBuffer, format, parent.buffer.data, parent.buffer.data.byteLength, parent.buffer.sampleRate);
				}
			}

			standaloneBuffer = false;
			buffer = parent.buffer.__srcBuffer;
			loaded = buffer != null;

			if (loaded) AL.sourcei(source, AL.BUFFER, buffer);
		}
		else
		{
			samples = 0;
			loaded = false;
		}

		AL.sourceRewind(source);

		loopPoints[0] = 0;
		loopPoints[1] = samples;
		streamLoops = 0;
	}

	public function unload():Void
	{
		if (loaded)
		{
			if (streamed)
			{
				streamMutex.acquire();
				queuedStreamAudios.remove(this);
				removeStream();

				AL.sourceStop(source);
				AL.sourceUnqueueBuffers(source, AL.getSourcei(source, AL.BUFFERS_QUEUED));
				queuedBuffers = filledBuffers = 0;

				if (standaloneDecoder) decoder.dispose();
				standaloneDecoder = false;
				decoder = null;

				if (bufferViews != null)
				{
					for (data in bufferViews) if (bufferViewPool.length < POOL_MAX_BUFFERS) bufferViewPool.push(data);
					bufferViews = null;
				}

				streamMutex.release();
			}
			else
			{
				AL.sourcei(source, AL.BUFFER, AL.NONE);

				if (standaloneBuffer) AL.deleteBuffer(buffer);
				standaloneBuffer = false;
				buffer = null;
			}

			streamed = loaded = false;
		}

		if (loopPoints != null) loopPoints[0] = loopPoints[1] = 0;
		pauseSample = 0;
	}

	public function play():Void
	{
		if (!loaded || playing) return;

		playing = true;
		if (prepared)
		{
			prepared = false;

			resetTimer((loopPoints[1] - pauseSample) * 1000.0 / parent.buffer.sampleRate / getPitch());
			AL.sourcePlay(source);

			if (streamed && !streamEnded) resumeStream(false);
		}
		else
		{
			setCurrentTime((pauseSample * 1000.0 / parent.buffer.sampleRate) - parent.offset);
		}
	}

	public function pause():Void
	{
		if (!loaded) return;

		stopTimer();
		if (streamed) stopStream(false);

		pauseSample = getCurrentSampleOffset();
		playing = false;
		completed = false;

		AL.sourcePause(source);
	}

	public function prepare(time:Float):Void
	{
		if (!loaded) return;

		var sampleOffset = Std.int((time + parent.offset) / 1000 * parent.buffer.sampleRate);
		if (sampleOffset < 0) sampleOffset = 0;

		if (prepared && pauseSample == sampleOffset) return;

		playing = false;
		pauseSample = sampleOffset;
		completed = sampleOffset >= loopPoints[1];
		prepared = !completed;

		if (prepared)
		{
			if (streamed)
			{
				mutex.acquire();
				stopStream(true);
				AL.sourceStop(source);
				snapBuffersToSample(sampleOffset, false, STREAM_PREPARE_BUFFERS);
				mutex.release();
			}
			else
			{
				AL.sourcePause(source);
				AL.sourcei(source, AL.SAMPLE_OFFSET, sampleOffset);
			}
		}
		else
		{
			pauseSample = 0;

			if (streamed) stopStream(false);
			AL.sourceStop(source);
		}
	}

	public function stop():Void
	{
		playing = false;
		completed = false;

		if (loaded)
		{
			pauseSample = 0;

			stopTimer();
			if (streamed) stopStream(false);
			AL.sourceStop(source);
		}
	}

	// Event Handlers
	private function stopTimer():Void
	{
		var idx = playingAudios.indexOf(this);
		if (idx != -1)
		{
			if (playingAudios.length == 1) Application.current.onUpdate.remove(timerHandler);
			else playingAudios[idx] = playingAudios[playingAudios.length - 1];
			playingAudios.pop();
		}
	}

	private function resetTimer(ms:Float):Void
	{
		if (!playingAudios.contains(this))
		{
			if (!Application.current.onUpdate.has(timerHandler)) Application.current.onUpdate.add(timerHandler);
			playingAudios.push(this);
		}

		timeEnd = AudioManager.getTimer() + ms;
	}

	private static function timerHandler(_):Void
	{
		var timer = AudioManager.getTimer(), i = playingAudios.length, backend:NativeAudioSource;

		while (i-- > 0)
		{
			if ((backend = playingAudios[i]) == null)
			{
				if (playingAudios.length == 1) Application.current.onUpdate.remove(timerHandler);
				else playingAudios[i] = playingAudios[playingAudios.length - 1];
				playingAudios.pop();

				continue;
			}
			else if (timer < backend.timeEnd) continue;

			if (backend.streamed)
			{
				if (backend.streaming && backend.streamLoops == 0 && backend.queuedBuffers > 1)
				{
					var sampleOffset = backend.getCurrentSampleOffset();
					var remaining = (backend.loopPoints[1] - sampleOffset) * 1000.0 / backend.parent.buffer.sampleRate / backend.getPitch();
					backend.resetTimer(remaining);
				}
				else
				{
					backend.complete(timer - backend.timeEnd);
				}
			}
			else
			{
				backend.complete(timer - backend.timeEnd);
			}
		}
	}

	private function complete(latency:Float):Void
	{
		if (loops > 0)
		{
			inline function fallback()
			{
				playing = true;
				setCurrentTime(loopPoints[0] * 1000.0 / parent.buffer.sampleRate - parent.offset);
			}

			if (streamed)
			{
				mutex.acquire();
				if (streamLoops > 0)
				{
					loops -= streamLoops;
					streamLoops = 0;
					pauseSample = loopPoints[0];
					resetTimer(((loopPoints[1] - pauseSample) * 1000.0 / parent.buffer.sampleRate + latency) / getPitch());
					mutex.release();
				}
				else
				{
					loops--;
					mutex.release();
					fallback();
				}
			}
			else
			{
				if (AudioManager.__loopPointsSupported && AL.getSourcei(source, AL.LOOPING) == AL.TRUE)
				{
					pauseSample = loopPoints[0];
					resetTimer(((loopPoints[1] - pauseSample) * 1000.0 / parent.buffer.sampleRate + latency) / getPitch());
				}
				else
				{
					fallback();
				}

				if (--loops == 0) AL.sourcei(source, AL.LOOPING, AL.FALSE);
			}
		}
		else
		{
			completed = true;
			playing = false;
			pauseSample = 0;
			stopTimer();
			if (streamed) stopStream(false);
		}

		parent.onComplete.dispatch();
	}

	// Get & Set Methods
	public function getCurrentTime():Float
	{
		if (loaded) return (getCurrentSampleOffset() * 1000.0 / parent.buffer.sampleRate) - parent.offset;
		else return 0;
	}

	private function getCurrentSampleOffset():Int
	{
		if (completed)
		{
			return loopPoints[1];
		}
		else if (!playing)
		{
			return pauseSample;
		}
		else if (AL.getSourcei(source, AL.SOURCE_STATE) == AL.STOPPED && (!streamed || streamEnded))
		{
			return loopPoints[1];
		}

		var sampleOffset:Int;
		if (streamed)
		{
			seekMutex.acquire();
			if (queuedBuffers == 0)
			{
				sampleOffset = pauseSample;
				if (filledBuffers > 0) sampleOffset += STREAM_BUFFER_SAMPLES;
			}
			else
			{
				sampleOffset = AL.getSourcei(source, AL.SAMPLE_OFFSET) + bufferCurs[STREAM_MAX_BUFFERS - queuedBuffers];
				if (AL.getSourcei(source, AL.SOURCE_STATE) == AL.STOPPED) sampleOffset += STREAM_BUFFER_SAMPLES;
			}
			seekMutex.release();
		}
		else
		{
			sampleOffset = AL.getSourcei(source, AL.SAMPLE_OFFSET);
		}

		if (loops > streamLoops && sampleOffset >= loopPoints[1])
		{
			if (loopPoints[0] >= loopPoints[1]) return loopPoints[0];
			else return ((sampleOffset - loopPoints[0]) % (loopPoints[1] - loopPoints[0])) + loopPoints[0];
		}
		else return sampleOffset;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (!loaded) return 0;

		prepared = false;
		pauseSample = Std.int((value + parent.offset) / 1000 * parent.buffer.sampleRate);
		if (pauseSample < 0) pauseSample = 0;

		if (streamed)
		{
			mutex.acquire();
			AL.sourceStop(source);
		}
		else
		{
			AL.sourcePause(source);
			AL.sourcei(source, AL.SAMPLE_OFFSET, pauseSample);
		}

		var remaining = (loopPoints[1] - pauseSample) * 1000.0 / parent.buffer.sampleRate / getPitch();
		var canPlay = remaining > 0;

		if (playing && canPlay)
		{
			completed = false;

			if (streamed)
			{
				snapBuffersToSample(pauseSample, false, STREAM_START_BUFFERS);
				AL.sourcePlay(source);

				if (streamEnded) stopStream(true);
				else resumeStream(true);
				mutex.release();
			}
			else AL.sourcePlay(source);

			resetTimer(remaining);
		}
		else
		{
			if (completed == canPlay)
			{
				completed = !canPlay;
				if (playing && completed)
				{
					resetTimer(0);
					playing = false;
				}
			}

			if (streamed)
			{
				stopStream(true);
				mutex.release();
			}
		}

		return value;
	}

	public function getGain():Float
	{
		if (source != null) return AL.getSourcef(source, AL.GAIN);
		else return 1;
	}

	public function setGain(value:Float):Float
	{
		if (source != null) AL.sourcef(source, AL.GAIN, value);
		return value;
	}

	public function getLatency():Float
	{
		if (source != null && AudioManager.__latencyExtSupported)
		{
			var offsets = AL.getSourcedvSOFT(source, AL.SEC_OFFSET_LATENCY_SOFT, 2);
			if (offsets != null) return offsets[1] * 1000.0;
		}
		return 0;
	}

	public function getLength():Float
	{
		if (!loaded) return 0;

		var length = loopPoints[1] * 1000.0 / parent.buffer.sampleRate;
		if (length <= parent.offset) return 0;
		return length - parent.offset;
	}

	public function setLength(value:Float):Float
	{
		if (loaded)
		{
			var endSample = Std.int((value + parent.offset) / 1000 * parent.buffer.sampleRate);
			if (endSample <= 0 || endSample >= samples) loopPoints[1] = samples;
			else loopPoints[1] = endSample;

			if (loops > streamLoops) updateLoopPoints();
			else AL.sourcei(source, AL.LOOPING, AL.FALSE);

			if (playing) resetTimer((endSample - getCurrentSampleOffset()) * 1000.0 / parent.buffer.sampleRate / getPitch());
		}
		return value;
	}

	public function getLoopTime():Float
	{
		if (!loaded) return 0;

		var loopTime = loopPoints[0] * 1000.0 / parent.buffer.sampleRate;
		if (loopTime <= parent.offset) return 0;
		return loopTime - parent.offset;
	}

	public function setLoopTime(value:Float):Float
	{
		if (loaded)
		{
			var loopSample = Std.int((value + parent.offset) / 1000 * parent.buffer.sampleRate);
			if (loopSample < 0) loopPoints[0] = 0;
			else if (loopSample > samples) loopPoints[0] = samples;
			else loopPoints[0] = loopSample;

			if (loops > streamLoops) updateLoopPoints();
			else AL.sourcei(source, AL.LOOPING, AL.FALSE);
		}
		return value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		loops = value;
		if (loaded)
		{
			if (value > streamLoops) updateLoopPoints();
			else AL.sourcei(source, AL.LOOPING, AL.FALSE);
		}
		return value;
	}

	private function updateLoopPoints():Void
	{
		prepared = false;

		var sampleOffset = getCurrentSampleOffset();
		var canLoop = loops > streamLoops;
		var fixed = sampleOffset >= loopPoints[1];
		var shouldStop = playing && fixed;

		if (fixed) sampleOffset = loopPoints[0];
		var time = sampleOffset * 1000.0 / parent.buffer.sampleRate;

		if (streamed)
		{
			AL.sourcei(source, AL.LOOPING, AL.FALSE);

			if (shouldStop) stop();
			else if (playing && canLoop && (fixed || streamLoops > 0))
			{
				mutex.acquire();
				snapBuffersToSample(sampleOffset, true, STREAM_MIN_BUFFERS);
				AL.sourcePlay(source);
				mutex.release();
			}
		}
		else
		{
			if (loopPoints[0] > 0 || loopPoints[1] < samples)
			{
				if (!AudioManager.__loopPointsSupported) canLoop = false;
				else
				{
					AL.sourceStop(source);
					AL.sourcei(source, AL.BUFFER, AL.NONE);
					if (!standaloneBuffer)
					{
						if (standaloneBuffer = (buffer = AL.createBuffer()) != null)
						{
							AL.bufferData(buffer, format, parent.buffer.data, parent.buffer.data.byteLength, parent.buffer.sampleRate);
						}
						else
						{
							buffer = parent.buffer.__srcBuffer;
							canLoop = false;
						}
					}
					if (canLoop) AL.bufferiv(buffer, AL.LOOP_POINTS_SOFT, loopPoints);
					AL.sourcei(source, AL.BUFFER, buffer);
				}
			}

			AL.sourcei(source, AL.LOOPING, canLoop ? AL.TRUE : AL.FALSE);
			if (shouldStop) stop();
			else setCurrentTime(time);
		}
	}

	public function getPan():Float
	{
		if (position == null) position = new Vector4();
		return position.x;
	}

	public function setPan(value:Float):Float
	{
		if (position == null) position = new Vector4();
		position.setTo(value, 0, -Math.sqrt(1 - value * value));

		if (source != null)
		{
			var spatialize = Math.abs(value) > 1e-04;

			if (AudioManager.__directChannelsExtSupported)
			{
				AL.sourcei(source, AL.DIRECT_CHANNELS_SOFT, spatialize ? AL.FALSE : AL.REMIX_UNMATCHED_SOFT);
			}

			if (AudioManager.__spatializeSupported)
			{
				AL.sourcei(source, AL.SOURCE_SPATIALIZE_SOFT, !AudioManager.__stereoAnglesSupported && spatialize ? AL.TRUE : AL.FALSE);
			}

			if (AudioManager.__stereoAnglesSupported)
			{
				anglesArray[0] = Math.PI * Math.min(-value * 2 + 1, 1) / 6;
				anglesArray[1] = -Math.PI * Math.min(value * 2 + 1, 1) / 6;
				AL.source3f(source, AL.POSITION, 0, 0, 0);
			}
			else
			{
				anglesArray[0] = Math.PI / 6;
				anglesArray[1] = -Math.PI / 6;
				AL.source3f(source, AL.POSITION, position.x, position.y, position.z);
			}
			AL.sourcefv(source, AL.STEREO_ANGLES, anglesArray);
		}
		return value;
	}

	public function getPitch():Float
	{
		return source != null ? AL.getSourcef(source, AL.PITCH) : 1;
	}

	public function setPitch(value:Float):Float
	{
		value = Math.max(value, 0);
		if (source == null || value == AL.getSourcef(source, AL.PITCH)) return value;
		AL.sourcef(source, AL.PITCH, value);
		if (playing) resetTimer((loopPoints[1] - getCurrentSampleOffset()) * 1000.0 / parent.buffer.sampleRate / value);
		return value;
	}

	public function getPlaying():Bool
	{
		return playing && (AL.getSourcei(source, AL.SOURCE_STATE) == AL.PLAYING || streaming);
	}

	public function getPosition():Vector4
	{
		if (position == null) position = new Vector4();
		return position;
	}

	public function setPosition(value:Vector4):Vector4
	{
		if (position == null) position = new Vector4();
		position.setTo(value.x, value.y, value.z);

		if (source != null)
		{
			anglesArray[0] = Math.PI / 6;
			anglesArray[1] = -Math.PI / 6;
			AL.sourcefv(source, AL.STEREO_ANGLES, anglesArray);

			if (Math.abs(position.x) > 1e-04 || Math.abs(position.y) > 1e-04 || Math.abs(position.z) > 1e-04)
			{
				if (AudioManager.__directChannelsExtSupported)
				{
					AL.sourcei(source, AL.DIRECT_CHANNELS_SOFT, AL.FALSE);
				}

				if (AudioManager.__spatializeSupported)
				{
					AL.sourcei(source, AL.SOURCE_SPATIALIZE_SOFT, AL.TRUE);
				}
			}
			else
			{
				if (AudioManager.__directChannelsExtSupported)
				{
					AL.sourcei(source, AL.DIRECT_CHANNELS_SOFT, AL.REMIX_UNMATCHED_SOFT);
				}

				if (AudioManager.__spatializeSupported)
				{
					AL.sourcei(source, AL.SOURCE_SPATIALIZE_SOFT, AL.FALSE);
				}
			}

			AL.source3f(source, AL.POSITION, position.x, position.y, position.z);
		}

		return value;
	}

	function readToBufferData(data:ArrayBufferView, currentPCM:Int):Int
	{
		if (decoder.eof || currentPCM >= loopPoints[1])
		{
			if (streamEnded = loops <= streamLoops || !decoder.seek(loopPoints[0])) return 0;
			streamLoops++;
		}

		var word = parent.buffer.bitsPerSample > 16 ? 2 : parent.buffer.bitsPerSample >> 3, total = 0, len:Int;
		while (!(streamEnded = decoder.eof))
		{
			// use unused var from here which is currentPCM
			if ((len = (loopPoints[1] - currentPCM) * parent.buffer.channels * word) <= (currentPCM = bufferLen - total))
			{
				total += decoder.decode(data.buffer, total, len, word);
				if (loops > streamLoops)
				{
					decoder.seek(currentPCM = loopPoints[0]);
					streamLoops++;
				}
				else
				{
					streamEnded = true;
					break;
				}
			}
			else
			{
				return total + decoder.decode(data.buffer, total, currentPCM, word);
			}
		}
		return total;
	}

	function fillBuffers(n:Int):Void
	{
		var max = STREAM_MAX_BUFFERS - 1;
		var i:Int, j:Int, data:ArrayBufferView, pcm:Int, decoded:Int;
		while (n-- > 0 && !streamEnded)
		{
			data = bufferViews[(i = max - filledBuffers) > 0 ? i : 0];
			pcm = Int64.toInt(decoder.tell());
			decoded = readToBufferData(data, pcm);

			if (decoded <= 0) break;
			else if (filledBuffers < STREAM_MAX_BUFFERS) filledBuffers++;

			seekMutex.acquire();

			j = i;
			while (i < max)
			{
				bufferViews[i] = bufferViews[++j];
				bufferCurs[i] = bufferCurs[j];
				bufferLens[i] = bufferLens[j];
				i = j;
			}
			bufferViews[max] = data;
			bufferCurs[max] = pauseSample = pcm;
			bufferLens[max] = decoded;
			queuedBuffers++;

			seekMutex.release();
		}
	}

	function queueBuffers():Void
	{
		var internalQueuedBuffers = AL.getSourcei(source, AL.BUFFERS_QUEUED);
		var i = STREAM_MAX_BUFFERS - queuedBuffers + internalQueuedBuffers;
		while (internalQueuedBuffers < STREAM_FLUSH_BUFFERS && internalQueuedBuffers < queuedBuffers)
		{
			AL.bufferData(buffers[nextBuffer], format, bufferViews[i], bufferLens[i], parent.buffer.sampleRate);
			if (AL.getError() != AL.NO_ERROR) break;

			AL.sourceQueueBuffer(source, buffers[nextBuffer]);
			if (AL.getError() != AL.NO_ERROR) break;

			if (++nextBuffer == STREAM_FLUSH_BUFFERS) nextBuffer = 0;
			internalQueuedBuffers++;
			i++;
		}
	}

	function skipBuffers(n:Int):Void
	{
		if (n > 0)
		{
			seekMutex.acquire();
			AL.sourceUnqueueBuffers(source, n);
			if ((queuedBuffers -= n) < 0) queuedBuffers = 0;
			seekMutex.release();
		}
	}

	function snapBuffersToSample(sample:Int, force:Bool, n:Int):Void
	{
		if (!force)
		{
			for (i in (STREAM_MAX_BUFFERS - queuedBuffers)...STREAM_MAX_BUFFERS)
				if (sample >= bufferCurs[i] && sample < bufferCurs[i] + (bufferLens[i] / (parent.buffer.bitsPerSample >> 3) / parent.buffer.channels))
			{
				skipBuffers(i - STREAM_MAX_BUFFERS + queuedBuffers);
				queueBuffers();
				AL.sourcei(source, AL.SAMPLE_OFFSET, sample - bufferCurs[i]);
				return;
			}
		}

		AL.sourceStop(source);
		AL.sourceUnqueueBuffers(source, AL.getSourcei(source, AL.BUFFERS_QUEUED));

		streamEnded = false;
		queuedBuffers = filledBuffers = streamLoops = nextBuffer = 0;
		decoder.seek(sample);
		fillBuffers(n);
		queueBuffers();
	}

	static function streamThreadRun():Void
	{
		var backend:NativeAudioSource;
		var i:Int;
		var a:Int;
		var b:Int;

		var processTicks:Int = 0;
		var canProcess:Bool;

		while (true)
		{
			queueMutex.acquire();

			i = queuedStreamAudios.length;
			a = streamAudios.length;
			if (i == 0 && a == 0)
			{
				queueMutex.release();
				break;
			}

			while (i-- > 0)
			{
				backend = queuedStreamAudios[i];
				if (backend.streaming = backend.playing && backend.pending)
				{
					backend.pending = false;
					streamAudios.push(backend);
					a++;
				}
			}

			queuedStreamAudios.resize(0);
			queueMutex.release();

			streamMutex.acquire();
			i = a;

			if (canProcess = (++processTicks == STREAM_PROCESS_TICKS)) processTicks = 0;
			while (i-- > 0)
			{
				backend = streamAudios[i];
				if (backend.pending || backend.mutex == null)
				{
					backend.removeStream();
					continue;
				}

				a = AL.getSourcei(backend.source, AL.BUFFERS_PROCESSED);
				if (!backend.mutex.tryAcquire())
				{
					if (a >= STREAM_PROCESS_BUFFERS)
					{
						backend.mutex.acquire();
						if (backend.pending)
						{
							backend.removeStream();
							backend.mutex.release();
							continue;
						}
						a = AL.getSourcei(backend.source, AL.BUFFERS_PROCESSED);
					}
					else
					{
						continue;
					}
				}

				backend.skipBuffers(a);

				if (!backend.streamEnded && (canProcess || backend.queuedBuffers <= STREAM_MIN_BUFFERS))
				{
					try
					{
						if (STREAM_PROCESS_BUFFERS > (a = backend.queuedBuffers < STREAM_MIN_BUFFERS ? STREAM_MIN_BUFFERS - backend.queuedBuffers : 0))
							a = STREAM_PROCESS_BUFFERS;

						if ((b = STREAM_USABLE_BUFFERS - backend.queuedBuffers) < a)
							a = b;

						if (a > 0)
							backend.fillBuffers(a);
					}
					catch (e:haxe.Exception)
					{
						haxe.MainLoop.runInMainThread(haxe.Log.trace.bind(e.details() + '\n' + e.stack));
					}
				}

				backend.queueBuffers();

				if (AL.getSourcei(backend.source, AL.SOURCE_STATE) != AL.PLAYING)
				{
					AL.sourcePlay(backend.source);
					backend.resetTimer((backend.loopPoints[1] - backend.bufferCurs[STREAM_MAX_BUFFERS - backend.queuedBuffers])
						* 1000.0 / backend.parent.buffer.sampleRate / backend.getPitch());
				}

				if (backend.streamEnded && backend.queuedBuffers == AL.getSourcei(backend.source, AL.BUFFERS_QUEUED)) backend.removeStream();

				backend.mutex.release();
			}

			streamMutex.release();
			Sys.sleep(STREAM_UPDATE_DELAY);
		}

		threadRunning = false;
	}

	inline function removeStream():Void
	{
		pending = streaming = false;
		streamAudios.remove(this);
	}

	function stopStream(acquired:Bool):Void
	{
		if (streaming)
		{
			if (acquired) pending = true;
			else
			{
				mutex.acquire();
				pending = true;
				mutex.release();
			}
		}
		else if (pending)
		{
			if (queueMutex.tryAcquire())
			{
				pending = streaming;
				if (!streaming) queuedStreamAudios.remove(this);
				queueMutex.release();
			}
			else if (acquired) pending = streaming;
			else
			{
				mutex.acquire();
				pending = streaming;
				mutex.release();
			}
		}
	}

	function resumeStream(acquired:Bool):Void
	{
		if (!streaming)
		{
			if (!pending)
			{
				queueMutex.acquire();
				queuedStreamAudios.push(this);
				queueMutex.release();
			}
			pending = true;
		}
		else if (pending)
		{
			if (queueMutex.tryAcquire())
			{
				pending = !streaming;
				if (pending) queuedStreamAudios.push(this);
				queueMutex.release();
			}
			else if (acquired) pending = !streaming;
			else
			{
				mutex.acquire();
				pending = !streaming;
				mutex.release();
			}
		}

		if (!threadRunning || streamThread == null)
		{
			streamThread = Thread.create(streamThreadRun);
			threadRunning = true;
		}
	}

	// Waveform related functions
	public function getPeaks(offsetMs:Float):Array<Float>
	{
		if (peaks == null) peaks = [];

		if (loaded && parent.buffer.channels != peaks.length) peaks.resize(parent.buffer.channels);

		if (!playing)
		{
			for (i in 0...peaks.length) peaks[i] = 0;
			return peaks;
		}

		var byteSize = 1 << parent.buffer.bitsPerSample;

		if (mins == null)
		{
			mins = [];
			maxs = [];
		}

		for (i in 0...parent.buffer.channels)
		{
			mins[i] = byteSize;
			maxs[i] = -byteSize;
		}

		var samplesToRead = parent.buffer.sampleRate >> 4;
		readTimeDomainData(function(byte:Int, channel:Int):Void
		{
			if (byte > maxs[channel]) maxs[channel] = byte;
			else if (byte < mins[channel]) mins[channel] = byte;
		}, samplesToRead, Std.int(offsetMs / 1000 * parent.buffer.sampleRate) - samplesToRead);

		for (i in 0...parent.buffer.channels) peaks[i] = (maxs[i] - mins[i]) / byteSize;
		return peaks;
	}

	public function getFloatTimeDomainData(array:Float32Array, size:Int, channel:Int, offset:Int):Int
	{
		if (!playing || array == null) return 0;

		var valueSize = 1 << (parent.buffer.bitsPerSample - 1);
		var channelToNext = parent.buffer.channels - 1, i = 0, v = 0, func:Int->Int->Void;

		if (channel == -1)
		{
			func = function(signal:Int, signalChannel:Int):Void
			{
				if (i < array.length)
				{
					if (signalChannel == 0) v = idiv(signal, parent.buffer.channels);
					else v += idiv(signal, parent.buffer.channels);

					if (signalChannel == channelToNext) array[i++] = v / valueSize;
				}
			}
		}
		else
		{
			func = function(signal:Int, signalChannel:Int):Void
			{
				if (i < array.length)
				{
					if (signalChannel == channel) v = signal;
					if (signalChannel == channelToNext) array[i++] = v / valueSize;
				}
			}
		}

		readTimeDomainData(func, size, offset);
		return i;
	}

	public function getByteTimeDomainData(array:UInt8Array, size:Int, channel:Int, offset:Int):Int
	{
		if (!playing || array == null) return 0;

		var valueDiv = 1 << (parent.buffer.bitsPerSample - 8);
		var channelToNext = parent.buffer.channels - 1, i = 0, v = 0, func:Int->Int->Void;

		if (channel == -1)
		{
			func = function(signal:Int, signalChannel:Int):Void
			{
				if (i < array.length)
				{
					if (signalChannel == 0) v = idiv(signal, parent.buffer.channels);
					else v += idiv(signal, parent.buffer.channels);

					if (signalChannel == channelToNext)
					{
						if (v < 0) array[i++] = idiv(v, valueDiv) + 0x100;
						else array[i++] = idiv(v, valueDiv);
					}
				}
			}
		}
		else
		{
			func = function(signal:Int, signalChannel:Int):Void
			{
				if (i < array.length)
				{
					if (signalChannel == channel) v = signal;
					if (signalChannel == channelToNext)
					{
						if (v < 0) array[i++] = idiv(v, valueDiv) + 0x100;
						else array[i++] = idiv(v, valueDiv);
					}
				}
			}
		}

		readTimeDomainData(func, size, offset);
		return i;
	}

	function readTimeDomainData(callback:Int->Int->Void, size:Int, offsetSample:Int):Void
	{
		var pos = AL.getSourcei(source, AL.SAMPLE_OFFSET);
		if (lastReadSampleOffset == pos)
		{
			offsetSample += Std.int((System.getTimer() - lastReadTime) / 1000.0 * parent.buffer.sampleRate * AL.getSourcef(source, AL.PITCH));
		}
		else
		{
			lastReadTime = System.getTimer();
			lastReadSampleOffset = pos;
		}

		var i = 0, buffer:ArrayBuffer, bufferLen:Int;
		if (streamed)
		{
			if (filledBuffers == 0) return;
			mutex.acquire();

			i = STREAM_MAX_BUFFERS - queuedBuffers;
			buffer = bufferViews[i].buffer;
			bufferLen = bufferLens[i];
		}
		else
		{
			buffer = parent.buffer.data.buffer;
			bufferLen = buffer.length;
		}

		var byteRate = parent.buffer.bitsPerSample >> 3;
		pos = (pos + offsetSample) * parent.buffer.channels * byteRate;

		if (pos < 0)
		{
			if (size < pos)
			{
				if (streamed) mutex.release();
				return;
			}

			size -= pos;
			do {
				if (i == 0) pos = 0;
				else
				{
					buffer = bufferViews[--i].buffer;
					bufferLen = bufferLens[i];
					pos += bufferLen;
				}
			} while (pos < 0);
		}
		else if (pos >= bufferLen)
		{
			if (!streamed) return;

			do
			{
				if (++i >= bufferLens.length)
				{
					mutex.release();
					return;
				}

				pos -= bufferLen;
				buffer = bufferViews[i].buffer;
				bufferLen = bufferLens[i];
			} while (pos >= bufferLen);
		}

		var c = 0;
		while (size > 0)
		{
			callback(switch (byteRate)
			{
				case 2: ArrayBufferIO.getInt16(buffer, pos);
				case 3:
					// make use of the unused variable from here.
					if ((offsetSample = ArrayBufferIO.getUint16(buffer, pos) | (buffer.get(pos + 2) << 16)) & 0x800000 != 0) offsetSample -= 0x1000000;
					offsetSample;
				case 4: ArrayBufferIO.getInt32(buffer, pos);
				default: ArrayBufferIO.getInt8(buffer, pos);
			}, c);

			pos += byteRate;
			if (pos >= bufferLen)
			{
				if (!streamed || ++i >= bufferLens.length || --size == 0) break;

				c = pos = 0;
				buffer = bufferViews[i].buffer;
				bufferLen = bufferLens[i];
			}

			c++;
			if (c == parent.buffer.channels)
			{
				c = 0;
				size--;
			}
		}

		if (streamed) mutex.release();
	}

	// Real-time audio effects
	public function addEffect(index:Int):Void
	{
		updateEffect(index);
	}

	public function updateEffect(index:Int):Void
	{
		if (source != null)
		@:privateAccess
		{
			var effect = parent.__effects[index];
			AL.source3i(source, AL.AUXILIARY_SEND_FILTER, effect.__alAux, index, effect.__alFilter);
			if (effect.__alFilter != null) AL.sourcei(source, AL.DIRECT_FILTER, effect.__alFilter);
		}
	}

	public function removeEffect(index:Int):Void
	{
		if (source != null)
		{
			//AL.source3i(source, AL.AUXILIARY_SEND_FILTER, AL.EFFECTSLOT_NULL, index, AL.FILTER_NULL);
			AL.removeSend(source, index);
		}
	}

	static inline function idiv(num:Int, denom:Int):Int return #if (cpp && !cppia) cpp.NativeMath.idiv(num, denom) #else Std.int(num / denom) #end;
}