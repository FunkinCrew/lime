#pragma once

#include <graphics/ImageBuffer.h>
#include <hx/CFFIPrime.h>
#include <math/Rectangle.h>

namespace lime
{

	struct Image
	{
		ImageBuffer *buffer;
		bool dirty;
		int height;
		int offsetX;
		int offsetY;
		Rectangle *rect;
		int version;
		int width;
		double x;
		double y;

		Image(value image);
		~Image();
	};

} // namespace lime
