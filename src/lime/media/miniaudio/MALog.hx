package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.system.CFFIPointer)
@:forward
abstract MALog(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public static function init():MALog
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_log_init();
		#else
		return null;
		#end
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_log_uninit(this);
		#end
	}

	public function register_callback(onLog:(level:MALogLevel, pMessage:String) -> Void):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_log_register_callback(this, onLog);
		#else
		return MAResult.ERROR;
		#end
	}

	public function unregister_callback(onLog:(level:MALogLevel, pMessage:String) -> Void):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_log_unregister_callback(this, onLog);
		#else
		return MAResult.ERROR;
		#end
	}

	public function post(level:Int, pMessage:String):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_log_post(this, level, pMessage);
		#else
		return MAResult.ERROR;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MALog, b:MALog):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MALog, b:MALog):Bool
	{
		return a.get() != b.get();
	}
}
#end
