#pragma once

#include <graphics/PixelFormat.h>
#include <hx/CFFIPrime.h>
#include <utils/ArrayBufferView.h>

namespace lime
{

	struct ImageBuffer
	{
		value object;
		int bitsPerPixel;
		ArrayBufferView *data;
		PixelFormat format;
		int height;
		bool premultiplied;
		bool transparent;
		int width;

		ImageBuffer(value imageBuffer);
		~ImageBuffer();

		void Resize(int width, int height, int bitsPerPixel);
		int Stride();
	};

} // namespace lime