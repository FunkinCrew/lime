#pragma once

#include <graphics/ImageBuffer.h>
#include <utils/File.h>

namespace lime
{

	class PNG
	{
	  public:
		static bool Decode(File *file, ImageBuffer *imageBuffer);
		static bool Encode(ImageBuffer *imageBuffer, Bytes *bytes);
	};

} // namespace lime
