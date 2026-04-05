#ifndef LIME_MEDIA_CODECS_FLAC_DR_FLAC_H
#define LIME_MEDIA_CODECS_FLAC_DR_FLAC_H


#include <utils/Bytes.h>
#include <dr_flac.h>


namespace lime {


	class DrFlac {


		public:

			static drflac* FromBytes (Bytes* bytes);
			static drflac* FromFile (const char* path);
			static void Close (drflac* pFlac);


	};


}



#endif