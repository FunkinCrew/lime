package lime._internal.backend.html5;

import lime.app.Event;
import lime.math.Vector4;
import lime.media.AudioSource;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;

#if lime_howlerjs
import js.html.audio.AudioNode;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.BaseAudioContext;
import js.html.audio.ChannelSplitterNode;
import js.html.audio.MediaElementAudioSourceNode;
import js.html.MediaElement;
import js.lib.Float32Array as JSFloat32Array;
import lime.media.howlerjs.Howl;
import lime.media.howlerjs.Howler;
#end

@:access(lime.media.AudioBuffer)
class HTML5AudioSource
{
	public static function playSources(sources:Array<AudioSource>):Void
	{
		for (source in sources) source.play();
	}

	public static function pauseSources(sources:Array<AudioSource>):Void
	{
		for (source in sources) source.pause();
	}

	public static function stopSources(sources:Array<AudioSource>):Void
	{
		for (source in sources) source.stop();
	}

	public var parent:AudioSource;

	private var completed:Bool;
	private var gain:Float;
	private var length:Float;
	private var loopTime:Float;
	private var loops:Int;
	private var pauseTime:Float;
	private var peaks:Array<Float>;
	private var pitch:Float;
	private var position:Vector4;
	#if lime_howlerjs
	public var onRefresh = new Event<HTML5AudioSource->Void>();
	public var id:Int;

	public var howl:Howl;
	public var howlSound:Dynamic;
	public var audioNode:AudioNode;
	public var lastAudioNode:AudioNode;

	private var playing:Bool;
	private var analyser:AnalyserNode;
	private var analysers:Array<AnalyserNode>;
	private var channelSplitter:ChannelSplitterNode;
	private var analyserAudioNode:AudioNode;
	private var timeDomainData:JSFloat32Array;
	private var timerID:Int;
	#end

	public function new(parent:AudioSource)
	{
		this.parent = parent;
		length = 0;
		gain = 1;
		pitch = 1;
		#if lime_howlerjs
		id = -1;
		timerID = -1;
		#end
	}

	public function dispose():Void
	{
		#if lime_howlerjs
		timeDomainData = null;

		if (channelSplitter != null)
		{
			channelSplitter.disconnect();
			channelSplitter = null;
		}

		if (analysers != null)
		{
			for (analyser in analysers) analyser.disconnect();
			analysers = null;
		}

		if (analyser != null)
		{
			analyser.disconnect();
			analyser = null;
		}
		#end
	}

	public function load():Void
	{
		#if lime_howlerjs
		if (parent.buffer != null) howl = parent.buffer.__srcHowl;
		if (howl != null)
		{
			howl.load();
			if (!loadAudio())
			{
				var backend = this;
				howl.on("load", function()
				{
					if (backend.playing) backend.play();
				});
			}
		}
		id = -1;
		#end
	}

	public function unload():Void
	{
		// Howl sounds are automatically unloaded if it has stopped.
		#if lime_howlerjs
		disposeNode();
		howl = null;
		id = -1;
		#end
		length = 0;
		loopTime = 0;
		pauseTime = 0;
	}

	public function play():Void
	{
		#if lime_howlerjs
		if (howl == null || (id != -1 && howl.playing(id))) return;

		playing = true;
		completed = false;

		if (!loadAudio()) return;

		inline function setParams():Void
		{
			howl.rate(pitch, id);
			howl.seek(pauseTime / 1000, id);
			howl.volume(gain, id);
			updateLoop();
		}

		if (howlSound != null && id != -1)
		{
			setParams();
			howl.play(id);
		}
		else
		{
			id = howl.play();
			setParams();
		}

		refreshNode();
		resetTimer(Std.int((length - pauseTime) / pitch));
		#end
	}

	private function disposeNode():Void
	{
		#if lime_howlerjs
		howlSound = null;
		audioNode = null;
		lastAudioNode = null;
		#end
	}

