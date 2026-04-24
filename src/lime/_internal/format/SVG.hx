package lime._internal.format;

import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.graphics.ImageBuffer)
class SVG
{
	public static function decodeBytes(bytes:Bytes):Image
	{
		#if (lime_cffi && !macro)
		var buffer = NativeCFFI.lime_svg_decode_bytes(bytes, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

		if (buffer != null)
		{
			return new Image(buffer);
		}
		#end

		return null;
	}

	public static function decodeFile(path:String):Image
	{
		#if (lime_cffi && !macro)
		var buffer = NativeCFFI.lime_svg_decode_file(path, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

		if (buffer != null)
		{
			return new Image(buffer);
		}
		#end

		return null;
	}

	public static function decodeBytesSized(bytes:Bytes, width:Int, height:Int):Image
	{
		#if (lime_cffi && !macro)
		var buffer = NativeCFFI.lime_svg_decode_sized_bytes(bytes, width, height, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

		if (buffer != null)
		{
			return new Image(buffer);
		}
		#end

		return null;
	}

	public static function decodeFileSized(path:String, width:Int, height:Int):Image
	{
		#if (lime_cffi && !macro)
		var buffer = NativeCFFI.lime_svg_decode_sized_file(path, width, height, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

		if (buffer != null)
		{
			return new Image(buffer);
		}
		#end

		return null;
	}
}
