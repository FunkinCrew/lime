#include <utils/Bytes.h>

namespace lime
{

	Bytes::Bytes(value bytes)
	{
		object = bytes;

		value bVal = val_field(bytes, val_id("b"));

		if (val_is_string(bVal))
		{
			b = (unsigned char *)val_string(bVal);
		}
		else
		{
			b = (unsigned char *)buffer_data(val_to_buffer(bVal));
		}

		length = val_int(val_field(bytes, val_id("length")));
	}

	Bytes::~Bytes()
	{
		alloc_field(object, val_id("length"), alloc_int(length));
	}

	void Bytes::Resize(int size)
	{
		value bVal = val_field(object, val_id("b"));

		if (val_is_string(bVal))
		{
			if (val_int(val_field(object, val_id("length"))) == size)
			{
				b = (unsigned char *)val_string(bVal);
			}
			else
			{
				value fresh = alloc_raw_string(size);

				b = (unsigned char *)val_string(fresh);

				alloc_field(object, val_id("b"), fresh);
			}
		}
		else
		{
			buffer buf = val_to_buffer(bVal);

			buffer_set_size(buf, size);

			b = (unsigned char *)buffer_data(buf);
		}

		length = size;
	}

} // namespace lime