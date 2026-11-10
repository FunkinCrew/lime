#pragma once

#include <utils/Bytes.h>

namespace lime
{

	class LZMA
	{
	  public:
		static bool Compress(Bytes *data, Bytes *result);
		static bool Decompress(Bytes *data, Bytes *result);
	};

} // namespace lime