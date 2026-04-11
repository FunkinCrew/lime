#include <graphics/ImageBuffer.h>


namespace lime {


	ImageBuffer::ImageBuffer (value imageBuffer) {

		if (!val_is_null (imageBuffer)) {

			width = val_int (val_field (imageBuffer, val_id ("width")));
			height = val_int (val_field (imageBuffer, val_id ("height")));
			bitsPerPixel = val_int (val_field (imageBuffer, val_id ("bitsPerPixel")));
			format = (PixelFormat)val_int (val_field (imageBuffer, val_id ("format")));
			transparent = val_bool (val_field (imageBuffer, val_id ("transparent")));
			premultiplied = val_bool (val_field (imageBuffer, val_id ("premultiplied")));
			data = new ArrayBufferView (val_field (imageBuffer, val_id ("data")));

		} else {

			width = 0;
			height = 0;
			bitsPerPixel = 32;
			format = RGBA32;
			data = 0;
			premultiplied = false;
			transparent = false;

		}

	}


	ImageBuffer::~ImageBuffer () {

		if (data) {

			delete data;

		}

	}


	void ImageBuffer::Blit (const unsigned char *data, int x, int y, int width, int height) {

		if (x < 0 || x + width > this->width || y < 0 || y + height > this->height) {

			return;

		}

		int stride = Stride ();
		unsigned char *bytes = this->data->buffer->b;

		for (int i = 0; i < height; i++) {

			memcpy (&bytes[(i + y) * this->width + x], &data[i * width], stride);

		}

	}


	void ImageBuffer::Resize (int width, int height, int bitsPerPixel) {

		this->bitsPerPixel = bitsPerPixel;
		this->width = width;
		this->height = height;

		int stride = Stride ();

		if (!this->data) {

			//this->data = new ArrayBufferView (height * stride);

		} else {

			this->data->Resize (height * stride);

		}

	}


	int ImageBuffer::Stride () {

		return width * (((bitsPerPixel + 3) & ~0x3) >> 3);

	}


	value ImageBuffer::Value () {

		return Value (alloc_empty_object ());

	}


	value ImageBuffer::Value (value imageBuffer) {

		alloc_field (imageBuffer, val_id ("width"), alloc_int (width));
		alloc_field (imageBuffer, val_id ("height"), alloc_int (height));
		alloc_field (imageBuffer, val_id ("bitsPerPixel"), alloc_int (bitsPerPixel));
		alloc_field (imageBuffer, val_id ("data"), data ? data->Value (val_field (imageBuffer, val_id ("data"))) : alloc_null ());
		alloc_field (imageBuffer, val_id ("transparent"), alloc_bool (transparent));
		alloc_field (imageBuffer, val_id ("format"), alloc_int (format));
		alloc_field (imageBuffer, val_id ("premultiplied"), alloc_bool (premultiplied));

		return imageBuffer;

	}


}