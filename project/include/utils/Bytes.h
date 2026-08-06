#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	struct Bytes
	{
		int length;
		unsigned char *b;
		bool ownsMemory;

		Bytes();
		Bytes(value bytes);
		~Bytes();

		void ReadFile(const char *path);
		void WriteFile(const char *path);
		void Resize(int size);
		void Set(value bytes);
		value Value(value bytes);
		value Value();
	};

} // namespace lime