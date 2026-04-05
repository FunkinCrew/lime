package lime.media;

import lime.system.CFFIPointer;
import haxe.MainLoop;
import haxe.Timer;
import lime._internal.backend.native.NativeCFFI;
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
import lime.app.Application;
#if (js && html5)
import js.Browser;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.media.openal.ALDevice)
class AudioManager
{
	public static var context:AudioContext;

	public static function init(context:AudioContext = null)
	{
		if (AudioManager.context == null)
		{
			if (context == null)
			{
				AudioManager.context = new AudioContext();

				context = AudioManager.context;

				#if !lime_doc_gen
				if (context.type == OPENAL)
				{
					var alc = context.openal;
					var device = alc.openDevice();
					var ctx = alc.createContext(device);

					alc.makeContextCurrent(ctx);
					alc.processContext(ctx);

					#if !(neko || mobile)
					if (alc.isExtensionPresent('ALC_SOFT_system_events', device) && alc.isExtensionPresent('ALC_SOFT_reopen_device', device))
					{
						alc.disable(AL.STOP_SOURCES_ON_DISCONNECT_SOFT);

						alc.eventControlSOFT([ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT, ALC.EVENT_TYPE_DEVICE_ADDED_SOFT, ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT], true);

						alc.eventCallbackSOFT(deviceEventCallback);
					}
					#end
				}
				#end
			}

			AudioManager.context = context;
		}
	}

	public static function resume():Void
	{
		#if !lime_doc_gen
		if (context != null && context.type == OPENAL)
		{
			var alc = context.openal;
			var currentContext = alc.getCurrentContext();

			if (currentContext != null)
			{
				var device = alc.getContextsDevice(currentContext);
				alc.resumeDevice(device);
				alc.processContext(currentContext);
			}
		}
		#end
	}

	public static function shutdown():Void
	{
		#if !lime_doc_gen
		if (context != null && context.type == OPENAL)
		{
			var alc = context.openal;
			var currentContext = alc.getCurrentContext();
			var device = alc.getContextsDevice(currentContext);

			if (currentContext != null)
			{
				alc.makeContextCurrent(null);
				alc.destroyContext(currentContext);

				if (device != null)
				{
					alc.closeDevice(device);
				}
			}
		}
		#end

		context = null;
	}

	public static function suspend():Void
	{
		#if !lime_doc_gen
		if (context != null && context.type == OPENAL)
		{
			var alc = context.openal;
			var currentContext = alc.getCurrentContext();
			var device = alc.getContextsDevice(currentContext);

			if (currentContext != null)
			{
				alc.suspendContext(currentContext);

				if (device != null)
				{
					alc.pauseDevice(device);
				}
			}
		}
		#end
	}

	@:noCompletion
	#if hl
	private static function deviceEventCallback(eventType:Int, deviceType:Int, handle:CFFIPointer, message:hl.Bytes):Void
	#else
	private static function deviceEventCallback(eventType:Int, deviceType:Int, handle:CFFIPointer, message:String):Void
	#end
	{
		#if !lime_doc_gen
		if (eventType == ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT && deviceType == ALC.PLAYBACK_DEVICE_SOFT)
		{
			var device = new ALDevice(handle);

			MainLoop.runInMainThread(function():Void
			{
				var alc = context.openal;

				if (device == null)
				{
					var currentContext = alc.getCurrentContext();

					var device = alc.getContextsDevice(currentContext);

					if (device != null)
						alc.reopenDeviceSOFT(device, null, null);
				}
				else
				{
					alc.reopenDeviceSOFT(device, null, null);
				}

			});
		}
		#end
	}
}
