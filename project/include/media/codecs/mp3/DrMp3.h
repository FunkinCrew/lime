#ifndef LIME_MEDIA_CODECS_MP3_DR_MP3_H
#define LIME_MEDIA_CODECS_MP3_DR_MP3_H


#include <utils/Bytes.h>
#include <dr_mp3.h>


namespace lime {


	class DrMp3 {


		public:

			static drmp3* FromBytes (Bytes* bytes);
			static drmp3* FromFile (const char* path);
			static void Close (drmp3* pMp3);


	};


}



#endif