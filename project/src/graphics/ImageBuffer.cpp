#include <graphics/ImageBuffer.h>
#include <string.h>

namespace lime
{

	ImageBuffer::ImageBuffer(value imageBuffer)
	{
		this->object = imageBuffer;
		this->width = val_int(val_field(imageBuffer, val_id("width")));
		this->height = val_int(val_field(imageBuffer, val_id("height")));
		this->bitsPerPixel = val_int(val_field(imageBuffer, val_id("bitsPerPixel")));
		this->format = (PixelFormat)val_int(val_field(imageBuffer, val_id("format")));
		this->transparent = val_bool(val_field(imageBuffer, val_id("transparent")));
		this->premultiplied = val_bool(val_field(imageBuffer, val_id("premultiplied")));
		this->data = new ArrayBufferView(val_field(imageBuffer, val_id("data")));
	}

	ImageBuffer::~ImageBuffer()
	{
		alloc_field(object, val_id("width"), alloc_int(width));
		alloc_field(object, val_id("height"), alloc_int(height));
		alloc_field(object, val_id("bitsPerPixel"), alloc_int(bitsPerPixel));
		alloc_field(object, val_id("transparent"), alloc_bool(transparent));
		alloc_field(object, val_id("format"), alloc_int(format));
		alloc_field(object, val_id("premultiplied"), alloc_bool(premultiplied));

		delete data;
	}

	void ImageBuffer::Resize(int width, int height, int bitsPerPixel)
	{
		this->bitsPerPixel = bitsPerPixel;
		this->width = width;
		this->height = height;
		this->data->Resize(height * Stride());
	}

	int ImageBuffer::Stride()
	{
		return width * (((bitsPerPixel + 3) & ~0x3) >> 3);
	}

} // namespace lime