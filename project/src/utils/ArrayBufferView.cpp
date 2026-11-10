#include <utils/ArrayBufferView.h>

namespace lime
{

	ArrayBufferView::ArrayBufferView(value arrayBufferView)
	{
		object = arrayBufferView;
		buffer = new Bytes(val_field(arrayBufferView, val_id("buffer")));
		byteLength = val_int(val_field(arrayBufferView, val_id("byteLength")));
		length = val_int(val_field(arrayBufferView, val_id("length")));
	}

	ArrayBufferView::~ArrayBufferView()
	{
		alloc_field(object, val_id("byteLength"), alloc_int(byteLength));

		alloc_field(object, val_id("length"), alloc_int(length));

		delete buffer;
	}

	void ArrayBufferView::Resize(int size)
	{
		buffer->Resize(size);
		byteLength = size;
		length = size;
	}

} // namespace lime