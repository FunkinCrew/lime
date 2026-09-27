package lime._internal.format;

import haxe.io.Bytes;

import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class LZMA
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_lzma_compress(bytes, Bytes.alloc(0));
		#elseif js
		var data = untyped js.Syntax.code("LZMA.compress")(new lime.utils.UInt8Array(bytes.getData()), 5);
		return (data is String) ? Bytes.ofString(data) : Bytes.ofData(cast data);
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_lzma_decompress(bytes, Bytes.alloc(0));
		#elseif js
		var data = untyped js.Syntax.code("LZMA.decompress")(new lime.utils.UInt8Array(bytes.getData()));
		return (data is String) ? Bytes.ofString(data) : Bytes.ofData(cast data);
		#else
		return null;
		#end
	}
}
