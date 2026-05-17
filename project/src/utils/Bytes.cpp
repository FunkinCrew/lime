#include <system/Mutex.h>
#include <system/System.h>
#include <utils/Bytes.h>
#include <utils/File.h>
#include <map>


namespace lime {


	static bool init = false;
	static bool useBuffer = false;
	static std::map<Bytes*, bool> hadValue;
	static std::map<Bytes*, bool> usingValue;
	static Mutex mutex;


	inline void _initializeBytes () {

		#ifndef LIME_HASHLINK
		if (!init) {

			buffer _buffer = alloc_buffer_len (1);

			if (buffer_data (_buffer)) {

				useBuffer = true;

			}

			init = true;

		}
		#endif

	}


	Bytes::Bytes () {

		_initializeBytes ();

		b = 0;
		length = 0;

	}


	Bytes::Bytes (value bytes) {

		_initializeBytes ();

		b = 0;
		length = 0;

		Set (bytes);

	}


	Bytes::~Bytes () {

		mutex.Lock ();

		if (hadValue.find (this) != hadValue.end ()) {

			hadValue.erase (this);

			if (usingValue.find (this) == usingValue.end () && b) {

				free (b);

			}

		}

		if (usingValue.find (this) != usingValue.end ()) {

			usingValue.erase (this);

		}

		mutex.Unlock ();

	}


	void Bytes::ReadFile (const char* path) {

		File file (path, "rb");

		if (!file.handle) {

			return;

		}

		file.Seek (0, SEEK_END);

		int size = (int)file.Tell ();

		file.Seek (0, SEEK_SET);

		if (size > 0) {

			Resize (size);

			file.Read (b, size);

		}

		file.Close ();

	}


	void Bytes::WriteFile (const char* path) {

		File file (path, "wb");

		if (!file.handle) {

			return;

		}

		if (length > 0) {

			file.Write (b, length);
			file.Flush ();

		}

		file.Close ();

	}


	void Bytes::Resize (int size) {

		if (size == length) {

			return;

		}

		mutex.Lock ();

		if (size <= 0) {

			if (b) {

				if (usingValue.find (this) == usingValue.end ()) {

					free (b);

				}

				b = 0;
				length = 0;

			}

		} else {

			unsigned char* data = (unsigned char*)malloc (sizeof (char) * size);

			if (b && length > 0) {

				memcpy (data, b, length < size ? length : size);

				if (usingValue.find (this) == usingValue.end ()) {

					free (b);

				}

			}

			usingValue.erase (this);
			b = data;
			length = size;

		}

		mutex.Unlock ();

	}


	void Bytes::Set(value bytes) {

	    int newLength = 0;
	    unsigned char* newB = 0;
	    bool isNull = val_is_null (bytes);

	    if (!isNull) {

	        value lengthVal = val_field (bytes, val_id ("length"));
	        value bVal = val_field (bytes, val_id ("b"));

	        newLength = val_int(lengthVal);

	        if (newLength > 0) {

	            if (val_is_string (bVal)) {
	                newB = (unsigned char*)val_string (bVal);
	            } else {
	                newB = (unsigned char*)buffer_data (val_to_buffer (bVal));
	            }
	        }
	    }

	    mutex.Lock ();

	    if (isNull) {

	        usingValue.erase (this);
	        length = 0;
	        b = 0;

	    } else {

	        hadValue[this] = true;
	        usingValue[this] = true;
	        length = newLength;
	        b = newB;

	    }

	    mutex.Unlock ();

	}


	void Bytes::Set (const QuickVec<unsigned char> data) {

		int size = data.size ();

		if (size > 0) {

			Resize (size);

			memcpy (b, &data[0], length);

		} else {

			mutex.Lock ();

			if (usingValue.find (this) != usingValue.end ()) {

				usingValue.erase (this);

			}

			if (b) {

				free (b);

			}

			b = 0;
			length = 0;

			mutex.Unlock ();

		}

	}


	value Bytes::Value () {

		return alloc_null ();

	}


	value Bytes::Value (value bytes) {

		if (val_is_null (bytes) || !b) {

			return alloc_null ();

		} else {

			alloc_field (bytes, val_id ("length"), alloc_int (length));

			if (useBuffer) {

				value _buffer = val_field (bytes, val_id ("b"));

				if (val_is_null (_buffer) || (char*)b != buffer_data (val_to_buffer (_buffer))) {

					buffer bufferValue = alloc_buffer_len (length);
					_buffer = buffer_val (bufferValue);
					memcpy ((unsigned char*)buffer_data (bufferValue), b, length);
					alloc_field (bytes, val_id ("b"), _buffer);

				}

			} else {

				value _string = val_field (bytes, val_id ("b"));

				if (val_is_null (_string) || (const char*)b != val_string (_string)) {

					value data = alloc_raw_string (length);
					memcpy ((void*)val_string (data), b, length);
					alloc_field (bytes, val_id ("b"), data);

				}

			}

			return bytes;

		}

	}


}