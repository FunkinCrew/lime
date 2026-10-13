package lime._internal.backend.html5;

import lime.media.AudioSource;
import lime.media.howlerjs.Howl;

@:access(lime.media.AudioBuffer)
class HTML5AudioSource
{
	private var handle:Int = -1;
	private var loops:Int = 0;
	private var time:Float = 0;
	private var gain:Float = 1;
	private var pitch:Float = 1;
	private var pan:Float = 0;
	private var parent:AudioSource;

	public function new(parent:AudioSource):Void
	{
		this.parent = parent;
	}

	public function dispose():Void
	{
		stop();

		gain = 1;
		pitch = 1;
		pan = 0;
	}

	public function init():Void
	{
		// There isnt anything to intialize
	}

	public function play():Void
	{
		if (parent.buffer.__srcHowl != null)
		{
			if (handle != -1)
			{
				parent.buffer.__srcHowl.play(handle);
			}
			else
			{
				if (parent.buffer.__srcHowlerDefaultSprite != null)
				{
					handle = parent.buffer.__srcHowl.play(parent.buffer.__srcHowlerDefaultSprite);
				}
				else
				{
					handle = parent.buffer.__srcHowl.play();
				}

				parent.buffer.__srcHowl.once("end", howl_onEnd, handle);

				parent.buffer.__srcHowl.once("playerror", howl_onError, handle);

				setCurrentTime(time);

				setGain(gain);

				setPitch(pitch);

				setPan(pan);
			}
		}
	}

	public function pause():Void
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.pause(handle);
		}
	}

	public function stop():Void
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.off("playerror", howl_onError, handle);
			parent.buffer.__srcHowl.off("end", howl_onEnd, handle);
			parent.buffer.__srcHowl.stop(handle);
			handle = -1;
		}

		time = 0;
	}

	// Event Handlers
	private function howl_onEnd():Void
	{
		if (loops > 0)
		{
			loops--;
			stop();
			play();
			return;
		}

		time = 0;

		final oldID:Int = handle;

		parent.onComplete.dispatch();

		if (handle == oldID)
		{
			handle = -1;
		}
	}

	private function howl_onError(handle:Int, err:Dynamic):Void
	{
		if (this.handle == handle && !Std.isOfType(err, String))
		{
			this.handle = -1;
			this.time = 0;
		}
	}

	// Get & Set Methods
	public function getLength():Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			if (parent.buffer.__srcHowlerDefaultSprite != null)
			{
				var sprite = untyped parent.buffer.__srcHowl._sprite[parent.buffer.__srcHowlerDefaultSprite];

				if (sprite != null)
				{
					return sprite[1];
				}
			}

			return parent.buffer.__srcHowl.duration(handle) * 1000.0;
		}

		return 0;
	}

	public function getCurrentTime():Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			var seek = parent.buffer.__srcHowl.seek(handle) * 1000.0;

			if (seek == 0)
			{
				var sound = untyped parent.buffer.__srcHowl._soundById(handle);

				if (sound != null)
				{
					return sound._stop * 1000.0;
				}
			}

			return seek;
		}

		return time;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.seek(value / 1000.0, handle);
		}

		return time = value;
	}

	public function getGain():Float
	{
		return (parent.buffer.__srcHowl != null && handle != -1) ? parent.buffer.__srcHowl.volume(handle) : gain;
	}

	public function setGain(value:Float):Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.volume(value, handle);
		}

		return gain = value;
	}

	public function getPitch():Float
	{
		return (parent.buffer.__srcHowl != null && handle != -1) ? parent.buffer.__srcHowl.rate(handle) : pitch;
	}

	public function setPitch(value:Float):Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.rate(value, handle);
		}

		return pitch = value;
	}

	public function getPan():Float
	{
		return (parent.buffer.__srcHowl != null && handle != -1) ? untyped parent.buffer.__srcHowl.stereo(null, handle) : pan;
	}

	public function setPan(value:Float):Float
	{
		if (parent.buffer.__srcHowl != null && handle != -1)
		{
			parent.buffer.__srcHowl.stereo(value, handle);
		}

		return pan = value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPlaying():Bool
	{
		return (parent.buffer.__srcHowl != null && handle != -1) ? parent.buffer.__srcHowl.playing(handle) : false;
	}
}
