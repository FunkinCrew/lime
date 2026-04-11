#include <graphics/Image.h>


namespace lime {


	Image::Image (value image) {

		width = val_int (val_field (image, val_id ("width")));
		height = val_int (val_field (image, val_id ("height")));
		buffer = new ImageBuffer (val_field (image, val_id ("buffer")));
		offsetX = val_int (val_field (image, val_id ("offsetX")));
		offsetY = val_int (val_field (image, val_id ("offsetY")));

	}


	Image::~Image () {

		if (buffer) {

			delete buffer;

		}

	}


}