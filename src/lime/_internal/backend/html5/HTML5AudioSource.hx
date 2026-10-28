package lime._internal.backend.html5;

import lime.media.AudioBuffer;
import lime.media.AudioSource;
import lime.media.howlerjs.Howl;

@:access(lime.media.AudioBuffer)
class HTML5AudioSource
{
	private var handle:Int = -1;
	private var handleHowl:Howl;
	private var handleBuffer:AudioBuffer;
	private var waitingForLoad:Bool = false;
	private var waitingHowl:Howl;
	private var waitingBuffer:AudioBuffer;
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
		#if (js && html5 && lime_howlerjs)
		final buffer = parent.buffer;
		if (buffer == null)
		{
			clearHandle(true, true);
			cancelPendingLoad();
			return;
		}

		final howl = buffer.__getHowl();
		if (howl == null)
			return;

		if (handle != -1)
		{
			if (handleHowl == howl && howl.state() == "loaded")
			{
				howl.play(handle);
				return;
			}

			clearHandle(handleHowl != howl, false);
		}

		if (waitingForLoad)
		{
			if (waitingHowl == howl && waitingBuffer == buffer)
				return;
			cancelPendingLoad();
		}

		if (howl.state() == "loaded")
		{
			startPlayback(buffer, howl, false);
			return;
		}

		waitingForLoad = true;
		waitingHowl = howl;
		waitingBuffer = buffer;
		buffer.__retainHowlHandle();
		howl.once("load", howl_onLoad);
		howl.once("loaderror", howl_onLoadError);

