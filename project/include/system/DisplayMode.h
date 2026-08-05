#pragma once

#include <graphics/PixelFormat.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	class DisplayMode
	{
	  public:
		int height;
		PixelFormat pixelFormat;
		int refreshRate;
		int width;

		DisplayMode();
		DisplayMode(value DisplayMode);
		DisplayMode(int width, int height, PixelFormat pixelFormat, int refreshRate);

		void CopyFrom(DisplayMode *other);
		void *Value();
	};

} // namespace lime