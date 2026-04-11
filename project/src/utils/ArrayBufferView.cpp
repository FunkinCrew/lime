#include <utils/ArrayBufferView.h>


namespace lime {


	ArrayBufferView::ArrayBufferView (value arrayBufferView) {

		if (!val_is_null (arrayBufferView)) {

			buffer = new Bytes (val_field (arrayBufferView, val_id ("buffer")));
			byteLength = val_int (val_field (arrayBufferView, val_id ("byteLength")));
			length = val_int (val_field (arrayBufferView, val_id ("length")));

		} else {

			buffer = new Bytes ();
			byteLength = 0;
			length = 0;

		}

	}


	ArrayBufferView::~ArrayBufferView () {

		if (buffer) {

			delete buffer;

		}

	}


	void ArrayBufferView::Resize (int size) {

		buffer->Resize (size);

		byteLength = size;
		length = size;

	}


	void ArrayBufferView::Set (value bytes) {

		buffer->Set (bytes);
		byteLength = buffer->length;
		length = byteLength;

	}


	void ArrayBufferView::Set (const QuickVec<unsigned char> data) {

		buffer->Set (data);
		byteLength = buffer->length;
		length = byteLength;

	}


	value ArrayBufferView::Value () {

		return Value (alloc_empty_object ());

	}


	value ArrayBufferView::Value (value arrayBufferView) {

		alloc_field (arrayBufferView, val_id ("buffer"), buffer ? buffer->Value (val_field (arrayBufferView, val_id ("buffer"))) : alloc_null ());
		alloc_field (arrayBufferView, val_id ("byteLength"), alloc_int (byteLength));
		alloc_field (arrayBufferView, val_id ("length"), alloc_int (length));

		return arrayBufferView;

	}


}