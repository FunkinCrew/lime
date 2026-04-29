#include <media/codecs/vorbis/VorbisFile.h>
#include <utils/File.h>


namespace lime {


	static size_t VorbisFile_Read (void* dest, size_t eltSize, size_t nelts, File* file) {

		return file->Read (dest, eltSize * nelts) / eltSize;

	}


	static int VorbisFile_Seek (File* file, ogg_int64_t offset, int whence) {

		return static_cast<int> (file->Seek (offset, whence));

	}


	static int VorbisFile_Close (File* file) {

		return (int)file->Close ();

	}


	static long VorbisFile_Tell (File* file) {

		return static_cast<long> (file->Tell ());

	}


	static ov_callbacks VORBIS_FILE_CALLBACKS = {

		(size_t (*)(void *, size_t, size_t, void *)) VorbisFile_Read,
		(int (*)(void *, ogg_int64_t, int)) VorbisFile_Seek,
		(int (*)(void *)) VorbisFile_Close,
		(long (*)(void *)) VorbisFile_Tell

	};


	OggVorbis_File* VorbisFile::FromBytes (Bytes* bytes) {

		File* file = new File (bytes);

		if (!file->handle) {

			return 0;

		}

		OggVorbis_File* vorbisFile = new OggVorbis_File;
		memset (vorbisFile, 0, sizeof (OggVorbis_File));

		if (ov_open_callbacks (file, vorbisFile, NULL, 0, VORBIS_FILE_CALLBACKS) != 0) {

			file->Close();
			delete vorbisFile;

			return 0;

		}

		return vorbisFile;

	}


	OggVorbis_File* VorbisFile::FromFile (const char* path) {

		File* file = new File (path, "rb");

		if (!file->handle) {

			return 0;

		}

		OggVorbis_File* vorbisFile = new OggVorbis_File;
		memset (vorbisFile, 0, sizeof (OggVorbis_File));

		if (ov_open_callbacks (file, vorbisFile, NULL, 0, VORBIS_FILE_CALLBACKS) != 0) {

			file->Close();
			delete vorbisFile;

			return 0;

		}

		return vorbisFile;

	}


}