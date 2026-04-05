#pragma once


#include <utils/Bytes.h>
#include <vorbis/vorbisfile.h>


namespace lime {


	class VorbisFile {


		public:

			static OggVorbis_File* FromBytes (Bytes* bytes);
			static OggVorbis_File* FromFile (const char* path);


	};


}