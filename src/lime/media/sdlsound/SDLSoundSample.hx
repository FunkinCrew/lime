package lime.media.sdlsound;

#if (!lime_doc_gen || lime_sdlsound)
import lime._internal.backend.native.NativeCFFI;
import haxe.io.Bytes;

#if hl
@:keep
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:nullSafety
class SDLSoundSample
{
	public var bytesDecoded(default, null):Int;

	@:noCompletion private var handle:Dynamic;

	public var bufferSize(get, set):Int;

	function get_bufferSize():Int
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		return NativeCFFI.lime_sdl_sound_get_buffer_size(handle);
		#else
		return 0;
		#end
	}

	function set_bufferSize(newSize:Int):Int
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var success = NativeCFFI.lime_sdl_sound_set_buffer_size(handle, newSize);
		if (success) return newSize;
		#end
		return 0;
	}

	@:noCompletion private function new(handle:Dynamic)
	{
		this.handle = handle;
		this.bytesDecoded = 0;
	}

	public static function fromFile(path:String):Null<SDLSoundSample>
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var handle = NativeCFFI.lime_sdl_sound_from_file(path);

		if (handle != null)
		{
			return new SDLSoundSample(handle);
		}
		#end

		return null;
	}

	public static function fromBytes(bytes:Bytes):Null<SDLSoundSample>
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var handle = NativeCFFI.lime_sdl_sound_from_bytes(bytes);

		if (handle != null)
		{
			return new SDLSoundSample(handle);
		}
		#end

		return null;
	}

	public function info():Null<SDLSoundInfo>
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var data = NativeCFFI.lime_sdl_sound_info(handle);

		if (data != null)
		{
			var info = new SDLSoundInfo();

			info.channels = data.channels;
			info.format = data.format;
			info.rate = data.rate;

			return info;
		}
		#end

		return null;
	}

	public function getDuration():Int
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		return NativeCFFI.lime_sdl_sound_duration(handle);
		#else
		return 0;
		#end
	}

	public function decode(buffer:Bytes):Int
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var result = NativeCFFI.lime_sdl_sound_decode(handle, buffer);
		bytesDecoded += result;
		return result;
		#else
		return 0;
		#end
	}

	public function decodeAll(buffer:Bytes):Int
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		var result = NativeCFFI.lime_sdl_sound_decode_all(handle, buffer);
		bytesDecoded += result;
		return result;
		#else
		return 0;
		#end
	}

	public function isSeekable():Bool
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		return NativeCFFI.lime_sdl_sound_seekable(handle);
		#else
		return false;
		#end
	}

	public function seek(positionMs:Int):Void
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		NativeCFFI.lime_sdl_sound_seek(handle, positionMs);

		if (positionMs == 0)
		{
			bytesDecoded = 0;
			return;
		}

		var info = this.info();
		if (info != null && info.rate > 0 && info.channels > 0)
		{
			var bytesPerMs = (info.rate * info.channels * (info.format.toBits() / 8)) / 1000;
			bytesDecoded = Std.int(positionMs * bytesPerMs);
		}
		#end
	}

	public function rewind():Void
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		NativeCFFI.lime_sdl_sound_rewind(handle);
		bytesDecoded = 0;
		#end
	}

	public function getFlags():SDLSoundFlags
	{
		#if (lime_cffi && lime_sdlsound && !macro)
		return NativeCFFI.lime_sdl_sound_get_flags(handle);
		#end

		return NONE;
	}
}
#end
