#pragma once


#include <graphics/ImageBuffer.h>
#include <utils/Bytes.h>
#include <utils/Resource.h>


namespace lime {


	class PNG {


		public:

			static bool Decode (Resource *resource, ImageBuffer *imageBuffer, bool decodeData = true);
			static bool Encode (ImageBuffer *imageBuffer, Bytes *bytes);


	};


}
