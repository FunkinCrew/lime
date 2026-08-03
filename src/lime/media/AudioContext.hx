package lime.media;

#if (js && html5 && lime_howlerjs)
import lime.media.howlerjs.Howler;
#end
import lime.utils.Log;
#if miniaudio
import lime._internal.backend.native.NativeCFFI;
#end

@:access(lime.media.FlashAudioContext)
@:access(lime.media.HTML5AudioContext)
@:access(lime.media.MiniaudioAudioContext)
@:access(lime.media.OpenALAudioContext)
@:access(lime.media.WebAudioContext)
#if miniaudio
@:access(lime._internal.backend.native.NativeCFFI)
#end
class AudioContext
{
	public var custom:Dynamic;
	#if (!lime_doc_gen || lime_openal)
	public var openal(default, null):OpenALAudioContext;
	#end
	#if (!lime_doc_gen || lime_miniaudio)
	public var maEngine(default, null):Int;
	#end
	public var type(default, null):AudioContextType;
	#if (!lime_doc_gen || (js && html5))
	public var web(default, null):WebAudioContext;
	#end

	public function new(type:AudioContextType = null)
	{
		if (type != CUSTOM)
		{
			#if (js && html5)
			#if lime_howlerjs
			if (Howler.usingWebAudio)
			{
				web = Howler.ctx;
				this.type = WEB;
			}
			else
			{
				#if (!lime_doc_gen && !display)
				Howler._setupAudioContext();
				#end
				if (Howler.usingWebAudio)
				{
					web = Howler.ctx;
					this.type = WEB;
				}
				else
				{
					Log.info("Unable to create howlerjs context for Web!");
				}
			}
			#else
			try
			{
				untyped js.Syntax.code("window.AudioContext = window.AudioContext || window.webkitAudioContext;");
				web = cast untyped js.Syntax.code("new window.AudioContext ()");
				this.type = WEB;
			}
			catch (e:Dynamic)
			{
				Log.info("Unable to create AudioContext for Web!");
			}
			#end
			#elseif flash
			flash = new FlashAudioContext();
			this.type = FLASH;
			#elseif miniaudio
			#if (lime_cffi && lime_miniaudio && !macro)
			NativeCFFI.lime_miniaudio_backend_init();
			maEngine = NativeCFFI.lime_miniaudio_backend_engine_init(44100, 0, 0, 0);
			#end
			this.type = MINIAUDIO;
			#else
			openal = new OpenALAudioContext();
			this.type = OPENAL;
			#end
		}
		else
		{
			this.type = CUSTOM;
		}
	}
}