	private function refreshNode():Void
	{
		#if lime_howlerjs
		disposeNode();

		howlSound = untyped howl._soundById(id);

		if (untyped howlSound)
		@:privateAccess
		{
			var node = untyped howlSound._node;

			if ((node is MediaElement))
			{
				lime.utils.Log.warn("HTML5 Element Audios are not fully supported! (and buggy) Expect unexpected behaviour.");
			}
			else
			{
				if (untyped howlSound._panner) audioNode = untyped howlSound._panner;
				else audioNode = untyped node;
			}

			if (parent.__effects != null && parent.__effects.length > 0)
			{
				for (effect in parent.__effects)
				{
					if (lastAudioNode == null)
					{
						audioNode.disconnect();
						lastAudioNode = audioNode;
					}

					for (node in effect.__audioNodes)
					{
						lastAudioNode.connect(node);
						lastAudioNode = node;
					}
				}
				lastAudioNode.connect(untyped Howler.masterGain);
			}

			onRefresh.dispatch(this);
		}
		#end
	}

	private function loadAudio():Bool
	{
		if (length != 0) return true;

		length = howl.duration() * 1000;
		return length != 0;
	}

	public function pause():Void
	{
		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			pauseTime = howl.seek(id) * 1000;
			howl.pause(id);
		}
		else
		{
			pauseTime = 0;
		}
		playing = false;
		stopTimer();
		#end
	}

	public function stop():Void
	{
		pauseTime = 0;

		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			howl.stop(id);
		}
		playing = false;
		stopTimer();
		#end
	}

	public function prepare(value:Float):Void
	{
		pauseTime = value + parent.offset;
		if (pauseTime < 0 || !Math.isFinite(pauseTime)) pauseTime = 0;

		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			howl.stop(id);
			howl.seek(pauseTime / 1000, id);
		}
		playing = false;
		stopTimer();
		#end
	}

	// Event Handlers
	private inline function stopTimer():Void
	{
		#if lime_howlerjs
		if (timerID != -1)
		{
			untyped clearInterval(timerID);
			timerID = -1;
		}
		#end
	}

	private inline function resetTimer(ms:Int):Void
	{
		#if lime_howlerjs
		stopTimer();

		var me = this;
		timerID = untyped setInterval(function() me.complete(), ms);
		#end
	}

	private function complete()
	{
		#if lime_howlerjs
		if (loops > 0)
		{
			var wasLooping = howl.loop(id);
			loops--;
			updateLoop();
			if (wasLooping && howl.playing(id))
			{
				resetTimer(Std.int((length - (howl.seek(id) * 1000) - parent.offset) / howl.rate(id)));
				howl.play(id);
			}
			else
			{
				resetTimer(Std.int((length - loopTime - parent.offset) / howl.rate(id)));
				howl.seek((loopTime + parent.offset) / 1000, id);
				howl.play(id);
			}
			pauseTime = loopTime;
		}
		else
		{
			howl.stop(id);

			stopTimer();
			playing = false;
			completed = true;
			pauseTime = 0;
		}

		parent.onComplete.dispatch();
		#end
	}

	// Get & Set Methods
	public function getCurrentTime():Float
	{
		#if lime_howlerjs
		var loaded = howl != null && id != -1;
		if (completed || loaded && playing && !howl.playing(id))
		{
			return length - parent.offset;
		}
		else if (loaded)
		{
			return howl.seek(id) * 1000 - parent.offset;
		}
		#end

		return pauseTime - parent.offset;
	}

	public function setCurrentTime(value:Float):Float
	{
		pauseTime = value + parent.offset;
		if (pauseTime < 0 || !Math.isFinite(pauseTime)) pauseTime = 0;

		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			howl.seek(pauseTime / 1000, id);
			if (howl.playing(id))
			{
				if (pauseTime >= length && !completed)
				{
					completed = true;
					resetTimer(0);
				}
				else resetTimer(Std.int((length - pauseTime - parent.offset) / howl.rate(id)));
			}
		}
		#end

		return value;
	}

	public function getGain():Float
	{
		return gain;
	}

	public function setGain(value:Float):Float
	{
		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			howl.volume(value, id);
		}
		#end
		return gain = value;
	}

	public function getLatency():Float
	{
		return 0;
	}

	public function getLength():Float
	{
		if (length == 0)
		{
			length = howl.duration() * 1000;
			if (length == 0) return 0;
		}

		if (length <= parent.offset) return 0;
		return length - parent.offset;
	}

	public function setLength(value:Float):Float
	{
		length = value + parent.offset;

		#if lime_howlerjs
		if (howl != null)
		{
			var duration = howl.duration() * 1000;
			if (duration != 0 && (length <= 0 || length >= duration)) length = duration;
			if (id != -1 && howl.playing(id)) resetTimer(Std.int((length - howl.seek(id) * 1000) / howl.rate(id)));
		}
		#end
		updateLoop();

		return value;
	}

	public function getLoopTime():Float
	{
		if (loopTime <= parent.offset) return 0;
		return loopTime - parent.offset;
	}

	public function setLoopTime(value:Float):Float
	{
		loopTime = value + parent.offset;

		#if lime_howlerjs
		if (howl != null)
		{
			if (loopTime < 0) loopTime = 0;
			else
			{
				var duration = howl.duration() * 1000;
				if (loopTime >= duration) loopTime = duration;
			}
		}
		#end
		updateLoop();
		return value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		loops = value;
		updateLoop();
		return value;
	}

	private function updateLoop()
	{
		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			if (loops > 0) howl.loop(loopTime, length, id);
			else howl.loop(false, id);
		}
		#end
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

		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			//howl.pos(0, 0, 0, id);
			howl.stereo(value, id);
		}
		#end
		return value;
	}

	public function getPitch():Float
	{
		return pitch;
	}

	public function setPitch(value:Float):Float
	{
		#if lime_howlerjs
		if (howl != null && id != -1)
		{
			if (value > 1e-2)
			{
				howl.rate(value, id);
				if (playing && !howl.playing(id))
				{
					howl.seek(pauseTime / 1000, id);
					howl.play(id);
				}

				resetTimer(Std.int((length - howl.seek(id) * 1000) / howl.rate(id)));
			}
			else if (playing)
			{
				pauseTime = howl.seek(id) * 1000;
				howl.pause(id);
			}
		}
		#end
		return pitch = value;
	}

	public function getPlaying():Bool
	{
		#if lime_howlerjs
		if (howl != null && id != -1) return playing && howl.playing(id);
		#end
		return false;
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

		/*#if lime_howlerjs
		if (howl != null && id != -1)
		{
			howl.pos(position.x, position.y, position.z, id);
		}
		#end*/

		return position;
	}

	// Waveform related functions
	public function getPeaks(offsetMs:Float):Array<Float>
	{
		if (peaks == null) peaks = [];

		#if lime_howlerjs
		updateAnalyserAudioNode();
		if (analyserAudioNode == null || !playing)
		{
			for (i in 0...(parent.buffer.channels > 0 ? parent.buffer.channels : 2)) peaks[i] = 0;
			return peaks;
		}

		if (timeDomainData == null) timeDomainData = new JSFloat32Array(2048);

		var min:Float, max:Float;
		for (i in 0...channelSplitter.numberOfOutputs)
		{
			min = 1;
			max = -1;

			analysers[i].fftSize = 2048;
			analysers[i].getFloatTimeDomainData(timeDomainData);
			for (v in timeDomainData)
			{
				if (v > max) max = v;
				else if (v < min) min = v;
			}

			peaks[i] = (max - min) / 2;
		}
		#end
		return peaks;
	}

	public function getFloatTimeDomainData(array:Float32Array, size:Int, channel:Int, offset:Int):Int
	{
		#if lime_howlerjs
		updateAnalyserAudioNode();
		if (analyserAudioNode == null || !playing) return 0;

		var bits = 0;
		while ((size >>= 1) > 0) bits++;

		if (channel == -1)
		{
			analyser.fftSize = 1 << bits;
			analyser.getFloatTimeDomainData(array);
			return analyser.fftSize;
		}
		else if (analysers[channel] != null)
		{
			var analyser = analysers[channel];
			analyser.fftSize = 1 << bits;
			analyser.getFloatTimeDomainData(array);
			return analyser.fftSize;
		}
		#end

		return 0;
	}

	public function getByteTimeDomainData(array:UInt8Array, size:Int, channel:Int, offset:Int):Int
	{
		#if lime_howlerjs
		updateAnalyserAudioNode();
		if (analyserAudioNode == null || !playing) return 0;

		var bits = 0;
		while ((size >>= 1) > 0) bits++;

		if (channel == -1)
		{
			analyser.fftSize = 1 << bits;
			analyser.getByteTimeDomainData(array);
			return analyser.fftSize;
		}
		else if (analysers[channel] != null)
		{
			var analyser = analysers[channel];
			analyser.fftSize = 1 << bits;
			analyser.getByteTimeDomainData(array);
			return analyser.fftSize;
		}
		#end

		return 0;
	}

	inline function updateAnalyserAudioNode():Void
	{
		var previousAnalyserAudioNode = analyserAudioNode;
		if (howlSound != null && (untyped howlSound._node))
		{
			if (untyped howlSound._node.bufferSource) analyserAudioNode = untyped howlSound._node.bufferSource;
			else analyserAudioNode = null;
		}
		else analyserAudioNode = null;

		if (previousAnalyserAudioNode != analyserAudioNode)
		{
			if (analyserAudioNode != null)
			{
				var context:BaseAudioContext = untyped audioNode.context;

				var channels = parent.buffer.channels > 0 ? parent.buffer.channels : 2;
				if (channelSplitter == null || channelSplitter.context != context || channelSplitter.numberOfOutputs != channels)
					channelSplitter = new ChannelSplitterNode(context, {numberOfOutputs: channels});

				var analyser:AnalyserNode;
				if (analysers == null) analysers = [];
				for (i in 0...channels)
				{
					analyser = analysers[i];
					if (analyser == null || analyser.context != context) analysers[i] = analyser = new AnalyserNode(context);
					else analyser.disconnect();

					analyser.maxDecibels = 0;
					analyser.minDecibels = -120;

					channelSplitter.connect(analyser, i);
				}

				analyser = this.analyser;
				if (analyser == null || analyser.context != context) analyser = this.analyser = new AnalyserNode(context);
				else analyser.disconnect();

				analyser.maxDecibels = 0;
				analyser.minDecibels = -120;

				analyserAudioNode.connect(channelSplitter);
				analyserAudioNode.connect(analyser);
			}
		}
	}

	// Real-time audio effects
	public function addEffect(index:Int):Void
	{
		if (audioNode != null)
		@:privateAccess
		{
			if (lastAudioNode == null) lastAudioNode = audioNode;
			lastAudioNode.disconnect();

			var effect = parent.__effects[index];
			for (node in effect.__audioNodes)
			{
				lastAudioNode.connect(node);
				lastAudioNode = node;
			}
			lastAudioNode.connect(untyped Howler.masterGain);
		}
	}

	public function updateEffect(index:Int):Void
	{
		// do nothing
	}

	public function removeEffect(index:Int):Void
	{
		if (audioNode != null && lastAudioNode != null)
		@:privateAccess
		{
			lastAudioNode.disconnect();
			lastAudioNode = audioNode;

			for (i => effect in parent.__effects)
			{
				if (i == index) continue;

				for (node in effect.__audioNodes)
				{
					lastAudioNode.connect(node);
					lastAudioNode = node;
				}
			}
			lastAudioNode.connect(untyped Howler.masterGain);
		}
	}
}
