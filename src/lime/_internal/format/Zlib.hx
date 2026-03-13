package lime._internal.format;

import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
class Zlib
{
	public static function compress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_zlib_compress(bytes, Bytes.alloc(0));
		#elseif js
		#if commonjs
		var data = untyped js.Syntax.code ("require (\"pako\").deflate")(bytes.getData());
		#else
		var data = untyped js.Syntax.code ("pako.deflate")(bytes.getData());
		#end
		return Bytes.ofData(data);
		#else
		return null;
		#end
	}

	public static function decompress(bytes:Bytes):Bytes
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_zlib_decompress(bytes, Bytes.alloc(0));
		#elseif js
		#if commonjs
		var data = untyped js.Syntax.code ("require (\"pako\").inflate")(bytes.getData());
		#else
		var data = untyped js.Syntax.code ("pako.inflate")(bytes.getData());
		#end
		return Bytes.ofData(data);
		#else
		return null;
		#end
	}
}