		if (howl.state() == "unloaded")
			howl.load();
		#end
	}

	public function pause():Void
	{
		#if (js && html5 && lime_howlerjs)
		if (waitingForLoad)
		{
			cancelPendingLoad();
			return;
		}

		if (handleHowl != null && handle != -1 && handleHowl.state() == "loaded")
		{
			time = getCurrentTime();
			handleHowl.pause(handle);
		}
		#end
	}

	public function stop():Void
	{
		#if (js && html5 && lime_howlerjs)
		cancelPendingLoad();
		clearHandle(true, true);
		#else
		time = 0;
		#end
	}

	private function startPlayback(buffer:AudioBuffer, howl:Howl, retained:Bool):Void
	{
		#if (js && html5 && lime_howlerjs)
		final newHandle:Int = buffer.__srcHowlerDefaultSprite != null ? howl.play(buffer.__srcHowlerDefaultSprite) : howl.play();
		if (newHandle < 0)
		{
			if (retained)
				buffer.__releaseHowlHandle();
			return;
		}

		handle = newHandle;
		handleHowl = howl;
		handleBuffer = buffer;
		if (!retained)
			buffer.__retainHowlHandle();

		howl.once("end", howl_onEnd, handle);
		howl.once("playerror", howl_onError, handle);

		if (time > 0)
			howl.seek(time / 1000.0, handle);
		howl.volume(gain, handle);
		howl.rate(pitch, handle);
		howl.stereo(pan, handle);
		#end
	}

	private function cancelPendingLoad():Void
	{
		#if (js && html5 && lime_howlerjs)
		if (!waitingForLoad)
			return;

		final howl = waitingHowl;
		final buffer = waitingBuffer;
		waitingForLoad = false;
		waitingHowl = null;
		waitingBuffer = null;

		if (howl != null)
		{
			howl.off("load", howl_onLoad);
			howl.off("loaderror", howl_onLoadError);
		}
		if (buffer != null)
			buffer.__releaseHowlHandle();
		#end
	}

	private function clearHandle(stopPlayback:Bool, resetTime:Bool):Void
	{
		#if (js && html5 && lime_howlerjs)
		final oldHandle = handle;
		final oldHowl = handleHowl;
		final oldBuffer = handleBuffer;

		handle = -1;
		handleHowl = null;
		handleBuffer = null;
		if (resetTime)
			time = 0;

		if (oldHowl != null && oldHandle != -1)
		{
			oldHowl.off("end", howl_onEnd, oldHandle);
			oldHowl.off("playerror", howl_onError, oldHandle);
			if (stopPlayback && oldHowl.state() != "unloaded")
				oldHowl.stop(oldHandle);
		}

		if (oldBuffer != null)
			oldBuffer.__releaseHowlHandle();
		#end
	}

	private function howl_onLoad(?id:Int):Void
	{
		#if (js && html5 && lime_howlerjs)
		if (!waitingForLoad || waitingHowl == null || waitingBuffer == null)
			return;

		final howl = waitingHowl;
		final buffer = waitingBuffer;
		waitingForLoad = false;
		waitingHowl = null;
		waitingBuffer = null;
		howl.off("loaderror", howl_onLoadError);

		if (parent.buffer != buffer || howl.state() != "loaded")
		{
			buffer.__releaseHowlHandle();
			return;
		}

		startPlayback(buffer, howl, true);
		#end
	}

	private function howl_onLoadError(id:Dynamic, err:Dynamic):Void
	{
		#if (js && html5 && lime_howlerjs)
		if (!waitingForLoad || waitingHowl == null || waitingBuffer == null)
			return;

		final howl = waitingHowl;
		final buffer = waitingBuffer;
		waitingForLoad = false;
		waitingHowl = null;
		waitingBuffer = null;
		howl.off("load", howl_onLoad);
		buffer.__requestHowlDispose(howl);
		buffer.__releaseHowlHandle();
		#end
	}

	private function howl_onEnd(id:Int):Void
	{
		#if (js && html5 && lime_howlerjs)
		if (id != handle || handleHowl == null || handleBuffer == null)
			return;

		final oldHandle = handle;
		final oldHowl = handleHowl;
		final oldBuffer = handleBuffer;
		oldHowl.off("end", howl_onEnd, oldHandle);
		oldHowl.off("playerror", howl_onError, oldHandle);
		handle = -1;
		handleHowl = null;
		handleBuffer = null;
		time = 0;

		if (loops > 0)
		{
			loops--;
			play();
			oldBuffer.__releaseHowlHandle();
			return;
		}

		parent.onComplete.dispatch();
		oldBuffer.__releaseHowlHandle();
		#end
	}

	private function howl_onError(id:Int, err:Dynamic):Void
	{
		#if (js && html5 && lime_howlerjs)
		if (id != handle || handleHowl == null)
			return;
		if (handleHowl.state() == "loaded")
		{
			final seek:Float = handleHowl.seek(handle);
			if (seek >= 0)
				time = seek * 1000.0;
		}
		clearHandle(false, false);
		#end
	}

	public function getLength():Float
	{
		#if (js && html5 && lime_howlerjs)
		final buffer = handleBuffer != null ? handleBuffer : parent.buffer;
		final howl = handleHowl != null ? handleHowl : (buffer != null ? buffer.__getHowl() : null);
		if (buffer == null || howl == null || howl.state() != "loaded")
			return 0;

		if (buffer.__srcHowlerDefaultSprite != null)
		{
			final sprites:Dynamic = untyped howl._sprite;
			var sprite:Dynamic = null;
			if (sprites != null)
			{
				sprite = untyped sprites[buffer.__srcHowlerDefaultSprite];
			}
			if (sprite != null)
				return cast sprite[1];
		}

		return (handle != -1 && handleHowl == howl ? howl.duration(handle) : howl.duration()) * 1000.0;
		#else
		return 0;
		#end
	}

	public function getCurrentTime():Float
	{
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
		{
			final seek:Float = handleHowl.seek(handle);
			if (seek >= 0)
				time = seek * 1000.0;
		}
		#end
		return time;
	}

	public function setCurrentTime(value:Float):Float
	{
		if (value < 0 || value != value)
			value = 0;
		time = value;
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
		{
			handleHowl.seek(value / 1000.0, handle);
		}
		#end
		return value;
	}

	public function getGain():Float
	{
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			return handleHowl.volume(handle);
		#end
		return gain;
	}

	public function setGain(value:Float):Float
	{
		gain = value;
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			handleHowl.volume(value, handle);
		#end
		return gain;
	}

	public function getPitch():Float
	{
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			return handleHowl.rate(handle);
		#end
		return pitch;
	}

	public function setPitch(value:Float):Float
	{
		pitch = value;
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			handleHowl.rate(value, handle);
		#end
		return pitch;
	}

	public function getPan():Float
	{
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			return untyped handleHowl.stereo(null, handle);
		#end
		return pan;
	}

	public function setPan(value:Float):Float
	{
		pan = value;
		#if (js && html5 && lime_howlerjs)
		if (handle != -1 && handleHowl != null && handleHowl.state() == "loaded")
			handleHowl.stereo(value, handle);
		#end
		return pan;
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
		#if (js && html5 && lime_howlerjs)
		return handle != -1 && handleHowl != null && handleHowl.state() == "loaded" && handleHowl.playing(handle);
		#else
		return false;
		#end
	}
}
