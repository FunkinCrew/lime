#pragma once


#include <media/AudioDecoder.h>


namespace lime {


	class VorbisDecoder : public AudioDecoder {


		public:

			~VorbisDecoder ();

			bool Open (Resource* resource) override;
			size_t Decode (void* ptr, size_t frames, int byteDepth) override;
			bool Rewind () override;
			bool Seek (int64_t frame) override;
			bool CanSeek () override;
			int64_t Tell () override;
			int64_t Total () override;


		private:

			void* handle;


	};


}
