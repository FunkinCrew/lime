#pragma once

#include <system/CFFI.h>

namespace lime
{

	struct Bytes
	{
		value object;
		unsigned char *b;
		int length;

		Bytes(value bytes);
		~Bytes();

		void Resize(int size);
		void Commit();
	};

} // namespace lime