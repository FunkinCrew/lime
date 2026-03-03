package lime.media.decoders;

#if (!lime_doc_gen || lime_opus)
import haxe.Int64;
import haxe.io.Bytes;
import lime.utils.ArrayBuffer;
import lime.media.AudioDecoder;

#if (lime_cffi && lime_opus)
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
class OpusDecoder extends AudioDecoder
{
	public static function fromBytes(bytes:Bytes):OpusDecoder
	{
		#if (lime_cffi && lime_opus)
		var handle = NativeCFFI.lime_opus_file_from_bytes(bytes);
		if (handle == null) return null;

		var decoder = new OpusDecoder(handle);
		decoder.bytes = bytes;
		return decoder;
		#else
		return null;
		#end
	}

	public static function fromFile(path:String):OpusDecoder
	{
		#if (lime_cffi && lime_opus)
		var handle = NativeCFFI.lime_opus_file_from_file(path);
		if (handle == null) return null;

		var decoder = new OpusDecoder(handle);
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

		#if (lime_cffi && lime_opus)
		if (handle != null)
		{
			bitsPerSample = 16;
			channels = NativeCFFI.lime_opus_file_channel_count(handle);
			sampleRate = 48000;
		}
		#end
	}

	override function dispose():Void
	{
		super.dispose();
		#if (lime_cffi && lime_opus)
		if (handle != null) NativeCFFI.lime_opus_file_free(handle);
		#end
		handle = null;
	}

	override function clone():OpusDecoder
	{
		#if (lime_cffi && lime_opus)
		if (path != null) return OpusDecoder.fromFile(path);
		else if (bytes != null) return OpusDecoder.fromBytes(bytes);
		#end
		return null;
	}

	override function decode(buffer:ArrayBuffer, pos:Int, len:Int, word:Int):Int
	{
		#if (lime_cffi && lime_opus)
		// Can only read as 16 bits per sample internally in libopus
		pos = NativeCFFI.lime_opus_file_decode(handle, buffer, pos, len);
		eof = pos < len;
		return pos;
		#else
		return 0;
		#end
	}

	override function seek(samples:Int64):Bool
	{
		#if (lime_cffi && lime_opus)
		if (NativeCFFI.lime_opus_file_seek(handle, samples.low, samples.high) == 0)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function rewind():Bool
	{
		#if (lime_cffi && lime_opus)
		if (NativeCFFI.lime_opus_file_seek(handle, 0, 0) == 0)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function tell():Int64
	{
		#if (lime_cffi && lime_opus)
		var data = NativeCFFI.lime_opus_file_tell(handle);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function total():Int64
	{
		#if (lime_cffi && lime_opus)
		var data = NativeCFFI.lime_opus_file_total(handle);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function seekable():Bool
	{
		#if (lime_cffi && lime_opus)
		return NativeCFFI.lime_opus_file_seekable(handle);
		#else
		return false;
		#end
	}
}
#end