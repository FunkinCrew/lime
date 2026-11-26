package lime._internal.backend.html5;

import lime.media.AudioBuffer;
import lime.media.AudioSource;
import lime.media.howlerjs.Howl;
import lime.media.howlerjs.Howler;

@:access(lime.media.AudioBuffer)
class HTML5AudioSource
{
	private var handle:Int = -1;
	private var playPending:Bool = false;
	private var time:Float = 0;
	private var gain:Float = 1;
	private var pitch:Float = 1;
	private var pan:Float = 0;
	private var looped:Bool = false;

	private var parent:AudioSource;

	public function new(parent:AudioSource):Void
	{
		this.parent = parent;
	}

	public function dispose():Void
	{
		playPending = false;

		final owner:Howl = findHowlForHandle(handle);
		final current:Howl = parent.buffer != null ? parent.buffer.__srcHowl : null;
		final howl:Howl = owner != null ? owner : current;

		if (howl != null && handle >= 0)
		{
			howl.off("playerror", howl_onError, handle);
			howl.off("loaderror", howl_onError, handle);
			howl.off("end", howl_onEnd, handle);

			if (hasSound(howl, handle))
			{
				howl.loop(false, handle);
				howl.stop(handle);
			}
		}

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

		if (playPending)
		{
			if (howl.state() == "loading")
			{
				return;
			}

			playPending = false;
		}

		if (handle >= 0)
		{
			final owner:Howl = findHowlForHandle(handle);

			if (owner == howl && hasSound(howl, handle))
			{
				if (howl.state() == "loaded" && !howl.playing(handle))
				{
					howl.play(handle);
				}

				return;
			}

			final oldHowl:Howl = owner != null ? owner : howl;
			oldHowl.off("playerror", howl_onError, handle);
			oldHowl.off("end", howl_onEnd, handle);
			oldHowl.off("loaderror", howl_onError, handle);

			if (owner != null)
			{
				owner.loop(false, handle);
				owner.stop(handle);
			}

			handle = -1;
			time = 0;
		}

		if (howl.state() != "loaded")
		{
			waitForLoad(howl);

			return;
		}

		startPlayback(howl);
	}

	public function pause():Void
	{
		playPending = false;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			time = getCurrentTime();

			howl.pause(handle);
		}
	}

	public function stop():Void
	{
		playPending = false;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.stop(handle);

			// Keep this sound out of Howler's inactive pool so its ID stays stable.
			howl.seek(0, handle);
		}

		time = 0;
	}

	private function waitForLoad(howl:Howl):Void
	{
		if (playPending)
		{
			return;
		}

		playPending = true;

		howl.once("load", function()
		{
			if (!playPending)
			{
				return;
			}

			playPending = false;

			if (parent.buffer != null && parent.buffer.__srcHowl == howl && howl.state() == "loaded")
			{
				startPlayback(howl);
			}
			else if (parent.buffer != null && parent.buffer.__srcHowl != null)
			{
				play();
			}
		});

		howl.once("loaderror", function(id:Dynamic, message:Dynamic)
		{
			if (!playPending)
			{
				return;
			}

			playPending = false;

			if (parent.buffer != null && parent.buffer.__srcHowl != howl)
			{
				play();
			}
		});

		if (howl.state() == "unloaded")
		{
			final howls:Dynamic = untyped Howler._howls;

			if (howls != null && howls.indexOf(howl) == -1)
			{
				howls.push(howl);
			}

			howl.load();
		}
	}

	private function startPlayback(howl:Howl):Void
	{
		if (parent.buffer == null || parent.buffer.__srcHowl != howl || howl.state() != "loaded" || handle >= 0)
		{
			return;
		}

		// Use an explicit sprite so Howler won't resume another paused source sharing this buffer.
		final newHandle:Dynamic = parent.buffer.__srcHowlerDefaultSprite != null ? howl.play(parent.buffer.__srcHowlerDefaultSprite) : howl.play("__default");

		if (newHandle == null || newHandle < 0 || !hasSound(howl, newHandle))
		{
			return;
		}

		handle = cast newHandle;

		howl.on("end", howl_onEnd, handle);
		howl.on("playerror", howl_onError, handle);
		howl.on("loaderror", howl_onError, handle);

		if (time > 0)
		{
			howl.seek(time / 1000.0, handle);
		}

		howl.volume(gain, handle);
		howl.rate(pitch, handle);
		howl.stereo(pan, handle);
		howl.loop(looped, handle);
	}

	private function hasSound(howl:Howl, id:Int):Bool
	{
		return id >= 0 && howl.hasSound(id);
	}

	private function findHowlForHandle(id:Int):Howl
	{
		if (id < 0)
		{
			return null;
		}

		final current:Howl = parent.buffer != null ? parent.buffer.__srcHowl : null;

		if (current != null && hasSound(current, id))
		{
			return current;
		}

		// just in case
		final howls:Array<Dynamic> = untyped Howler._howls;

		if (howls != null)
		{
			for (entry in howls)
			{
				final candidate:Howl = cast entry;

				if (candidate != null && hasSound(candidate, id))
				{
					return candidate;
				}
			}
		}

		return null;
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

		if (howl != null && howl.state() == "loaded" && hasSound(howl, id))
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
		final howl:Howl = parent.buffer != null ? parent.buffer.__srcHowl : null;

		if (howl == null || howl.state() != "loaded")
		{
			return 0;
		}

		if (hasSound(howl, handle))
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

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
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

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.seek(value / 1000.0, handle);
		}

		return time;
	}

	public function getGain():Float
	{
		final howl:Howl = findHowlForHandle(handle);

		return howl != null && howl.state() == "loaded" && hasSound(howl, handle) ? howl.volume(handle) : gain;
	}

	public function setGain(value:Float):Float
	{
		gain = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.volume(value, handle);
		}

		return gain;
	}

	public function getPitch():Float
	{
		final howl:Howl = findHowlForHandle(handle);

		return howl != null && howl.state() == "loaded" && hasSound(howl, handle) ? howl.rate(handle) : pitch;
	}

	public function setPitch(value:Float):Float
	{
		pitch = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.rate(value, handle);
		}

		return pitch;
	}

	public function getPan():Float
	{
		final howl:Howl = findHowlForHandle(handle);

		return howl != null && howl.state() == "loaded" && hasSound(howl, handle) ? cast howl.stereo(null, handle) : pan;
	}

	public function setPan(value:Float):Float
	{
		pan = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.stereo(value, handle);
		}

		return pan;
	}

	public function getLoop():Bool
	{
		final howl:Howl = findHowlForHandle(handle);

		return howl != null && howl.state() == "loaded" && hasSound(howl, handle) ? howl.loop(handle) : looped;
	}

	public function setLoop(value:Bool):Bool
	{
		looped = value;

		final howl:Howl = findHowlForHandle(handle);

		if (howl != null && howl.state() == "loaded" && hasSound(howl, handle))
		{
			howl.loop(value, handle);
		}

		return looped;
	}

	public function getPlaying():Bool
	{
		final howl:Howl = findHowlForHandle(handle);

		return howl != null && howl.state() == "loaded" && hasSound(howl, handle) && howl.playing(handle);
	}
}
