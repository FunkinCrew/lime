package lime._internal.format;

import haxe.io.Bytes;

import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class GZip
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_gzip_compress(bytes, Bytes.alloc(0));
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.gzip")(bytes.getData()));
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_gzip_decompress(bytes, Bytes.alloc(0));
		#elseif js
		return Bytes.ofData(untyped js.Syntax.code("pako.ungzip")(bytes.getData()));
		#else
		return null;
		#end
	}
}
