package lime.media;

import haxe.MainLoop;
import haxe.Timer;

import lime._internal.backend.native.NativeCFFI;
import lime.app.Application;
import lime.system.CFFIPointer;

#if (js && html5)
import js.Browser;
#end

@:allow(lime._internal.backend.native.NativeApplication)
@:access(lime._internal.backend.native.NativeCFFI)
class AudioManager
{
	@:noCompletion
	private static var AUDIO_CONFIG_VERSION:String = "1.1";

	@:noCompletion
	private static var resumeOnFocus:Bool = false;

	@:noCompletion
	private static var active:Bool = true;

	public static var context:AudioContext;

	public static function init(context:AudioContext = null)
	{
		if (AudioManager.context == null)
		{
			if (context == null)
			{
				AudioManager.context = new AudioContext();

				context = AudioManager.context;
			}

			AudioManager.context = context;
		}
	}

	public static function resume():Void
	{
		if (active)
			return;

		active = true;
	}

	public static function shutdown():Void
	{
		context = null;
	}

	public static function suspend():Void
	{
		if (!active)
			return;

		active = false;
	}

	@:noCompletion
	private static function onActivate():Void
	{
		if (resumeOnFocus)
		{
			resumeOnFocus = false;

			AudioManager.resume();
		}
	}

	@:noCompletion
	private static function onDeactivate():Void
	{
		resumeOnFocus = resumeOnFocus || AudioManager.active;

		AudioManager.suspend();
	}
}
