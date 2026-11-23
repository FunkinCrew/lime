package lime._internal.backend.native;

#if cpp
import cpp.Pointer;
#end

import lime.media.AudioManager;
import lime.media.AudioSource;
import lime.media.miniaudio.MAAudioBuffer;
import lime.media.miniaudio.MAAudioBufferConfig;
import lime.media.miniaudio.MAAudioRingBuffer;
import lime.media.miniaudio.MASound;
import lime.media.miniaudio.MASoundConfig;

@:access(lime.media.AudioBuffer)
class NativeAudioSource
{
	private var preRingBuffers:Array<MAAudioRingBuffer> = [];
	private var postRingBuffers:Array<MAAudioRingBuffer> = [];
	private var buffer:MAAudioBuffer;
	private var handle:MASound;
	private var parent:AudioSource;

	public function new(parent:AudioSource):Void
	{
		this.parent = parent;
	}

	public function dispose():Void
	{
		if (handle != null)
		{
			handle.stop();
			handle.uninit();
			handle = null;

			parent.buffer.__audioSources.remove(parent);
		}

		if (buffer != null)
		{
			buffer.uninit();
			buffer = null;
		}

		preRingBuffers = [];

		postRingBuffers = [];
	}

	public function init():Void
	{
		if (handle == null)
		{
			if (parent.buffer.__srcMADecoder != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pDataSource = parent.buffer.__srcMADecoder;
				config.pNotifications.onAtEnd = sound_atEnd;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.__srcMAAudioBuffer != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pDataSource = parent.buffer.__srcMAAudioBuffer;
				config.pNotifications.onAtEnd = sound_atEnd;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.__srcMAAudioRingBuffer != null)
			{
				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pDataSource = parent.buffer.__srcMAAudioRingBuffer;
				config.pNotifications.onAtEnd = sound_atEnd;

				handle = MASound.init(AudioManager.engine, config);
			}
			else if (parent.buffer.data != null && parent.buffer.data.length > 0)
			{
				if (buffer == null)
				{
					buffer = MAAudioBuffer.init(MAAudioBufferConfig.init(parent.buffer.format, parent.buffer.channels, parent.buffer.sampleRate,
						parent.buffer.frames, #if cpp Pointer.ofArray(parent.buffer.data.buffer.getData()) #else null #end));
				}

				final config:MASoundConfig = MASoundConfig.init();

				config.flags = MASound.FLAG_NO_SPATIALIZATION;
				config.pDataSource = buffer;
				config.pNotifications.onAtEnd = sound_atEnd;

				handle = MASound.init(AudioManager.engine, config);
			}

			if (handle != null)
			{
				for (ringBuffer in preRingBuffers)
				{
					handle.add_tap(ringBuffer, false);
				}

				for (ringBuffer in postRingBuffers)
				{
					handle.add_tap(ringBuffer, true);
				}

				parent.buffer.__audioSources.push(parent);
			}
		}
	}

	public function play():Void
	{
		if (handle != null)
		{
			handle.start();
		}
	}

	public function pause():Void
	{
		if (handle != null)
		{
			handle.stop();
		}
	}

	public function stop():Void
	{
		if (handle != null)
		{
			handle.stop();

			handle.seek_to_pcm_frame(0);
		}
	}

	public function addPreRingBuffer(rb:MAAudioRingBuffer):Bool
	{
		if (preRingBuffers.contains(rb))
			return true;

		if (handle != null && !handle.add_tap(rb, false))
			return false;

		preRingBuffers.push(rb);

		return true;
	}

	public function removePreRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (preRingBuffers.remove(rb))
		{
			if (handle != null)
			{
				handle.remove_tap(rb, false);
			}
		}
	}

	public function addPostRingBuffer(rb:MAAudioRingBuffer):Bool
	{
		if (postRingBuffers.contains(rb))
			return true;

		if (handle != null && !handle.add_tap(rb, true))
			return false;

		postRingBuffers.push(rb);

		return true;
	}

	public function removePostRingBuffer(rb:MAAudioRingBuffer):Void
	{
		if (postRingBuffers.remove(rb))
		{
			if (handle != null)
			{
				handle.remove_tap(rb, true);
			}
		}
	}

	// Event Handlers

	private function sound_atEnd():Void
	{
		parent.onComplete.dispatch();
	}

	// Get & Set Methods
	public function getLength():Float
	{
		return handle != null ? handle.get_length_in_seconds() * 1000.0 : 0;
	}

	public function getCurrentTime():Float
	{
		return handle != null ? cast handle.get_cursor_in_seconds() * 1000.0 : 0;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (handle != null)
		{
			handle.seek_to_second(value / 1000.0);
		}

		return value;
	}

	public function getGain():Float
	{
		return handle != null ? handle.get_volume() : 1;
	}

	public function setGain(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_volume(value);
		}

		return value;
	}

	public function getPitch():Float
	{
		return handle != null ? handle.get_pitch() : 1;
	}

	public function setPitch(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_pitch(value);
		}

		return value;
	}

	public function getPan():Float
	{
		return handle != null ? handle.get_pan() : 0;
	}

	public function setPan(value:Float):Float
	{
		if (handle != null)
		{
			handle.set_pan(value);
		}

		return value;
	}

	public function getLoop():Bool
	{
		return handle != null ? handle.is_looping() : false;
	}

	public function setLoop(value:Bool):Bool
	{
		if (handle != null)
		{
			handle.set_looping(value);
		}

		return value;
	}

	public function getPlaying():Bool
	{
		return handle != null ? handle.is_playing() : false;
	}
}
