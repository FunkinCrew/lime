#pragma once

#include <graphics/ImageBuffer.h>
#include <utils/File.h>

namespace lime
{

	class SVG
	{
	  public:
		static bool Decode(File *file, ImageBuffer *imageBuffer);
		static bool DecodeSized(File *file, int width, int height, ImageBuffer *imageBuffer);
	};

} // namespace lime
