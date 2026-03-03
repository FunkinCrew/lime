package lime.media.decoders;

#if (!lime_doc_gen || lime_vorbis)
import haxe.Int64;
import haxe.io.Bytes;
import lime.utils.ArrayBuffer;
import lime.media.AudioDecoder;

#if (lime_cffi && lime_vorbis)
import lime._internal.backend.native.NativeCFFI;
import lime.media.vorbis.VorbisFile;

@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.media.vorbis.VorbisFile)
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
class VorbisDecoder extends AudioDecoder
{
	public static function fromBytes(bytes:Bytes):VorbisDecoder
	{
		#if (lime_cffi && lime_vorbis)
		var handle = NativeCFFI.lime_vorbis_file_from_bytes(bytes);
		if (handle == null) return null;

		var decoder = new VorbisDecoder(handle);
		decoder.bytes = bytes;
		return decoder;
		#else
		return null;
		#end
	}

	public static function fromFile(path:String):VorbisDecoder
	{
		#if (lime_cffi && lime_vorbis)
		var handle = NativeCFFI.lime_vorbis_file_from_file(path);
		if (handle == null) return null;

		var decoder = new VorbisDecoder(handle);
		decoder.path = path;
		return decoder;
		#else
		return null;
		#end
	}

	#if (lime_cffi && lime_vorbis)
	public static function fromVorbisFile(vorbisFile:VorbisFile)
	{
		var decoder = new VorbisDecoder(vorbisFile.handle);
		return decoder;
	}
	#else
	public static function fromVorbisFile(vorbisFile:Dynamic)
	{
		return null;
	}
	#end

	public var version:Int;

	@:noCompletion private var handle:Dynamic;

	@:noCompletion private function new(handle:Dynamic)
	{
		super();
		this.handle = handle;

		#if (lime_cffi && lime_vorbis)
		if (handle != null)
		{
			var data = NativeCFFI.lime_vorbis_file_info(handle, -1);
			bitsPerSample = 16;
			channels = data.channels;
			sampleRate = data.rate;
			version = data.version;
		}
		#end
	}

	override function dispose():Void
	{
		super.dispose();
		#if (lime_cffi && lime_vorbis)
		if (handle != null) NativeCFFI.lime_vorbis_file_clear(handle);
		#end
		handle = null;
	}

	override function clone():VorbisDecoder
	{
		#if (lime_cffi && lime_vorbis)
		if (path != null) return VorbisDecoder.fromFile(path);
		else if (bytes != null) return VorbisDecoder.fromBytes(bytes);
		#end
		return null;
	}

	override function decode(buffer:ArrayBuffer, pos:Int, len:Int, word:Int):Int
	{
		#if (lime_cffi && lime_vorbis)
		pos = NativeCFFI.lime_vorbis_file_decode(handle, buffer, pos, len, word);
		eof = pos < len;
		return pos;
		#else
		return 0;
		#end
	}

	override function seek(samples:Int64):Bool
	{
		#if (lime_cffi && lime_vorbis)
		if (NativeCFFI.lime_vorbis_file_pcm_seek(handle, samples.low, samples.high) == 0)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function rewind():Bool
	{
		#if (lime_cffi && lime_vorbis)
		if (NativeCFFI.lime_vorbis_file_raw_seek(handle, 0, 0) == 0)
		{
			eof = false;
			return true;
		}
		#end
		return false;
	}

	override function tell():Int64
	{
		#if (lime_cffi && lime_vorbis)
		var data = NativeCFFI.lime_vorbis_file_pcm_tell(handle);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function total():Int64
	{
		#if (lime_cffi && lime_vorbis)
		var data = NativeCFFI.lime_vorbis_file_pcm_total(handle, -1);
		return Int64.make(data.high, data.low);
		#else
		return Int64.ofInt(0);
		#end
	}

	override function seekable():Bool
	{
		#if (lime_cffi && lime_vorbis)
		return NativeCFFI.lime_vorbis_file_seekable(handle);
		#else
		return false;
		#end
	}
}
#end