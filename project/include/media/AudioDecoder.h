#pragma once


#include <media/AudioBuffer.h>
#include <media/AudioFormat.h>

#include <utils/Resource.h>


namespace lime {


	class AudioDecoder {


		public:

			int channels = 0;
			int sampleRate = 0;

			virtual ~AudioDecoder() = default;

			virtual bool Open (Resource* resource) = 0;
			virtual size_t Decode (void* ptr, size_t frames, AudioFormat format) = 0;
			virtual bool Rewind () = 0;
			virtual bool Seek (int64_t frame) = 0;
			virtual bool CanSeek () = 0;
			virtual int64_t Tell () = 0;
			virtual int64_t Total () = 0;


	};


}
