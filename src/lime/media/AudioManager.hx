package lime.media;

#if (windows || mac || linux || android)
import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;
import sys.io.File;
#end
import haxe.Timer;
import lime._internal.backend.native.NativeCFFI;
import lime.media.openal.AL;
import lime.media.openal.ALC;
import lime.media.openal.ALContext;
import lime.media.openal.ALDevice;
#if (js && html5)
import js.Browser;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
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
					#if (windows || mac || linux || android)
					setupConfig();
					#end

					var alc = context.openal;
					var device = alc.openDevice();
					var ctx = alc.createContext(device);

					alc.makeContextCurrent(ctx);
					alc.processContext(ctx);
				}
				#end
			}

			AudioManager.context = context;

			#if (lime_cffi && !macro && lime_openal && (ios || tvos || mac))
			var timer = new Timer(100);
			timer.run = function()
			{
				NativeCFFI.lime_al_cleanup();
			};
			#end
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

			if (currentContext != null)
			{
				var device = alc.getContextsDevice(currentContext);
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

			if (currentContext != null)
			{
				alc.suspendContext(currentContext);
				var device = alc.getContextsDevice(currentContext);

				if (device != null)
				{
					alc.pauseDevice(device);
				}
			}
		}
		#end
	}

	@:noCompletion
	private static function setupConfig():Void
	{
		#if (lime_openal && (windows || mac || linux || android))
		final configContent:Array<String> = [];

		configContent.push('[general]');

		configContent.push('channels=stereo');
		configContent.push('sample-type=float32');
		configContent.push('stereo-mode=speakers');
		configContent.push('stereo-encoding=panpot');
		configContent.push('hrtf=false');
		configContent.push('cf_level=0');
		configContent.push('resampler=fast_bsinc24');
		configContent.push('front-stablizer=false');
		configContent.push('output-limiter=false');
		configContent.push('volume-adjust=0');

		configContent.push('[decoder]');

		configContent.push('hq-mode=false');
		configContent.push('distance-comp=false');
		configContent.push('nfc=false');

		try
		{
			#if (windows || mac || linux)
			final directory:String = Path.directory(Path.withoutExtension(Sys.programPath()));
			#elseif android
			final directory:String = Path.directory(Path.withoutExtension(System.applicationStorageDirectory));
			#end

			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);

			final path:String = Path.join([directory, #if windows 'audio-config.ini' #else 'audio-config.conf' #end]);

			if (!FileSystem.exists(path))
				File.saveContent(path, configContent.join('\n'));

			Sys.println(path);

			Sys.putEnv('ALSOFT_CONF', path);
		}
		catch (e:Dynamic) {}
		#end
	}
}
