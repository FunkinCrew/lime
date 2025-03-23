#ifndef LIME_MEDIA_DECODERS_SDL_SOUND_H
#define LIME_MEDIA_DECODERS_SDL_SOUND_H


#include <media/AudioBuffer.h>
#include <utils/Resource.h>
#include <SDL_sound.h>


namespace lime {


	class SDL_sound {


		public:

			static Sound_Sample* FromBytes (Bytes* bytes);
			static Sound_Sample* FromFile (const char* path);
			static bool Decode (Resource *resource, AudioBuffer *audioBuffer);


	};


}


#endif