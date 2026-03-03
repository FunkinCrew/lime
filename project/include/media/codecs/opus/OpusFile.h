#ifndef LIME_MEDIA_CODECS_OPUS_OPUS_FILE_H
#define LIME_MEDIA_CODECS_OPUS_OPUS_FILE_H


#include <utils/Bytes.h>
#include <opusfile.h>


namespace lime {


	class OpusFile {


		public:


			static OggOpusFile* FromBytes (Bytes* bytes);
			static OggOpusFile* FromFile (const char* path);


	};


}


#endif