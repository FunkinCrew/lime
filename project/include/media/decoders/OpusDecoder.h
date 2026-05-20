#pragma once


#include <media/AudioDecoder.h>


namespace lime {


	class OpusDecoder : public AudioDecoder {


		public:

			~OpusDecoder ();

			bool Open (Resource* resource);
			size_t Decode (void* ptr, size_t frames, AudioFormat format);
			bool Rewind ();
			bool Seek (int64_t frame);
			bool CanSeek ();
			int64_t Tell ();
			int64_t Total ();


		private:

			void* handle;


	};


}
