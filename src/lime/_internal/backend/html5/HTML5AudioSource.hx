package lime._internal.backend.html5;

import lime.media.AudioBuffer;
import lime.media.AudioProcessBuffer;
import lime.media.AudioSource;
import lime.media.howlerjs.Howl;
import lime.media.howlerjs.Howler;

@:access(lime.media.AudioBuffer)
class HTML5AudioSource
{
	private var handle:Int = -1;
	private var time:Float = 0;
	private var gain:Float = 1;
	private var pitch:Float = 1;
	private var pan:Float = 0;
	private var looped:Bool = false;

	private var parent:AudioSource;
	private var activeHowl:Null<Howl> = null;

	private var audioProcessListeners:Array<AudioProcessBuffer->Void> = [];
	private var howlAudioProcessCallback:Null<Int->AudioProcessBuffer->Void> = null;

	public function new(parent:AudioSource):Void
	{
		this.parent = parent;
	}

	public function dispose():Void
	{
		removeAllAudioProcessListeners();

		final howl:Null<Howl> = activeHowl;

		if (howl != null && handle >= 0)
		{
			howl.off("playerror", howl_onError, handle);
			howl.off("loaderror", howl_onError, handle);
			howl.off("end", howl_onEnd, handle);

			if (hasHowlSound(howl, handle))
			{
				howl.loop(false, handle);
				howl.stop(handle);
			}
		}

		activeHowl = null;
		handle = -1;
		time = 0;
		gain = 1;
		pitch = 1;
		pan = 0;
		looped = false;
	}

	public function init():Void
	{
		// There isnt anything to initialize.
	}

	public function play():Void
	{
		final buffer:AudioBuffer = parent.buffer;

		if (buffer == null || buffer.__srcHowl == null)
		{
			return;
		}

		final howl:Howl = buffer.__srcHowl;

		if (handle >= 0)
		{
			if (activeHowl == howl && hasHowlSound(howl, handle))
			{
				if (!howl.playing(handle))
				{
					howl.play(handle);
				}

				return;
			}

			final oldHowl:Howl = activeHowl;

			if (oldHowl != null)
			{
				detachAudioProcessListener(oldHowl, handle);
				oldHowl.off("playerror", howl_onError, handle);
				oldHowl.off("loaderror", howl_onError, handle);
				oldHowl.off("end", howl_onEnd, handle);

				if (hasHowlSound(oldHowl, handle))
				{
					oldHowl.loop(false, handle);
					oldHowl.stop(handle);
				}
			}

			activeHowl = null;
			handle = -1;
			time = 0;
		}

		prepareForProgressivePlayback(howl);
		startPlayback(howl);
	}

	public function pause():Void
	{
		final howl:Null<Howl> = activeHowl;

		if (howl != null && handle >= 0 && hasHowlSound(howl, handle))
		{
			time = getCurrentTime();
			howl.pause(handle);
		}
	}

	public function stop():Void
	{
		final howl:Null<Howl> = activeHowl;

		if (howl != null && handle >= 0 && hasHowlSound(howl, handle))
		{
			howl.stop(handle);

			// Keep this sound out of Howler's inactive pool so its ID stays stable.
			howl.seek(0, handle);
		}

		time = 0;
	}

	private function prepareForProgressivePlayback(howl:Howl):Void
	{
		untyped Howler._canPlayEvent = "canplay";

		final state:String = howl.state();
		if (state == "unloaded")
		{
			untyped howl._preload = "auto";
			howl.load();
			return;
		}

		if (state == "loading")
		{
			final sounds:Dynamic = untyped howl._sounds;
			if (sounds != null)
			{
				var i:Int = 0;
				while (i < sounds.length)
				{
					final node:Dynamic = sounds[i] != null ? sounds[i]._node : null;
					if (node != null && node.preload != "auto" && node.readyState < 3)
					{
						node.preload = "auto";
						node.load();
					}
					i++;
				}
			}
		}
	}

	private function startPlayback(howl:Howl):Void
	{
		if (parent.buffer == null || parent.buffer.__srcHowl != howl || handle >= 0)
		{
			return;
		}

		final newHandle:Int = parent.buffer.__srcHowlerDefaultSprite != null ? howl.play(parent.buffer.__srcHowlerDefaultSprite) : howl.play("__default");

		if (newHandle < 0 || !hasHowlSound(howl, newHandle))
		{
			return;
		}

		handle = newHandle;
		activeHowl = howl;

		howl.on("end", howl_onEnd, handle);
		howl.on("playerror", howl_onError, handle);
		howl.on("loaderror", howl_onError, handle);
		
		attachAudioProcessListener(howl, handle);

		if (time > 0)
		{
			howl.seek(time / 1000.0, handle);
		}

		howl.volume(gain, handle);
		howl.rate(pitch, handle);
		howl.stereo(pan, handle);
		howl.loop(looped, handle);
	}

