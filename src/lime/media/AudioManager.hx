package lime.media;

import haxe.MainLoop;
import lime.system.CFFIPointer;
#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
#if (windows || mac || linux || android || ios)
import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;
import sys.io.File;
#end
#elseif lime_howlerjs
import lime.media.howlerjs.Howler;
#end

@:access(lime.media.openal.ALDevice)
class AudioManager
{
	/**
		The version of OpenAL Configuration.
	**/
	@:noCompletion
	private static final AUDIO_CONFIG_VERSION:String = "1.1";

	/**
		A read-only variable if the AudioManager is active or suspended.
	**/
	public static var active(default, null):Bool;

	/**
		The current used context to use for the audio manager.
	**/
	public static var context:AudioContext;

	#if lime_openal
	@:noCompletion private static var __disconnectExtSupported:Bool;
	@:noCompletion private static var __resumeOnFocus:Bool;
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
			#if (windows || mac || linux || android || ios)
			__setupConfig();
			#end

			refresh();

			#if !mobile
			if (__reopenDeviceSupported) AL.disable(AL.STOP_SOURCES_ON_DISCONNECT_SOFT);
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

		#if !mobile
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

	@:allow(lime._internal.backend.native.NativeApplication)
	@:noCompletion
	private static function onActivate():Void
	{
		if (__resumeOnFocus)
		{
			context.web.suspend();
		}
	}

	@:allow(lime._internal.backend.native.NativeApplication)
	@:noCompletion
	private static function onDeactivate():Void
	{
		__resumeOnFocus = __resumeOnFocus || AudioManager.active;
		AudioManager.suspend();
	}

	#if (lime_openal && !lime_doc_gen)
	@:noCompletion private static function __refresh():Void
	{
		var currentContext = ALC.getCurrentContext();
		if (currentContext == null) return;

		var device = ALC.getContextsDevice(currentContext);
		if (device == null) return;

		__disconnectExtSupported = ALC.isExtensionPresent(null, 'ALC_EXT_disconnect');
		__reopenDeviceSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_reopen_device');
		__systemEventsSupported = ALC.isExtensionPresent(null, 'ALC_SOFT_system_events');
	}

	#if (windows || mac || linux || android || ios)
	@:noCompletion
	private static function __setupConfig():Void
	{
		final alConfig:Array<String> = [];

		alConfig.push('[general]');
		alConfig.push('frequency=48000');
		alConfig.push('sample-type=float32');
		alConfig.push('stereo-mode=speakers');
		alConfig.push('stereo-encoding=basic');
		alConfig.push('cf_level=0');
		alConfig.push('output-limiter=false');
		alConfig.push('front-stablizer=false');
		alConfig.push('volume-adjust=0');
		alConfig.push('period_size=480');
		alConfig.push('periods=4');
		alConfig.push('sends=64');
		alConfig.push('dither=false');
		alConfig.push('dither-depth=0');

		alConfig.push('[decoder]');
		alConfig.push('hq-mode=false');
		alConfig.push('distance-comp=false');
		alConfig.push('nfc=false');

		try
		{
			final directory:String = Path.directory(Path.withoutExtension(System.applicationStorageDirectory));
			final path:String = Path.withExtension(Path.join([directory, 'audio-config-${AUDIO_CONFIG_VERSION}']), #if windows 'ini' #else 'conf' #end);
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
