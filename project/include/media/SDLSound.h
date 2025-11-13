#ifndef LIME_MEDIA_DECODERS_SDL_SOUND_H
#define LIME_MEDIA_DECODERS_SDL_SOUND_H


#include <media/AudioBuffer.h>
#include <utils/Resource.h>


namespace lime {


	class SDLSound {


		public:

			static bool Decode (Resource *resource, AudioBuffer *audioBuffer);


	};


}


#endif