	public function addAudioProcessListener(listener:AudioProcessBuffer->Void):Void
	{
		if (listener == null || audioProcessListeners.indexOf(listener) != -1)
		{
			return;
		}

		final firstListener:Bool = audioProcessListeners.length == 0;
		audioProcessListeners.push(listener);

		if (howlAudioProcessCallback == null)
		{
			howlAudioProcessCallback = function(id:Int, buffer:AudioProcessBuffer):Void
			{
				if (id != handle)
				{
					return;
				}

				var i:Int = audioProcessListeners.length;
				while (i-- > 0)
				{
					audioProcessListeners[i](buffer);
				}
			};
		}

		if (firstListener)
		{
			attachAudioProcessListener(activeHowl, handle);
		}
	}

	public function removeAudioProcessListener(listener:AudioProcessBuffer->Void):Void
	{
		if (listener == null || !audioProcessListeners.remove(listener))
		{
			return;
		}

		if (audioProcessListeners.length == 0)
		{
			detachAudioProcessListener(activeHowl, handle);
			howlAudioProcessCallback = null;
		}
	}

	private function removeAllAudioProcessListeners():Void
	{
		detachAudioProcessListener(activeHowl, handle);
		audioProcessListeners.resize(0);
		howlAudioProcessCallback = null;
	}

	private function attachAudioProcessListener(howl:Null<Howl>, id:Int):Void
	{
		if (howl != null && id >= 0 && audioProcessListeners.length > 0 && howlAudioProcessCallback != null && hasHowlSound(howl, id))
		{
			howl.onAudioProcess(howlAudioProcessCallback, id);
		}
	}

	private function detachAudioProcessListener(howl:Null<Howl>, id:Int):Void
	{
		if (howl != null && id >= 0 && howlAudioProcessCallback != null)
		{
			howl.offAudioProcess(howlAudioProcessCallback, id);
		}
	}

	private function hasHowlSound(howl:Null<Howl>, id:Int):Bool
	{
		return howl != null && id >= 0 && howl.hasSound(id);
	}

	private function findHowlForHandle(id:Int):Howl
	{
		return id >= 0 && id == handle ? activeHowl : null;
	}

	// Event Handlers
	private function howl_onEnd(id:Int):Void
	{
		if (handle != id)
		{
			return;
		}

		time = 0;

		final howl:Howl = findHowlForHandle(id);

		if (howl != null && howl.loop(id))
		{
			return;
		}

		if (howl != null && howl.state() == "loaded" && hasHowlSound(howl, id))
		{
			// Reserve the ended ID for a synchronous replay from onComplete.
			howl.seek(0, id);
		}

		parent.onComplete.dispatch();
	}

	private function howl_onError(id:Int, err:Dynamic):Void
	{
		if (handle == id)
		{
			time = getCurrentTime();
		}
	}

	// Get & Set Methods
	public function getLength():Float
	{
		final howl:Null<Howl> = activeHowl != null ? activeHowl : (parent.buffer != null ? parent.buffer.__srcHowl : null);

		if (howl == null || howl.state() != "loaded")
		{
			return 0;
		}

		if (hasHowlSound(howl, handle))
		{
			return howl.duration(handle) * 1000.0;
		}

		if (parent.buffer.__srcHowlerDefaultSprite != null)
		{
			return howl.spriteDuration(parent.buffer.__srcHowlerDefaultSprite) * 1000.0;
		}

		return howl.duration() * 1000.0;
	}

	public function getCurrentTime():Float
	{
		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle))
		{
			final seek:Float = cast howl.seek(handle) * 1000.0;

			if (seek == seek)
			{
				time = Math.max(0, seek);
			}
		}

		return time;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (value != value || value < 0)
		{
			value = 0;
		}

		time = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && hasHowlSound(howl, handle))
		{
			howl.seek(value / 1000.0, handle);
		}

		return time;
	}

	public function getGain():Float
	{
		final howl:Howl = findHowlForHandle(handle);
		return howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle) ? howl.volume(handle) : gain;
	}

	public function setGain(value:Float):Float
	{
		gain = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && hasHowlSound(howl, handle))
		{
			howl.volume(value, handle);
		}

		return gain;
	}

	public function getPitch():Float
	{
		final howl:Howl = findHowlForHandle(handle);
		return howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle) ? howl.rate(handle) : pitch;
	}

	public function setPitch(value:Float):Float
	{
		pitch = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && hasHowlSound(howl, handle))
		{
			howl.rate(value, handle);
		}

		return pitch;
	}

	public function getPan():Float
	{
		final howl:Howl = findHowlForHandle(handle);
		return howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle) ? cast howl.stereo(null, handle) : pan;
	}

	public function setPan(value:Float):Float
	{
		pan = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && hasHowlSound(howl, handle))
		{
			howl.stereo(value, handle);
		}

		return pan;
	}

	public function getLoop():Bool
	{
		final howl:Howl = findHowlForHandle(handle);
		return howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle) ? howl.loop(handle) : looped;
	}

	public function setLoop(value:Bool):Bool
	{
		looped = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && hasHowlSound(howl, handle))
		{
			howl.loop(value, handle);
		}

		return looped;
	}

	public function getPlaying():Bool
	{
		final howl:Howl = findHowlForHandle(handle);
		return howl != null && howl.state() == "loaded" && hasHowlSound(howl, handle) && howl.playing(handle);
	}
}
