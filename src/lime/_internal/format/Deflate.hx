package lime._internal.format;

import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class Deflate
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_deflate_compress(bytes, Bytes.alloc(0));
		#elseif js
		#if commonjs
		var data = untyped js.Syntax.code("require (\"pako\").deflateRaw")(bytes.getData());
		#else
		var data = untyped js.Syntax.code("pako.deflateRaw")(bytes.getData());
		#end
		return Bytes.ofData(data);
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_deflate_decompress(bytes, Bytes.alloc(0));
		#elseif js
		#if commonjs
		var data = untyped js.Syntax.code("require (\"pako\").inflateRaw")(bytes.getData());
		#else
		var data = untyped js.Syntax.code("pako.inflateRaw")(bytes.getData());
		#end
		return Bytes.ofData(data);
		#else
		return null;
		#end
	}
}
