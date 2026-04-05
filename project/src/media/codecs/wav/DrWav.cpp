#include <media/codecs/wav/DrWav.h>
#include <system/System.h>


namespace lime {


	static size_t DrWav_FileRead (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return lime::fread (pBufferOut, 1, bytesToRead, (FILE_HANDLE*)pUserData);

	}


	static drwav_bool32 DrWav_FileSeek (void* pUserData, int offset, drwav_seek_origin origin) {

		int whence = 0;
		if (origin == DRWAV_SEEK_CUR) {
			whence = 1;
		}
		else if (origin == DRWAV_SEEK_END) {
			whence = 2;
		}

		return lime::fseek ((FILE_HANDLE*)pUserData, offset, whence) == 0;

	}


	static drwav_bool32 DrWav_FileTell (void* pUserData, drwav_int64* pCursor) {

		*pCursor = lime::ftell ((FILE_HANDLE*)pUserData);
		return DRWAV_TRUE;

	}


	drwav* DrWav::FromBytes (Bytes* bytes) {

		if (!bytes) return 0;

		drwav* pWav = new drwav;
		memset (pWav, 0, sizeof (DrWav));

		if (drwav_init_memory (pWav, bytes->b, bytes->length, NULL) == DRWAV_FALSE) {

			delete pWav;
			return 0;

		}

		return pWav;

	}


	drwav* DrWav::FromFile (const char* path) {

		if (!path) return 0;

		FILE_HANDLE *file = lime::fopen (path, "rb");
		if (!file) return 0;

		drwav* pWav = new drwav;
		memset (pWav, 0, sizeof (drwav));

		if (drwav_init (pWav, DrWav_FileRead, DrWav_FileSeek, DrWav_FileTell, file, NULL) == DRWAV_FALSE) {

			delete pWav;
			lime::fclose (file);
			return 0;

		}

		return pWav;

	}


	void DrWav::Close (drwav* pWav) {

		if (!pWav) return;

		if (pWav->onRead == DrWav_FileRead) {

			FILE_HANDLE *file = (FILE_HANDLE*)pWav->pUserData;
			if (file) lime::fclose (file);

		}

		//delete pWav->pUserData;
		drwav_uninit (pWav);

	}


}