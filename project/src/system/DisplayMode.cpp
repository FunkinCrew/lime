#include <system/DisplayMode.h>


namespace lime {


	DisplayMode::DisplayMode () {

		width = 0;
		height = 0;
		pixelFormat = RGBA32;
		refreshRate = 0;

	}


	DisplayMode::DisplayMode (value displayMode) {

		width = val_int (val_field (displayMode, val_id ("width")));
		height = val_int (val_field (displayMode, val_id ("height")));
		pixelFormat = (PixelFormat)val_int (val_field (displayMode, val_id ("pixelFormat")));
		refreshRate = val_int (val_field (displayMode, val_id ("refreshRate")));

	}


	DisplayMode::DisplayMode (int _width, int _height, PixelFormat _pixelFormat, int _refreshRate) {

		width = _width;
		height = _height;
		pixelFormat = _pixelFormat;
		refreshRate = _refreshRate;

	}


	void DisplayMode::CopyFrom (DisplayMode* other) {

		height = other->height;
		pixelFormat = other->pixelFormat;
		refreshRate = other->refreshRate;
		width = other->width;

	}


	void* DisplayMode::Value () {

		value displayMode = alloc_empty_object ();
		alloc_field (displayMode, val_id ("height"), alloc_int (height));
		alloc_field (displayMode, val_id ("pixelFormat"), alloc_int (pixelFormat));
		alloc_field (displayMode, val_id ("refreshRate"), alloc_int (refreshRate));
		alloc_field (displayMode, val_id ("width"), alloc_int (width));
		return displayMode;

	}


}