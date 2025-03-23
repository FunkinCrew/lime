#include "media/decoders/SDL_sound.h"
#include <system/System.h>


namespace lime {

	Sound_Sample* SDL_sound::FromBytes (Bytes* bytes) {
		Sound_Sample* sample = NULL;

		if (bytes) {

			// FIXME?: WAV files require specifying ext to work due to a bug in SDL_sound
			sample = Sound_NewSampleFromMem(bytes->b, bytes->length, "wav", NULL, 65536);

		}

		return sample;
	}

	Sound_Sample* SDL_sound::FromFile (const char* path) {
		Sound_Sample* sample = NULL;

		if (path) {

			sample = Sound_NewSampleFromFile(path, NULL, 65536);

		}

		return sample;
	}


	bool SDL_sound::Decode (Resource *resource, AudioBuffer *audioBuffer) {
		Sound_Sample* sample = NULL;

		if (resource->path) {

			sample = SDL_sound::FromFile(resource->path);

		} else {

			sample = SDL_sound::FromBytes(resource->data);

		}

		if (!sample) {

			LOG_SOUND("%s\n", Sound_GetError());
			return false;

		}

		audioBuffer->dataFormat = 1;

		switch (sample->desired.format)
		{
			case AUDIO_U8:
			case AUDIO_S8:
				audioBuffer->bitsPerSample = 8;
				break;

			case AUDIO_F32LSB:
			case AUDIO_F32MSB:
				audioBuffer->bitsPerSample = 32;
				audioBuffer->dataFormat = 3;
				break;
			case AUDIO_S32LSB:
			case AUDIO_S32MSB:
				// No support for signed 32bit int audio formats (requires OpenAL 1.23 minimum)
				audioBuffer->dataFormat = 0;
				Sound_FreeSample(sample);
				return false;

			case AUDIO_U16LSB:
			case AUDIO_S16LSB:
			case AUDIO_U16MSB:
			case AUDIO_S16MSB:
			default:
				audioBuffer->bitsPerSample = 16;
				break;
		}

		audioBuffer->sampleRate = (int)sample->desired.rate;
		audioBuffer->channels = (int)sample->desired.channels;

		Sint32 duration = Sound_GetDuration(sample);
		if (duration == -1)
		{
			LOG_SOUND("SDL_sound: Error getting duration: %s\n", Sound_GetError());
			Sound_FreeSample(sample);
			return false;
		}

		Uint8* bytes = NULL;
		Uint32 bytesWritten = 0;
		// AudioBuffer->Resize is a bit expensive so we first allocate an estimate based on the duration
		Uint32 estimatedSize = (Uint32)((duration / 1000.) * audioBuffer->sampleRate * audioBuffer->channels * (audioBuffer->bitsPerSample / 8));
		audioBuffer->data->Resize(estimatedSize);

		do
		{
			Uint32 decodedBytes = Sound_Decode(sample);

			if ((sample->flags & SOUND_SAMPLEFLAG_ERROR))
			{
				LOG_SOUND("SDL_sound Error: %s\n", Sound_GetError());
				audioBuffer->data->Resize(0);
				bytesWritten = 0;
				break;
			}

			if (decodedBytes > 0)
			{
				if (bytesWritten + decodedBytes > audioBuffer->data->length)
				{
					audioBuffer->data->Resize(bytesWritten + decodedBytes);
				}

				bytes = audioBuffer->data->buffer->b;
				memcpy(bytes + bytesWritten, sample->buffer, decodedBytes);

				bytesWritten += decodedBytes;
			}

		} while ((sample->flags & SOUND_SAMPLEFLAG_EOF) == 0);

		// Prevent garbage audio
		if (bytesWritten < estimatedSize)
		{
			audioBuffer->data->Resize(bytesWritten);
		}

		Sound_FreeSample(sample);
		return bytesWritten > 0;
	}
}