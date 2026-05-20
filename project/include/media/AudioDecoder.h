#pragma once


#include <media/AudioBuffer.h>
#include <utils/Resource.h>


namespace lime {


	class AudioDecoder {


		public:

			int byteDepth = 0;
			int channels = 0;
			int sampleRate = 0;

			bool Load (Resource* resource, AudioBuffer* audioBuffer) {

				if (!Open(resource)) {

					return false;

				}

				audioBuffer->channels = channels;
				audioBuffer->sampleRate = sampleRate;
				audioBuffer->bitsPerSample = 16;
				audioBuffer->dataFormat = 1;

				int totalFrames = Total();

				int totalBytes = totalFrames * channels * byteDepth;

				audioBuffer->data->Resize(totalBytes);

				size_t framesDecoded = Decode(audioBuffer->data->buffer->b, totalFrames, byteDepth);

				int finalBytes = framesDecoded * channels * byteDepth;

				if (finalBytes != totalBytes) {

					audioBuffer->data->Resize(finalBytes);

				}

				return true;

			}

			virtual ~AudioDecoder() = default;

			virtual bool Open (Resource* resource) = 0;
			virtual size_t Decode (void* ptr, size_t frames, int byteDepth) = 0;
			virtual bool Rewind () = 0;
			virtual bool Seek (int64_t frame) = 0;
			virtual bool CanSeek () = 0;
			virtual int64_t Tell () = 0;
			virtual int64_t Total () = 0;


	};


}
