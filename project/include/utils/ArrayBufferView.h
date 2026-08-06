#pragma once

#include <hx/CFFIPrime.h>
#include <utils/Bytes.h>

namespace lime
{

	struct ArrayBufferView
	{
		int type;
		Bytes *buffer;
		int byteOffset;
		int byteLength;
		int length;
		int bytesPerElement;

		ArrayBufferView(value arrayBufferView);
		~ArrayBufferView();

		void Resize(int size);
		void Set(value bytes);
		value Value();
		value Value(value arrayBufferView);
	};

} // namespace lime