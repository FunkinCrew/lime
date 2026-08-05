#pragma once

#include <hx/CFFIPrime.h>
#include <utils/Bytes.h>

namespace lime
{

	struct ArrayBufferView
	{
		/*TypedArrayType*/ int type;
		Bytes *buffer;
		int byteOffset;
		int byteLength;
		int length;
		int bytesPerElement;

		ArrayBufferView(value arrayBufferView);
		~ArrayBufferView();

		void Resize(int size);
		void Set(value bytes);
		void Set(const QuickVec<unsigned char> data);
		value Value();
		value Value(value arrayBufferView);
	};

} // namespace lime