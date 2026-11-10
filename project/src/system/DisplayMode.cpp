#include <system/DisplayMode.h>

namespace lime
{

	DisplayMode::DisplayMode()
	{
		this->width = 0;
		this->height = 0;
		this->pixelFormat = RGBA32;
		this->refreshRate = 0;
	}

	DisplayMode::DisplayMode(value displayMode)
	{
		this->width = val_int(val_field(displayMode, val_id("width")));
		this->height = val_int(val_field(displayMode, val_id("height")));
		this->pixelFormat = (PixelFormat)val_int(val_field(displayMode, val_id("pixelFormat")));
		this->refreshRate = val_int(val_field(displayMode, val_id("refreshRate")));
	}

	DisplayMode::DisplayMode(int width, int height, PixelFormat pixelFormat, int refreshRate)
	{
		this->width = width;
		this->height = height;
		this->pixelFormat = pixelFormat;
		this->refreshRate = refreshRate;
	}

	value DisplayMode::Value()
	{
		return Value(alloc_empty_object());
	}

	value DisplayMode::Value(value displayMode)
	{
		alloc_field(displayMode, val_id("height"), alloc_int(height));
		alloc_field(displayMode, val_id("pixelFormat"), alloc_int(pixelFormat));
		alloc_field(displayMode, val_id("refreshRate"), alloc_int(refreshRate));
		alloc_field(displayMode, val_id("width"), alloc_int(width));

		return displayMode;
	}

} // namespace lime