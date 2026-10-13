package lime.media;

import lime.utils.Log;
#if lime_miniaudio
import lime.media.miniaudio.MAEngine;
import lime.media.miniaudio.MAEngineConfig;
#if lime_miniaudio_debug_output
import lime.media.miniaudio.MAHelpers;
import lime.media.miniaudio.MALog;
import lime.media.miniaudio.MALogLevel;
#end
#elseif (js && html5 && lime_howlerjs)
import lime.media.howlerjs.Howler;
#end

@:allow(lime._internal.backend.native.NativeApplication)
class AudioManager
{
	#if lime_miniaudio_debug_output
	@:noCompletion
	private static function onLog(level:MALogLevel, pMessage:String):Void
	{
		Log.println('${MAHelpers.log_level_to_string(level)}: ${pMessage}');
	}
	#end

	@:noCompletion
	private static var resumeOnFocus:Bool = false;

	@:noCompletion
	private static var active:Bool = true;

	#if lime_miniaudio
	#if lime_miniaudio_debug_output
	public static var log:MALog;
	#end
	public static var engine:MAEngine;
	#elseif (js && html5)
	public static var audioContext:js.html.audio.AudioContext;
	#end

	public static function init():Void
	{
		#if lime_miniaudio
		if (engine == null)
		{
			#if lime_miniaudio_debug_output
			if (log == null)
			{
				log = MALog.init();

				if (log != null)
				{
					log.register_callback(onLog);
				}
				else
				{
					Log.error("Unable to create MiniAudio engine log config for Native!");
				}
			}
			#end

			final config:MAEngineConfig = MAEngineConfig.init();

			#if lime_miniaudio_debug_output
			config.pLog = log;
			#end

			engine = MAEngine.init(config);

			if (engine == null)
			{
				Log.error("Unable to create MiniAudio engine for Native!");
			}
		}
		#elseif (js && html5 && lime_howlerjs)
		if (audioContext == null)
		{
			if (Howler.usingWebAudio)
			{
				audioContext = Howler.ctx;
			}
			else
			{
				#if (!lime_doc_gen && !display)
				Howler._setupAudioContext();
				#end

				if (Howler.usingWebAudio)
				{
					audioContext = Howler.ctx;
				}
				else
				{
					Log.error("Unable to create HowlerJS context for Web!");
				}
			}
		}
		#elseif (js && html5)
		if (audioContext == null)
		{
			audioContext = cast untyped js.Syntax.code("new window.AudioContext ()");

			if (audioContext == null)
			{
				audioContext = cast untyped js.Syntax.code("new window.webkitAudioContext ()");

				if (audioContext == null)
				{
					Log.error("Unable to create AudioContext for Web!");
				}
			}
		}
		#end
	}

	public static function shutdown():Void
	{
		#if lime_miniaudio
		if (engine != null)
		{
			engine.stop();
			engine.uninit();
			engine = null;
		}

		#if lime_miniaudio_debug_output
		if (log != null)
		{
			log.uninit();
			log = null;
		}
		#end
		#end
	}

	public static function resume():Void
	{
		if (active)
			return;

		#if lime_miniaudio
		engine.start();
		#end

		active = true;
	}

	public static function suspend():Void
	{
		if (!active)
			return;

		#if lime_miniaudio
		engine.stop();
		#end

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
