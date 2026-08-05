#include <stdlib.h>
#include <string.h>
#include <system/Mutex.h>
#include <system/System.h>
#include <utils/Bytes.h>
#include <utils/File.h>

namespace lime
{

	static bool init = false;
	static bool useBuffer = false;

	Bytes::Bytes()
	{
		if (!init)
		{
			buffer _buffer = alloc_buffer_len(1);

			if (buffer_data(_buffer))
			{
				useBuffer = true;
			}

			init = true;
		}

		b = 0;
		length = 0;
		ownsMemory = true;
	}

	Bytes::Bytes(value bytes)
	{
		if (!init)
		{
			buffer _buffer = alloc_buffer_len(1);

			if (buffer_data(_buffer))
			{
				useBuffer = true;
			}

			init = true;
		}

		b = 0;
		length = 0;
		ownsMemory = true;

		Set(bytes);
	}

	Bytes::~Bytes()
	{
		if (ownsMemory && b)
		{
			free(b);
		}
	}

	void Bytes::ReadFile(const char *path)
	{
		File file(path, "rb");

		if (!file.handle)
		{
			return;
		}

		file.Seek(0, SEEK_END);

		int size = (int)file.Tell();

		file.Seek(0, SEEK_SET);

		if (size > 0)
		{
			Resize(size);

			file.Read(b, size);
		}

		file.Close();
	}

	void Bytes::WriteFile(const char *path)
	{
		File file(path, "wb");

		if (!file.handle)
		{
			return;
		}

		if (length > 0)
		{
			file.Write(b, length);
			file.Flush();
		}

		file.Close();
	}

	void Bytes::Resize(int size)
	{
		if (size == length)
		{
			return;
		}

		if (size <= 0)
		{
			if (ownsMemory && b)
			{
				free(b);
			}

			b = 0;
			length = 0;
			ownsMemory = true;
		}
		else
		{
			if (ownsMemory)
			{
				unsigned char *data = (unsigned char *)realloc(b, size);

				if (data)
				{
					b = data;
				}
			}
			else
			{
				unsigned char *data = (unsigned char *)malloc(size);

				if (b && length > 0)
				{
					memcpy(data, b, length < size ? length : size);
				}

				b = data;

				ownsMemory = true;
			}

			length = size;
		}
	}

	void Bytes::Set(value bytes)
	{
		int newLength = 0;
		unsigned char *newB = 0;
		bool isNull = val_is_null(bytes);

		if (!isNull)
		{
			value lengthVal = val_field(bytes, val_id("length"));
			value bVal = val_field(bytes, val_id("b"));

			newLength = val_int(lengthVal);

			if (newLength > 0)
			{
				if (val_is_string(bVal))
				{
					newB = (unsigned char *)val_string(bVal);
				}
				else
				{
					newB = (unsigned char *)buffer_data(val_to_buffer(bVal));
				}
			}
		}

		if (ownsMemory && b)
		{
			free(b);
		}

		if (isNull)
		{
			length = 0;
			b = 0;
			ownsMemory = true;
		}
		else
		{
			length = newLength;
			b = newB;
			ownsMemory = false;
		}
	}

	void Bytes::Set(const QuickVec<unsigned char> data)
	{
		int size = data.size();

		if (size > 0)
		{
			Resize(size);

			memcpy(b, &data[0], length);
		}
		else
		{
			if (ownsMemory && b)
			{
				free(b);
			}

			b = 0;
			length = 0;
			ownsMemory = true;
		}
	}

	value Bytes::Value()
	{
		return alloc_null();
	}

	value Bytes::Value(value bytes)
	{
		if (val_is_null(bytes) || !b)
		{
			return alloc_null();
		}
		else
		{
			alloc_field(bytes, val_id("length"), alloc_int(length));

			if (useBuffer)
			{
				value _buffer = val_field(bytes, val_id("b"));

				if (val_is_null(_buffer) || (char *)b != buffer_data(val_to_buffer(_buffer)))
				{
					buffer bufferValue = alloc_buffer_len(length);
					_buffer = buffer_val(bufferValue);
					memcpy((unsigned char *)buffer_data(bufferValue), b, length);
					alloc_field(bytes, val_id("b"), _buffer);
				}
			}
			else
			{
				value _string = val_field(bytes, val_id("b"));

				if (val_is_null(_string) || (const char *)b != val_string(_string))
				{
					value data = alloc_raw_string(length);
					memcpy((void *)val_string(data), b, length);
					alloc_field(bytes, val_id("b"), data);
				}
			}

			return bytes;
		}
	}

} // namespace lime