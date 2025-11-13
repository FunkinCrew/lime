#include "media/SDLSound.h"
#include "SDL_sound.h"
#include <system/System.h>

namespace lime {

    bool SDLSound::Decode (Resource* resource, AudioBuffer* audioBuffer) {
        Sound_AudioInfo want = {};
		// Lets force 16 bit system endian since thats what we expect and mojo doesn't support AL extensions for 32 bit
        want.format   = AUDIO_S16SYS;
		// Just set it to 0 and let the decoder choose
        want.channels = 0;              
        want.rate     = 0;

        Sound_Sample* sample = nullptr;

        if (resource->path) {
            sample = Sound_NewSampleFromFile(resource->path, &want, 64 * 1024);
        } else {
            const Uint8* bytes = reinterpret_cast<const Uint8*>(resource->data->b);
            const Uint32 len   = static_cast<Uint32>(resource->data->length);
            sample = Sound_NewSampleFromMem(bytes, len, nullptr, &want, 64 * 1024);
        }

        if (!sample) {
            printf("SDL_sound: %s\n", Sound_GetError());
            return false;
        }

        const Sound_AudioInfo& got = sample->actual;

        if (got.channels < 1 || got.rate <= 0) {
            printf("SDL_sound: unsupported stream format (channels=%d, rate=%d)\n", got.channels, got.rate);
            Sound_FreeSample(sample);
            return false;
        }

        audioBuffer->sampleRate    = (int)got.rate;
        audioBuffer->channels      = (int)got.channels;
		//For some reason it still reports the original format so we force 16
        audioBuffer->bitsPerSample = 16;//(got.format == AUDIO_F32LSB || got.format == AUDIO_F32MSB) ? 32 : (got.format == AUDIO_U8  || got.format == AUDIO_S8) ? 8  : 16;

        audioBuffer->data->Resize(0);
        Uint32 total = 0;

        for (;;) {
            if (sample->flags & SOUND_SAMPLEFLAG_ERROR) {
                printf("SDL_sound decode error: %s\n", Sound_GetError());
                Sound_FreeSample(sample);
                return false;
            }

            const long decoded = Sound_Decode(sample);
            if (decoded <= 0) {
                if (sample->flags & SOUND_SAMPLEFLAG_EOF) break;
                break;
            }

            const Uint32 chunk = (Uint32)decoded;
            audioBuffer->data->Resize(total + chunk);
            unsigned char* out = audioBuffer->data->buffer->b;
            memcpy(out + total, sample->buffer, chunk);
            total += chunk;
        }

        Sound_FreeSample(sample);
        return true;
    }

} 
