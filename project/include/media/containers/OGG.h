#pragma once


#include <media/AudioBuffer.h>
#include <utils/Resource.h>


namespace lime {


	class OGG {


		public:

			static bool Decode (Resource *resource, AudioBuffer *audioBuffer);


	};


}