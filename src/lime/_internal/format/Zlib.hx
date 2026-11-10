package lime._internal.format;

import haxe.io.Bytes;

import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class Zlib
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		var result:Bytes = Bytes.alloc(0);

		if (NativeCFFI.lime_zlib_compress(bytes, result))
		{
			return result;
		}

		return null;
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.deflate")(bytes.getData()));
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		var result:Bytes = Bytes.alloc(0);

		if (NativeCFFI.lime_zlib_decompress(bytes, result))
		{
			return result;
		}

		return null;
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.inflate")(bytes.getData()));
		#else
		return null;
		#end
	}
}
