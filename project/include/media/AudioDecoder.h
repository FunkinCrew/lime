#pragma once


#include <utils/Resource.h>


namespace lime {
	

	class AudioDecoder {


		public:

			int byteDepth;
			int channels;
			int sampleRate;

			virtual bool Open (Resource* resource);
			virtual size_t Decode (void* ptr, size_t frames, int byteDepth);
			virtual bool Rewind ();
			virtual bool Seek (int64_t frame);
			virtual bool CanSeek ();
			virtual int64_t Tell ();
			virtual int64_t Total ();


	};


}
