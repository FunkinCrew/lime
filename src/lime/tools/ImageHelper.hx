package lime.tools;

import sys.io.File;
import sys.io.FileSeek;

#if (lime && lime_cffi && !macro)
import lime._internal.format.SVG;
import lime.graphics.Image;
#end

class ImageHelper
{
	public static function rasterizeSVG(path:String, width:Int, height:Int):#if (lime && lime_cffi && !macro) Image #else Dynamic #end
	{
		#if (lime && lime_cffi && !macro)
		if (path == null)
			return null;

		var image = SVG.decodeFileSized(path, width, height);

		if (image.buffer != null)
		{
			return image;
		}
		#end

		return null;
	}

	public static function readPNGImageSize(path:String)
	{
		var toReturn = {width: 0, height: 0};
		var fileInput = File.read(path);
		var header = (fileInput.readByte() << 8) | fileInput.readByte();

		if (header == 0x8950)
		{
			fileInput.seek(8 + 4 + 4, FileSeek.SeekBegin);

			var width = (fileInput.readByte() << 24) | (fileInput.readByte() << 16) | (fileInput.readByte() << 8) | fileInput.readByte();
			var height = (fileInput.readByte() << 24) | (fileInput.readByte() << 16) | (fileInput.readByte() << 8) | fileInput.readByte();

			toReturn = {
				width: width,
				height: height
			};
		}

		fileInput.close();

		return toReturn;
	}

	public static function resizeImage(image:#if (lime && lime_cffi && !macro) Image #else Dynamic #end, width:Int,
			height:Int):#if (lime && lime_cffi && !macro) Image #else Dynamic #end
	{
		#if (lime && lime_cffi && !macro)
		if (image == null)
			return null;

		if (image.width == width && image.height == height)
		{
			return image;
		}

		image.resize(width, height);
		#end

		return image;
	}
}
