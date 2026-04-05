#pragma once


#include <utils/Bytes.h>


namespace lime {


	class LZMA {


		public:

			static void Compress (Bytes* data, Bytes* result);
			static void Decompress (Bytes* data, Bytes* result);


	};


}