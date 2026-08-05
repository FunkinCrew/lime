#pragma once

#include <hx/CFFIPrime.h>
#include <utils/QuickVec.h>

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
		void Set(const QuickVec<unsigned char> data);
		value Value(value bytes);
		value Value();
	};

} // namespace lime