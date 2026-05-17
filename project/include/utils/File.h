#pragma once


#include <utils/Bytes.h>


namespace lime {


	class File {


		public:


			File (const char* path, const char* mode);
			File (Bytes* bytes);

			bool Close ();
			bool Flush ();
			size_t Read (void *ptr, size_t size);
			int64_t Seek (int64_t offset, int whence);
			int64_t Tell ();
			size_t Write (const void *ptr, size_t size);

			void *handle;


	};


}
