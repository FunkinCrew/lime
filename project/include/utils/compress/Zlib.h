#pragma once

#include <utils/Bytes.h>

namespace lime
{

	enum ZlibType
	{
		DEFLATE,
		GZIP,
		ZLIB
	};

	class Zlib
	{
	  public:
		static bool Compress(ZlibType type, Bytes *data, Bytes *result);
		static bool Decompress(ZlibType type, Bytes *data, Bytes *result);
	};

} // namespace lime