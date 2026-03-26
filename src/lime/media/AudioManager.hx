package lime.media;

import lime.app.Event;
import lime.system.System;
#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
import lime.system.CFFIPointer;
import lime.system.CFFI;
#elseif lime_howlerjs
import lime.media.howlerjs.Howler;
#elseif flash
import flash.media.SoundMixer;
import flash.media.SoundTransform;
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

	/**
		Dispatched when the default for the playback device is changed.
		'Device Name' -> Void.
	**/
	public static var onDefaultPlaybackDeviceChanged = new Event<String->Void>();

	/**
		Dispatched whenever a playback device is added.
		'Device Name' -> Void.
	**/
	public static var onPlaybackDeviceAdded = new Event<String->Void>();

	/**
		Dispatched whenever a playback device is removed.
		'Device Name' -> Void.
	**/
	public static var onPlaybackDeviceRemoved = new Event<String->Void>();

	/**
		Dispatched when the default for the capture device is changed.
		'Device Name' -> Void.
	**/
	public static var onDefaultCaptureDeviceChanged = new Event<String->Void>();

	/**
		Dispatched whenever a capture device is added.
		'Device Name' -> Void.
	**/
	public static var onCaptureDeviceAdded = new Event<String->Void>();

	/**
		Dispatched whenever a capture device is removed.
		'Device Name' -> Void.
	**/
	public static var onCaptureDeviceRemoved = new Event<String->Void>();

	/**
		Should it automatically switch to the default playback device whenever it changes.
	**/
	public static var automaticDefaultPlaybackDevice:Bool = true;

	/**
		Mutes the audio manager playback.
	**/
	public static var muted(get, set):Bool;

	/**
		The gain (volume) of the audio manager. A value of `1.0` represents the default volume.
		Property is in a linear scale.
	**/
	public static var gain(get, set):Float;

	@:noCompletion private static var __muted:Bool = false;
	@:noCompletion private static var __gain:Float = 1;
	#if lime_openal
	@:noCompletion private static var __effectExtSupported:Bool;
	@:noCompletion private static var __captureExtSupported:Bool;
	@:noCompletion private static var __disconnectExtSupported:Bool;
	@:noCompletion private static var __deviceClockSupported:Bool;
	@:noCompletion private static var __reopenDeviceSupported:Bool;
	@:noCompletion private static var __systemEventsSupported:Bool;
	@:noCompletion private static var __enumerateAllSupported:Bool;

	@:noCompletion private static var __latencyExtSupported:Bool;
	@:noCompletion private static var __directChannelsExtSupported:Bool;
	@:noCompletion private static var __loopPointsSupported:Bool;
	@:noCompletion private static var __moreFormatsSupported:Bool;
	@:noCompletion private static var __spatializeSupported:Bool;
	@:noCompletion private static var __stereoAnglesSupported:Bool;
	#elseif flash
	@:noCompletion private static var __flashSoundTransform:SoundTransform;
	#end

	/**
		Initializes an `AudioManager` to playback to and capture from audio devices.
		Automatically dispatched when Application is constructed.

		@param	context	Optional; An Audio Context to initalize the `AudioManager` with.
	**/
	public static function init(context:AudioContext = null)
	{
		#if !lime_doc_gen
		if (AudioManager.context != null) return;

		if (context == null)
		{
			AudioManager.context = new AudioContext();
			context = AudioManager.context;

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

			AudioManager.context = context;
			#end
		}

		gain = __gain;
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
		Gets the default capture audio device name from the host operating system.

		Only works on Native target.

		@return	The default capture audio device name.
	**/
	public static function getCaptureDefaultDeviceName():String
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL && __captureExtSupported)
		{
			return __formatDeviceName(ALC.getString(null, ALC.CAPTURE_DEFAULT_DEVICE_SPECIFIER));
		}
		#end
		return '';
	}

	/**
		Gets all of the available capture audio device names from the host operating system.

		Only works on Native target.

		@return An array containing available capture audio device names.
	**/
	public static function getCaptureDeviceNames():Array<String>
	{
		#if (lime_openal && !lime_doc_gen)
		if (context == null || context.type != OPENAL || !__captureExtSupported) return [];

		final arr = ALC.getStringList(null, ALC.CAPTURE_DEVICE_SPECIFIER);
		for (i in 0...arr.length) arr[i] = __formatDeviceName(arr[i]);

		// A bug with using SDL3 backend to wasapi
		arr.remove("Default Device");

		return arr;
		#else
		return [];
		#end
	}

	/**
		Gets the current used playback audio device name.

		Only works on Native target.

		@return	Current playback audio device name.
	**/
	public static function getCurrentPlaybackDeviceName():String
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				var device = ALC.getContextsDevice(currentContext);
				if (device != null)
				{
					if (__enumerateAllSupported) return __formatDeviceName(ALC.getString(device, ALC.ALL_DEVICES_SPECIFIER));
					else return __formatDeviceName(ALC.getString(device, ALC.DEVICE_SPECIFIER));
				}
			}
		}
		#end
		return '';
	}

	/**
		Gets the default playback audio device name from the host operating system.

		Only works on Native target.

		@return	The default playback audio device name.
	**/
	public static function getPlaybackDefaultDeviceName():String
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL)
		{
			if (__enumerateAllSupported) return __formatDeviceName(ALC.getString(null, ALC.DEFAULT_ALL_DEVICES_SPECIFIER));
			else return __formatDeviceName(ALC.getString(null, ALC.DEFAULT_DEVICE_SPECIFIER));
		}
		#end
		return '';
	}

	/**
		Gets all of the available playback audio device names from the host operating system.

		Only works on Native target.

		@return An array containing available playback audio device names.
	**/
	public static function getPlaybackDeviceNames():Array<String>
	{
		#if (lime_openal && !lime_doc_gen)
		if (context == null || context.type != OPENAL) return [];
		else if (!__enumerateAllSupported) return [__formatDeviceName(ALC.getString(null, ALC.DEVICE_SPECIFIER))];

		final arr = ALC.getStringList(null, ALC.ALL_DEVICES_SPECIFIER);
		for (i in 0...arr.length) arr[i] = __formatDeviceName(arr[i]);

		// A bug with using SDL3 backend to wasapi
		arr.remove("Default Device");

		return arr;
		#else
		return [];
		#end
	}

	/**
		Queries the current timer or clock from the current context, best to measure latency, timer drift, etc.

		@return	The current clock time from the current context.
	**/
	public static function getTimer():Float
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL && __deviceClockSupported)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				var device = ALC.getContextsDevice(currentContext);
				if (device != null)
				{
					return ALC.getDoublevSOFT(device, ALC.DEVICE_CLOCK_SOFT)[0] / 1e+6;
				}
			}
		}
		#elseif (js && html5)
		if (context != null && context.type == WEB)
		{
			#if lime_howlerjs
			if (Howler.ctx != null)
			{
				return Howler.ctx.currentTime * 1000.0;
			}
			#end
			return context.web.currentTime * 1000.0;
		}
		#end

		return System.getTimer();
	}

	/**
		Queries the current audio device latency.

		Only works on Native target.

		@return	The current audio device latency.
	**/
	public static function getLatency():Float
	{
		#if (lime_openal && !lime_doc_gen)
		if (context != null && context.type == OPENAL && __deviceClockSupported)
		{
			var currentContext = ALC.getCurrentContext();
			if (currentContext != null)
			{
				var device = ALC.getContextsDevice(currentContext);
				if (device != null)
				{
					return ALC.getDoublevSOFT(device, ALC.DEVICE_LATENCY_SOFT)[0] / 1e+6;
				}
			}
		}
		#end

		return 0.0;
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
			#if lime_howlerjs
			if (Howler.ctx != null) Howler.ctx.resume();
			#end
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
			// Don't close howler context, or unexpected things can happen.
			//#if lime_howlerjs
			//if (Howler.ctx != null) Howler.ctx.close();
			//#end
			context.web.close();
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
			#if lime_howlerjs
			if (Howler.ctx != null) Howler.ctx.suspend();
			#end
			context.web.suspend();
		}
		#end
	}

	@:noCompletion private static inline function get_muted():Bool
	{
		return __muted;
	}

	@:noCompletion private static inline function set_muted(value:Bool):Bool
	{
		__muted = value;
		if (context == null) return __muted;

		#if !lime_doc_gen
		#if lime_openal
		if (context.type == OPENAL) AL.listenerf(AL.GAIN, value ? 0 : __gain);
		#elseif (js && html5)
		if (context.type == HTML5 || context.type == WEB) Howler.mute(value);
		#elseif flash
		if (context.type == FLASH)
		{
			if (__flashSoundTransform == null) __flashSoundTransform = new SoundTransform();
			__flashSoundTransform.gain = value ? 0 : __gain;
			SoundMixer.soundTransform = __flashSoundTransform;
		}
		#end
		#end
		return value;
	}

	@:noCompletion private static inline function get_gain():Float
	{
		return __gain;
	}

	@:noCompletion private static inline function set_gain(value:Float):Float
	{
		__gain = value;
		if (context == null) return __gain;

		#if !lime_doc_gen
		#if lime_openal
		if (context.type == OPENAL) AL.listenerf(AL.GAIN, __muted ? 0 : value);
		#elseif (js && html5)
		if (context.type == HTML5 || context.type == WEB) Howler.volume(value);
		#elseif flash
		if (context.type == FLASH)
		{
			if (__flashSoundTransform == null) __flashSoundTransform = new SoundTransform();
			__flashSoundTransform.volume = __muted ? 0 : value;
			SoundMixer.soundTransform = __flashSoundTransform;
		}
		#end
		#end
		return value;
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
					if (automaticDefaultPlaybackDevice) refresh();
					onDefaultPlaybackDeviceChanged.dispatch(getPlaybackDefaultDeviceName());
				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:
					onPlaybackDeviceAdded.dispatch(__formatDeviceName(deviceName));
				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:
					if (__disconnectExtSupported && ALC.getIntegerv(currentDevice, ALC.CONNECTED, 1)[0] != 1) refresh();
					onPlaybackDeviceRemoved.dispatch(__formatDeviceName(deviceName));
			}
		}
		else if (deviceType == ALC.CAPTURE_DEVICE_SOFT) {
			switch (eventType) {
				case ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT:
					onDefaultCaptureDeviceChanged.dispatch(getCaptureDefaultDeviceName());
				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:
					onCaptureDeviceAdded.dispatch(__formatDeviceName(deviceName));
				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:
					onCaptureDeviceRemoved.dispatch(__formatDeviceName(deviceName));
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

		__effectExtSupported = ALC.isExtensionPresent(null, "ALC_EXT_EFX");
		__captureExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_CAPTURE');
		__disconnectExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_disconnect');
		__deviceClockSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_device_clock');
		__reopenDeviceSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_reopen_device');
		__systemEventsSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_system_events');
		__enumerateAllSupported = ALC.isExtensionPresent(null, 'ALC_ENUMERATE_ALL_EXT');

		__latencyExtSupported = AL.isExtensionPresent('AL_SOFT_source_latency');
		__directChannelsExtSupported = AL.isExtensionPresent('AL_SOFT_direct_channels') && AL.isExtensionPresent('AL_SOFT_direct_channels_remix');
		__loopPointsSupported = AL.isExtensionPresent('AL_SOFT_loop_points');
		__moreFormatsSupported = AL.isExtensionPresent('AL_EXT_MCFORMATS');
		__spatializeSupported = AL.isExtensionPresent('AL_SOFT_source_spatialize');
		__stereoAnglesSupported = AL.isExtensionPresent('AL_EXT_STEREO_ANGLES');

		gain = __gain;
		AL.distanceModel(AL.NONE);
	}

	@:noCompletion private static function __formatDeviceName(deviceName:String)
	{
		if (StringTools.startsWith(deviceName, 'OpenAL Soft on ')) return deviceName.substr(15);
		else if (StringTools.startsWith(deviceName, 'OpenAL on ')) return deviceName.substr(10);
		else if (StringTools.startsWith(deviceName, 'Generic Software on ')) return deviceName.substr(20);
		else return deviceName;
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

#if (lime_openal && !lime_doc_gen)
private typedef ALDeviceEvent =
{
	eventType:Int,
	deviceType:Int,
	device:Null<ALDevice>,
	deviceName:Null<String>,
	message:String
}
#end