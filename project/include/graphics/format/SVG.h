#pragma once


#include <graphics/ImageBuffer.h>
#include <utils/Bytes.h>
#include <utils/Resource.h>


namespace lime {


	class SVG {


		public:

			static bool Decode (Resource *resource, ImageBuffer *imageBuffer);
			static bool DecodeSized (Resource *resource, int width, int height, ImageBuffer *imageBuffer);


	};


}
