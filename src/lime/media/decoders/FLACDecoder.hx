package lime.media.decoders;

#if (!lime_doc_gen || lime_drlibs)
import haxe.Int64;
import haxe.io.Bytes;
import lime.utils.ArrayBuffer;
import lime.media.AudioDecoder;

#if (lime_cffi && lime_drlibs)
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
#end
#if hl
@:keep
#end
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

/**

**/
class FLACDecoder extends AudioDecoder
{
	public static function fromBytes(bytes:Bytes):FLACDecoder
	{
		#if (lime_cffi && lime_drlibs)
		var handle = NativeCFFI.lime_drlibs_flac_from_bytes(bytes);
		if (handle == null) return null;

		var decoder = new FLACDecoder(handle);
		decoder.bytes = bytes;
		return decoder;
		#else
		return null;
		#end
	}

	public static function fromFile(path:String):FLACDecoder
	{
		#if (lime_cffi && lime_drlibs)
		var handle = NativeCFFI.lime_drlibs_flac_from_file(path);
		if (handle == null) return null;

		var decoder = new FLACDecoder(handle);
		decoder.path = path;
		return decoder;
		#else
		return null;
		#end
	}

	@:noCompletion private var handle:Dynamic;

	@:noCompletion private function new(handle:Dynamic)
	{
		super();
		this.handle = handle;

		#if (lime_cffi && lime_drlibs)
		if (handle != null)
		{
			var data = NativeCFFI.lime_drlibs_flac_info(handle);
			bitsPerSample = data.bitsPerSample;
			channels = data.channels;
			sampleRate = data.sampleRate;
		}
		#end
	}

	override function dispose():Void
	{
		super.dispose();
		#if (lime_cffi && lime_drlibs)
		if (handle != null) NativeCFFI.lime_drlibs_flac_close(handle);
		#end
		handle = null;
	}

	override function clone():FLACDecoder
	{
		#if (lime_cffi && lime_drlibs)
		if (path != null) return FLACDecoder.fromFile(path);
		else if (bytes != null) return FLACDecoder.fromBytes(bytes);
		#end
		return null;
	}

	override function decode(buffer:ArrayBuffer, pos:Int, len:Int, word:Int):Int
	{
		#if (lime_cffi && lime_drlibs)
		pos = NativeCFFI.lime_drlibs_flac_decode(handle, buffer, pos, len, word);
		eof = pos < len;
		return pos;
		#else
		return 0;
		#end
	}

	override function seek(samples:Int64):Bool
	{
		#if (lime_cffi && lime_drlibs)
		if (NativeCFFI.lime_drlibs_flac_seek(handle, samples.low, samples.high) == 1)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function rewind():Bool
	{
		#if (lime_cffi && lime_drlibs)
		if (NativeCFFI.lime_drlibs_flac_seek(handle, 0, 0) == 1)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function tell():Int64
	{
		#if (lime_cffi && lime_drlibs)
		var data = NativeCFFI.lime_drlibs_flac_tell(handle);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function total():Int64
	{
		#if (lime_cffi && lime_drlibs)
		var data = NativeCFFI.lime_drlibs_flac_total(handle);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function seekable():Bool
	{
		#if (lime_cffi && lime_drlibs)
		return true;
		#else
		return false;
		#end
	}
}
#end