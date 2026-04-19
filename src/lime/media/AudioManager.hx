package lime.media;

import haxe.MainLoop;
import lime.app.Event;
import lime.system.CFFIPointer;
#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
#if lime_openalsoft
import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;
import sys.io.File;
import sys.thread.Mutex;
#end
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
		Should it automatically switch to the default playback device whenever it changes.

		Only works on Native target.
	**/
	public static var automaticDefaultPlaybackDevice:Bool = true;

	/**
		The current used context to use for the audio manager.
	**/
	public static var context:AudioContext;

	/**
		The gain (volume) of the audio manager. A value of `1.0` represents the default volume.
		Property is in a linear scale.
	**/
	public static var gain(get, set):Float;

	/**
		Mutes the audio manager playback.
	**/
	public static var muted(get, set):Bool;

	/**
		Dispatched when the default for the playback device is changed.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onDefaultPlaybackDeviceChanged = new Event<String->Void>();

	/**
		Dispatched whenever a playback device is added.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onPlaybackDeviceAdded = new Event<String->Void>();

	/**
		Dispatched whenever a playback device is removed.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onPlaybackDeviceRemoved = new Event<String->Void>();

	/**
		Dispatched when the default for the capture device is changed.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onDefaultCaptureDeviceChanged = new Event<String->Void>();

	/**
		Dispatched whenever a capture device is added.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onCaptureDeviceAdded = new Event<String->Void>();

	/**
		Dispatched whenever a capture device is removed.
		'Device Name' -> Void.

		Only works on Native target.
	**/
	public static var onCaptureDeviceRemoved = new Event<String->Void>();

	@:noCompletion private static var __gain:Float = 1;
	@:noCompletion private static var __muted:Bool = false;
	#if lime_openal
	#if lime_openalsoft
	@:noCompletion private static var __pendingDeviceEventMutex:Mutex = new Mutex();
	@:noCompletion private static var __pendingDeviceEventCheck:Bool;
	@:noCompletion private static var __pendingPlaybackDevicesAddition:Array<String>;
	@:noCompletion private static var __pendingPlaybackDevicesRemoval:Array<String>;
	@:noCompletion private static var __pendingCaptureDevicesAddition:Array<String>;
	@:noCompletion private static var __pendingCaptureDevicesRemoval:Array<String>;
	@:noCompletion private static var __pendingDefaultPlaybackDevice:Bool;
	@:noCompletion private static var __pendingDefaultCaptureDevice:Bool;
	#end

	@:noCompletion private static var __captureExtSupported:Bool;
	@:noCompletion private static var __disconnectExtSupported:Bool;
	@:noCompletion private static var __enumerateAllSupported:Bool;
	@:noCompletion private static var __reopenDeviceSupported:Bool;
	@:noCompletion private static var __systemEventsSupported:Bool;
	#end

	/**
		Initializes an `AudioManager` to playback to and capture from audio devices.
		Automatically dispatched when Application is constructed.

		@param	context	Optional; An Audio Context to initalize the `AudioManager` with.
	**/
	public static function init(?context:AudioContext)
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
			#if lime_openalsoft
			__setupConfig();
			#end

			refresh();

			#if lime_openalsoft
			if (__reopenDeviceSupported) AL.disable(AL.STOP_SOURCES_ON_DISCONNECT_SOFT);
			#if !mobile
			if (__systemEventsSupported) {
				ALC.eventControlSOFT([
					ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT,
					ALC.EVENT_TYPE_DEVICE_ADDED_SOFT,
					ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT],
				true);
				ALC.eventCallbackSOFT(__deviceEventCallback);
			}
			#end
			#end
		}
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
		Note: "Default Device" is only exclusive in SDL3, this does not appear in every other OpenAL Soft backends.

		Only works on Native target.

		@return An array containing available capture audio device names.
	**/
	public static function getCaptureDeviceNames():Array<String>
	{
		#if (lime_openal && !lime_doc_gen)
		if (context == null || context.type != OPENAL || !__captureExtSupported) return [];

		final arr = ALC.getStringList(null, ALC.CAPTURE_DEVICE_SPECIFIER);
		for (i in 0...arr.length) arr[i] = __formatDeviceName(arr[i]);

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
			var deviceName:String;
			if (__enumerateAllSupported) deviceName = __formatDeviceName(ALC.getString(null, ALC.DEFAULT_ALL_DEVICES_SPECIFIER));
			else deviceName = __formatDeviceName(ALC.getString(null, ALC.DEFAULT_DEVICE_SPECIFIER));

			if (deviceName == "Default Device") return getPlaybackDeviceNames()[0];
			else return deviceName;
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

		// SDL3 Backend Exclusive, apparently not a bug but it acts as a virtual device to automatically
		// switch to a default device without having to code it on your own, except that it's
		// been already coded so this isn't needed anymore.
		arr.remove("Default Device");

		return arr;
		#else
		return [];
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

		if (deviceName == null) deviceName = getPlaybackDefaultDeviceName();

		var currentContext = ALC.getCurrentContext();
		var device = currentContext != null ? ALC.getContextsDevice(currentContext) : null;

		#if (lime_openalsoft && !mobile)
		if (device != null && __reopenDeviceSupported && ALC.reopenDeviceSOFT(device, deviceName, null))
		{
			__refresh();
			return true;
		}
		#end

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
	**/
	public static function resume():Void
	{
		#if lime_openal
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
		#if lime_howlerjs
		if (untyped Howler.ctx)
		{
			Howler.ctx.resume();
		}
		#end
		if (context != null && context.type == WEB)
		{
			context.web.resume();
		}
		#end
	}

	/**
		Shutdowns the current `AudioManager` context.
	**/
	public static function shutdown():Void
	{
		#if lime_openal
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
		#if lime_howlerjs
		if (untyped Howler.ctx)
		{
			Howler.ctx.unload();
		}
		#end
		if (context != null && context.type == WEB)
		{
			context.web.close();
		}
		#end

		context = null;
	}

	/**
		Pauses the current `AudioManager` context.
	**/
	public static function suspend():Void
	{
		#if lime_openal
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
		#if lime_howlerjs
		if (untyped Howler.ctx)
		{
			Howler.ctx.suspend();
		}
		#end
		if (context != null && context.type == WEB)
		{
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
		#elseif (js && html5 && lime_howlerjs)
		Howler.mute(value);
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
		#elseif (js && html5 && lime_howlerjs)
		Howler.volume(value);
		#end
		#end
		return value;
	}

	#if (lime_openal && !lime_doc_gen)
	@:noCompletion private static function __refresh():Void
	{
		var currentContext = ALC.getCurrentContext();
		if (currentContext == null) return;

		var device = ALC.getContextsDevice(currentContext);
		if (device == null) return;

		__captureExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_CAPTURE');
		__disconnectExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_disconnect');
		__enumerateAllSupported = ALC.isExtensionPresent(null, 'ALC_ENUMERATE_ALL_EXT');
		__reopenDeviceSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_reopen_device');
		__systemEventsSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_system_events');

		gain = __gain;
		AL.distanceModel(AL.NONE);
	}

	@:noCompletion private static function __formatDeviceName(deviceName:String)
	{
		#if lime_openalsoft
		if (StringTools.startsWith(deviceName, 'OpenAL Soft on ')) return deviceName.substr(15);
		#elseif lime_openal
		if (StringTools.startsWith(deviceName, 'OpenAL on ')) return deviceName.substr(10);
		#end
		else if (StringTools.startsWith(deviceName, 'Generic Software on ')) return deviceName.substr(20);
		else return deviceName;
	}

	#if lime_openalsoft
	@:noCompletion
	private static function __deviceEventRun():Void
	{
		__pendingDeviceEventMutex.acquire();

		if (__pendingDefaultPlaybackDevice)
		{
			__pendingDefaultPlaybackDevice = false;
			if (automaticDefaultPlaybackDevice) refresh();
			onDefaultPlaybackDeviceChanged.dispatch(getPlaybackDefaultDeviceName());
		}

		if (__pendingDefaultCaptureDevice)
		{
			__pendingDefaultCaptureDevice = false;
			onDefaultCaptureDeviceChanged.dispatch(getCaptureDefaultDeviceName());
		}

		if (__pendingPlaybackDevicesAddition != null)
		{
			for (deviceName in __pendingPlaybackDevicesAddition) onPlaybackDeviceAdded.dispatch(deviceName);
			__pendingPlaybackDevicesAddition = null;
		}

		if (__pendingPlaybackDevicesRemoval != null)
		{
			for (deviceName in __pendingPlaybackDevicesRemoval) onPlaybackDeviceRemoved.dispatch(deviceName);
			__pendingPlaybackDevicesRemoval = null;
		}

		if (__pendingCaptureDevicesAddition != null)
		{
			for (deviceName in __pendingCaptureDevicesAddition) onCaptureDeviceAdded.dispatch(deviceName);
			__pendingCaptureDevicesAddition = null;
		}

		if (__pendingCaptureDevicesRemoval != null)
		{
			for (deviceName in __pendingCaptureDevicesRemoval) onCaptureDeviceRemoved.dispatch(deviceName);
			__pendingCaptureDevicesRemoval = null;
		}

		__pendingDeviceEventCheck = false;
		__pendingDeviceEventMutex.release();
	}

	@:noCompletion
	private static function __deviceEventCallback(eventType:Int, deviceType:Int, handle:CFFIPointer,
		#if hl _message:hl.Bytes #else message:String #end)
	{
		#if hl var message:String = CFFI.stringValue(_message); #end
		var device:ALDevice = handle != null ? new ALDevice(handle) : null;
		var deviceName = __getDeviceNameFromMessage(message);

		var currentContext = ALC.getCurrentContext();
		var currentDevice = currentContext != null ? ALC.getContextsDevice(currentContext) : null;

		__pendingDeviceEventMutex.acquire();

		if (deviceType == ALC.PLAYBACK_DEVICE_SOFT)
		{
			switch (eventType)
			{
				case ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT:
					__pendingDefaultPlaybackDevice = true;
				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:
					var formattedDeviceName = __formatDeviceName(deviceName);
					if (__pendingPlaybackDevicesRemoval != null) __pendingPlaybackDevicesRemoval.remove(formattedDeviceName);
					if (__pendingPlaybackDevicesAddition == null) __pendingPlaybackDevicesAddition = [];
					__pendingPlaybackDevicesAddition.push(formattedDeviceName);
				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:
					var formattedDeviceName = __formatDeviceName(deviceName);
					if (__pendingPlaybackDevicesAddition != null) __pendingPlaybackDevicesAddition.remove(formattedDeviceName);
					if (__pendingPlaybackDevicesRemoval == null) __pendingPlaybackDevicesRemoval = [];
					__pendingPlaybackDevicesRemoval.push(formattedDeviceName);
			}
		}
		else if (deviceType == ALC.CAPTURE_DEVICE_SOFT)
		{
			switch (eventType)
			{
				case ALC.EVENT_TYPE_DEFAULT_DEVICE_CHANGED_SOFT:
					__pendingDefaultCaptureDevice = true;
				case ALC.EVENT_TYPE_DEVICE_ADDED_SOFT:
					var formattedDeviceName = __formatDeviceName(deviceName);
					if (__pendingCaptureDevicesRemoval != null) __pendingCaptureDevicesRemoval.remove(formattedDeviceName);
					if (__pendingCaptureDevicesAddition == null) __pendingCaptureDevicesAddition = [];
					__pendingCaptureDevicesAddition.push(formattedDeviceName);
				case ALC.EVENT_TYPE_DEVICE_REMOVED_SOFT:
					var formattedDeviceName = __formatDeviceName(deviceName);
					if (__pendingCaptureDevicesAddition != null) __pendingCaptureDevicesAddition.remove(formattedDeviceName);
					if (__pendingCaptureDevicesRemoval == null) __pendingCaptureDevicesRemoval = [];
					__pendingCaptureDevicesRemoval.push(formattedDeviceName);
			}
		}

		if (!__pendingDeviceEventCheck)
		{
			__pendingDeviceEventCheck = true;
			MainLoop.runInMainThread(__deviceEventRun);
		}

		__pendingDeviceEventMutex.release();
	}

	@:noCompletion
	private static function __getDeviceNameFromMessage(message:String):Null<String>
	{
		if (StringTools.startsWith(message, 'Device removed: ')) return message.substr(16);
		else if (StringTools.startsWith(message, 'Device added: ')) return message.substr(14);
		else return null;
	}

	@:noCompletion
	private static function __setupConfig():Void
	{
		final alConfig:Array<String> = [];

		alConfig.push('[general]');
		alConfig.push('channels=stereo');
		alConfig.push('sample-type=float32');
		alConfig.push('stereo-mode=speakers');
		alConfig.push('stereo-encoding=panpot');
		alConfig.push('hrtf=false');
		alConfig.push('cf_level=0');
		alConfig.push('resampler=fast_bsinc24');
		alConfig.push('front-stablizer=false');
		alConfig.push('output-limiter=false');
		alConfig.push('volume-adjust=0');
		alConfig.push('period_size=441');

		alConfig.push('[decoder]');
		alConfig.push('hq-mode=false');
		alConfig.push('distance-comp=false');
		alConfig.push('nfc=false');

		try
		{
			final directory:String = Path.directory(Path.withoutExtension(System.applicationStorageDirectory));
			final path:String = Path.join([directory, #if windows 'audio-config.ini' #else 'audio-config.conf' #end]);
			final content:String = alConfig.join('\n');

			if (!FileSystem.exists(directory)) FileSystem.createDirectory(directory);

			if (!FileSystem.exists(path)) File.saveContent(path, content);

			Sys.putEnv('ALSOFT_CONF', path);
		}
		catch (e:Dynamic) {}
	}
	#end
	#end
}
