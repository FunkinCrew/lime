package lime._internal.format;

import haxe.io.Bytes;

import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class Deflate
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		var result:Bytes = Bytes.alloc(0);

		if (NativeCFFI.lime_deflate_compress(bytes, result))
		{
			return result;
		}

		return null;
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.deflateRaw")(bytes.getData()));
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		var result:Bytes = Bytes.alloc(0);

		if (NativeCFFI.lime_deflate_decompress(bytes, result))
		{
			return result;
		}

		return null;
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.inflateRaw")(bytes.getData()));
		#else
		return null;
		#end
	}
}
