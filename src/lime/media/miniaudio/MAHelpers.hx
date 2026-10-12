package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class MAHelpers
{
	public static function get_format_name(format:MAFormat):String
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_get_format_name(format);
		#else
		return "Invalid";
		#end
	}

	public static function get_bytes_per_sample(format:MAFormat):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_get_bytes_per_sample(format);
		#else
		return 0;
		#end
	}

	public static function get_bytes_per_frame(format:MAFormat, channels:Int):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_get_bytes_per_frame(format, channels);
		#else
		return 0;
		#end
	}

	public static function log_level_to_string(logLevel:MALogLevel):String
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_log_level_to_string(logLevel);
		#else
		return "ERROR";
		#end
	}
}
#end
