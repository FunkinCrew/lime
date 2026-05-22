package lime._internal.backend.native;

import haxe.Int64;
import lime.app.Application;
import lime.math.Vector4;
import lime.media.openal.AL;
import lime.media.openal.ALBuffer;
import lime.media.openal.ALSource;
import lime.media.AudioManager;
import lime.media.AudioSource;
import lime.utils.UInt8Array;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.media.AudioBuffer)
class NativeAudioSource
{
	private static var hasDirectChannelsExt:Null<Bool>;
	private static var hasALSoftLatencyExt:Null<Bool>;

	private var completed:Bool;
	private var dataLength:Int;
	private var format:Int;
	private var handle:ALSource;
	private var length:Null<Int>;
	private var loops:Int;
	private var parent:AudioSource;
	private var playing:Bool;
	private var position:Vector4;
	private var samples:Int;

	public function new(parent:AudioSource)
	{
		this.parent = parent;

		position = new Vector4();
	}

	public function dispose():Void
	{
		if (handle != null)
		{
			if (Application.current != null)
			{
				if (Application.current.onUpdate.has(checkPlay))
				{
					Application.current.onUpdate.remove(checkPlay);
				}
			}

			stop();

			AL.sourcei(handle, AL.BUFFER, null);

			AL.deleteSource(handle);

			handle = null;
		}
	}

	public function init():Void
	{
		if (hasALSoftLatencyExt == null)
		{
			hasALSoftLatencyExt = AL.isExtensionPresent("AL_SOFT_source_latency");
		}

		if (hasDirectChannelsExt == null)
		{
			hasDirectChannelsExt = AL.isExtensionPresent("AL_SOFT_direct_channels") && AL.isExtensionPresent("AL_SOFT_direct_channels_remix");
		}

		format = 0;

		switch (parent.buffer.dataFormat)
		{
			case S16:
				if (parent.buffer.channels == 1)
				{
					format = AL.FORMAT_MONO16;
				}
				else if (parent.buffer.channels == 2)
				{
					format = AL.FORMAT_STEREO16;
				}
			case F32:
				if (parent.buffer.channels == 1)
				{
					format = AL.FORMAT_MONO_FLOAT32;
				}
				else if (parent.buffer.channels == 2)
				{
					format = AL.FORMAT_STEREO_FLOAT32;
				}
		}

		handle = AL.createSource();

		if (parent.buffer.__srcBuffer == null)
		{
			parent.buffer.__srcBuffer = AL.createBuffer();

			if (parent.buffer.__srcBuffer != null)
			{
				AL.bufferData(parent.buffer.__srcBuffer, format, parent.buffer.data, parent.buffer.data.length, parent.buffer.sampleRate);
			}
		}

		AL.sourcei(handle, AL.BUFFER, parent.buffer.__srcBuffer);

		if (hasDirectChannelsExt)
		{
			AL.sourcei(handle, AL.DIRECT_CHANNELS_SOFT, AL.REMIX_UNMATCHED_SOFT);
		}

		dataLength = parent.buffer.data.length;

		samples = Std.int((dataLength * 8.0) / (parent.buffer.channels * parent.buffer.bitsPerSample));

		if (!Application.current.onUpdate.has(checkPlay))
		{
			Application.current.onUpdate.add(checkPlay);
		}
	}

	public function play():Void
	{
		if (playing || handle == null)
		{
			return;
		}

		playing = true;

		setCurrentTime(completed ? 0 : getCurrentTime());
	}

	public function pause():Void
	{
		playing = false;

		if (handle == null)
		{
			return;
		}

		AL.sourcePause(handle);
	}

	public function stop():Void
	{
		if (playing && handle != null && AL.getSourcei(handle, AL.SOURCE_STATE) == AL.PLAYING)
		{
			AL.sourceStop(handle);
		}

		playing = false;

		setCurrentTime(0);
	}

	// Event Handlers

	private function checkPlay(_):Void
	{
		if (AL.getSourcei(handle, AL.SOURCE_STATE) == AL.PLAYING)
		{
			return;
		}

		if (loops > 0)
		{
			playing = false;
			loops--;
			setCurrentTime(0);
			play();
			return;
		}

		if (!completed)
		{
			stop();
			parent.onComplete.dispatch();
		}

		completed = true;
	}

	// Get & Set Methods
	public function getCurrentTime():Int
	{
		if (completed || (handle != null && AL.getSourcei(handle, AL.SOURCE_STATE) == AL.STOPPED && loops <= 0))
		{
			return getLength();
		}
		else if (handle != null)
		{
			var offset = AL.getSourcei(handle, AL.BYTE_OFFSET);
			var ratio = (offset / dataLength);
			var totalSeconds = samples / parent.buffer.sampleRate;
			var time = Std.int(totalSeconds * ratio * 1000) - parent.offset;

			return time < 0 ? 0 : time;
		}

		return 0;
	}

	public function setCurrentTime(value:Int):Int
	{
		if (handle != null)
		{
			AL.sourceRewind(handle);

			var secondOffset = (value + parent.offset) / 1000;
			var totalSeconds = samples / parent.buffer.sampleRate;

			if (secondOffset < 0) secondOffset = 0;
			if (secondOffset > totalSeconds) secondOffset = totalSeconds;

			var ratio = (secondOffset / totalSeconds);
			var totalOffset = Std.int(dataLength * ratio);

			AL.sourcei(handle, AL.BYTE_OFFSET, totalOffset);
			if (playing) AL.sourcePlay(handle);
		}

		if (playing)
		{
			var timeRemaining = Std.int((getLength() - value) / getPitch());

			if (timeRemaining > 0)
			{
				completed = false;
			}
			else
			{
				playing = false;
				completed = true;
			}
		}

		return value;
	}

	public function getGain():Float
	{
		if (handle != null)
		{
			return AL.getSourcef(handle, AL.GAIN);
		}
		else
		{
			return 1;
		}
	}

	public function setGain(value:Float):Float
	{
		if (handle != null)
		{
			AL.sourcef(handle, AL.GAIN, value);
		}

		return value;
	}

	public function getLength():Int
	{
		if (length != null)
		{
			return length;
		}

		return Std.int(samples / parent.buffer.sampleRate * 1000) - parent.offset;
	}

	public function setLength(value:Int):Int
	{
		return length = value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPitch():Float
	{
		if (handle != null)
		{
			return AL.getSourcef(handle, AL.PITCH);
		}
		else
		{
			return 1;
		}
	}

	public function setPitch(value:Float):Float
	{
		if (handle != null)
		{
			AL.sourcef(handle, AL.PITCH, value);
		}

		return value;
	}

	public function getPosition():Vector4
	{
		if (handle != null)
		{
			var value = AL.getSource3f(handle, AL.POSITION);
			position.x = value[0];
			position.y = value[1];
			position.z = value[2];
		}

		return position;
	}

	public function setPosition(value:Vector4):Vector4
	{
		position.x = value.x;
		position.y = value.y;
		position.z = value.z;
		position.w = value.w;

		if (handle != null)
		{
			AL.distanceModel(AL.NONE);
			AL.source3f(handle, AL.POSITION, position.x, position.y, position.z);
		}

		return position;
	}

	public function getLatency():Float
	{
		if (hasALSoftLatencyExt)
		{
			var offsets = AL.getSourcedvSOFT(handle, AL.SEC_OFFSET_LATENCY_SOFT, 2);

			if (offsets != null)
			{
				return offsets[1] * 1000;
			}
		}

		return 0;
	}
}
