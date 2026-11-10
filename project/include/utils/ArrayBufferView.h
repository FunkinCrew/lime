#pragma once

#include <system/CFFI.h>
#include <utils/Bytes.h>

namespace lime
{

	struct ArrayBufferView
	{
		value object;
		Bytes *buffer;
		int byteLength;
		int length;

		ArrayBufferView(value arrayBufferView);
		~ArrayBufferView();

		void Resize(int size);
	};

} // namespace lime