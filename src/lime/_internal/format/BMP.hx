package lime._internal.format;

import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;
#if (js && html5)
import lime._internal.graphics.ImageCanvasUtil;
import js.Browser;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.graphics.ImageBuffer)
class BMP
{
	public static function decodeBytes(bytes:Bytes):Image
	{
		#if (lime_cffi && !macro)
		var buffer = NativeCFFI.lime_bmp_decode_bytes(bytes, true, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

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
		var buffer = NativeCFFI.lime_bmp_decode_file(path, true, new ImageBuffer(new UInt8Array(Bytes.alloc(0))));

		if (buffer != null)
		{
			return new Image(buffer);
		}
		#end

		return null;
	}

	public static function encode(image:Image):Bytes
	{
		if (image.premultiplied || image.format != RGBA32)
		{
			// TODO: Handle encode from different formats

			image = image.clone();
			image.premultiplied = false;
			image.format = RGBA32;
		}

		#if (lime_cffi && !macro)
		return NativeCFFI.lime_image_encode(image.buffer, 2, 0, Bytes.alloc(0));
		#elseif (js && html5)
		ImageCanvasUtil.convertToCanvas(image, false);

		if (image.buffer.__srcCanvas != null)
		{
			var data = image.buffer.__srcCanvas.toDataURL("image/bmp");
			var buffer = Browser.window.atob(data.split(";base64,")[1]);
			var bytes = Bytes.alloc(buffer.length);

			for (i in 0...buffer.length)
			{
				bytes.set(i, buffer.charCodeAt(i));
			}

			return bytes;
		}
		#else
		return null;
		#end
	}
}
