#ifndef LIME_MEDIA_CODECS_WAV_DR_WAV_H
#define LIME_MEDIA_CODECS_WAV_DR_WAV_H


#include <utils/Bytes.h>
#include <dr_wav.h>


namespace lime {


	class DrWav {


		public:

			static drwav* FromBytes (Bytes* bytes);
			static drwav* FromFile (const char* path);
			static void Close (drwav* pWav);


	};


}



#endif