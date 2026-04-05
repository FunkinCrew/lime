package lime.media;

import haxe.MainLoop;
import lime.app.Event;
import lime.system.CFFIPointer;
import lime.system.System;
#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
#elseif lime_howlerjs
import lime.media.howlerjs.Howler;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.media.openal.ALDevice)
class AudioManager
{
	/**
		The current used context to use for the audio manager.
	**/
	public static var context:AudioContext;

	#if lime_openal
	@:noCompletion private static var __disconnectExtSupported:Bool;
	@:noCompletion private static var __reopenDeviceSupported:Bool;
	@:noCompletion private static var __systemEventsSupported:Bool;
	#end

	/**
		Initializes an `AudioManager` to playback to and capture from audio devices.
		Automatically dispatched when Application is constructed.

		@param	context	Optional; An Audio Context to initalize the `AudioManager` with.
	**/
	public static function init(context:AudioContext = null)
	{
		if (AudioManager.context != null) return;

		if (context == null)
		{
			context = new AudioContext();
		}

		AudioManager.context = context;

		#if lime_openal
		if (context.type == OPENAL)
		{
			refresh();

			#if !(neko || mobile)
			if (__reopenDeviceSupported) AL.disable(AL.STOP_SOURCES_ON_DISCONNECT_SOFT);
			if (__systemEventsSupported) {
				ALC.eventControlSOFT([
					ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT,
					ALC.EVENT_TYPE_DEVICE_ADDED_SOFT,
					ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT],
				true);
				ALC.eventCallbackSOFT(__deviceEventCallback);
			}
			#end
		}
		#end
	}

	/**
		Refresh the context with optionally to different device.

		Only works on Native target.

		@param	deviceName	Optional; The device name to use to for playbacking the audios.
	**/
	public static function refresh(?deviceName:String):Bool
	{
		#if (lime_openal && !lime_doc_gen)
		if (context == null || context.type != OPENAL) return false;

		var currentContext = ALC.getCurrentContext();
		var device = currentContext != null ? ALC.getContextsDevice(currentContext) : null;

		if (device != null && __reopenDeviceSupported && ALC.reopenDeviceSOFT(device, deviceName, null))
		{
			__refresh();
			return true;
		}

		if (currentContext != null)
		{
			ALC.destroyContext(currentContext);
			currentContext = null;
		}

		if (device != null)
		{
			ALC.closeDevice(device);
			device = null;
		}

		if ((device = ALC.openDevice()) == null || (currentContext = ALC.createContext(device)) == null
			|| !ALC.makeContextCurrent(currentContext))
		{
			return false;
		}

		ALC.processContext(currentContext);
		__refresh();
		return true;
		#else
		return false;
		#end
	}

	/**
		Resumes the current `AudioManager` context.

		This function does not work on the Flash target.
	**/
	public static function resume():Void
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				var device = ALC.getContextsDevice(currentContext);
				if (device != null) ALC.resumeDevice(device);

				ALC.processContext(currentContext);
			}
		}
		#elseif (js && html5)
		if (context != null && context.type == WEB)
		{
			context.web.resume();
		}
		#end
	}

	/**
		Shutdowns the current `AudioManager` context.

		This function does not work on the Flash target.
	**/
	public static function shutdown():Void
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				ALC.makeContextCurrent(null);
				ALC.destroyContext(currentContext);

				var device = ALC.getContextsDevice(currentContext);
				if (device != null) ALC.closeDevice(device);
			}
		}
		#elseif (js && html5)
		if (context != null && context.type == WEB)
		{
			#if lime_howlerjs
			Howler.unload();
			#else
			context.web.close();
			#end
		}
		#end

		context = null;
	}

	/**
		Pauses the current `AudioManager` context.

		This function does not work on the Flash target.
	**/
	public static function suspend():Void
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				ALC.suspendContext(currentContext);

				var device = ALC.getContextsDevice(currentContext);
				if (device != null) ALC.pauseDevice(device);
			}
		}
		#elseif (js && html5)
		if (context != null && context.type == WEB)
		{
			context.web.suspend();
		}
		#end
	}

	#if (lime_openal && !lime_doc_gen)
	// device is null... and its actually intended cuz its tied to the device its being used rn.
	// why
	// and in ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT, deviceName is the device GUID
	#if !(neko || mobile)
	@:noCompletion private static function __deviceEventCallback(eventType:Int, deviceType:Int, handle:CFFIPointer,
		#if hl _message:hl.Bytes #else message:String #end)
	{
		#if hl var message:String = CFFI.stringValue(_message); #end
		var device:ALDevice = handle != null ? new ALDevice(handle) : null;
		var deviceName = __getDeviceNameFromMessage(message);

		var currentContext = ALC.getCurrentContext();
		var currentDevice = currentContext != null ? ALC.getContextsDevice(currentContext) : null;
		if (deviceType == ALC.PLAYBACK_DEVICE_SOFT) {
			switch (eventType) {
				case ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT:
					refresh();
				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:

				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:
					if (__disconnectExtSupported && ALC.getIntegerv(currentDevice, ALC.CONNECTED, 1)[0] != 1) refresh();
			}
		}
		else if (deviceType == ALC.CAPTURE_DEVICE_SOFT) {
			switch (eventType) {
				case ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT:

				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:

				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:

			}
		}
	}
	#end

	@:noCompletion private static function __refresh():Void
	{
		if (context == null || context.type != OPENAL) return;

		var currentContext = ALC.getCurrentContext();
		if (currentContext == null) return;

		var device = ALC.getContextsDevice(currentContext);
		if (device == null) return;

		__disconnectExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_disconnect');
		__reopenDeviceSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_reopen_device');
		__systemEventsSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_system_events');
	}

	// permanent band-aid fix whatever
	@:noCompletion private static function __getDeviceNameFromMessage(message:String):Null<String>
	{
		if (StringTools.startsWith(message, 'Device removed: ')) return message.substr(16);
		else if (StringTools.startsWith(message, 'Device added: ')) return message.substr(14);
		else return null;
	}
	#end
}