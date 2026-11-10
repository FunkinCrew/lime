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
		DisplayMode(value displayMode);
		DisplayMode(int width, int height, PixelFormat pixelFormat, int refreshRate);

		value Value();
		value Value(value displayMode);
	};

} // namespace lime