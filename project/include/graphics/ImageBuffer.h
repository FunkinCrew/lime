#ifndef LIME_GRAPHICS_IMAGE_BUFFER_H
#define LIME_GRAPHICS_IMAGE_BUFFER_H


#include <graphics/PixelFormat.h>
#include <system/CFFI.h>
#include <utils/ArrayBufferView.h>


namespace lime {


	struct ImageBuffer {

		hl_type* t;
		int bitsPerPixel;
		ArrayBufferView* data;
		PixelFormat format;
		int height;
		bool premultiplied;
		bool transparent;
		int width;


		ImageBuffer (value imageBuffer);
		~ImageBuffer ();

		void Blit (const unsigned char* data, int x, int y, int width, int height);
		void Resize (int width, int height, int bitsPerPixel = 32);
		int Stride ();
		value Value ();
		value Value (value imageBuffer);

	};


}


#endif