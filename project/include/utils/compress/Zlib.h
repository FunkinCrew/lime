#pragma once


#include <utils/Bytes.h>


namespace lime {


	enum ZlibType {

		DEFLATE,
		GZIP,
		ZLIB

	};


	class Zlib {


		public:

			static void Compress (ZlibType type, Bytes* data, Bytes* result);
			static void Decompress (ZlibType type, Bytes* data, Bytes* result);


	};


}