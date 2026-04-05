#include <media/codecs/mp3/DrMp3.h>
#include <system/System.h>


namespace lime {


	static size_t DrMp3_FileRead (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return lime::fread (pBufferOut, 1, bytesToRead, (FILE_HANDLE*)pUserData);

	}


	static drmp3_bool32 DrMp3_FileSeek (void* pUserData, int offset, drmp3_seek_origin origin) {

		int whence = 0;
		if (origin == DRMP3_SEEK_CUR) {
			whence = 1;
		}
		else if (origin == DRMP3_SEEK_END) {
			whence = 2;
		}

		return lime::fseek ((FILE_HANDLE*)pUserData, offset, whence) == 0;

	}


	static drmp3_bool32 DrMp3_FileTell (void* pUserData, drmp3_int64* pCursor) {

		*pCursor = lime::ftell ((FILE_HANDLE*)pUserData);
		return DRMP3_TRUE;

	}


	drmp3* DrMp3::FromBytes (Bytes* bytes) {

		if (!bytes) return 0;

		drmp3* pMp3 = new drmp3;
		memset (pMp3, 0, sizeof (DrMp3));

		if (drmp3_init_memory (pMp3, bytes->b, bytes->length, NULL) == DRMP3_FALSE) {

			delete pMp3;
			return 0;

		}

		return pMp3;

	}


	drmp3* DrMp3::FromFile (const char* path) {

		if (!path) return 0;

		FILE_HANDLE *file = lime::fopen (path, "rb");
		if (!file) return 0;

		drmp3* pMp3 = new drmp3;
		memset (pMp3, 0, sizeof (drmp3));

		if (drmp3_init (pMp3, DrMp3_FileRead, DrMp3_FileSeek, DrMp3_FileTell, NULL, file, NULL) == DRMP3_FALSE) {

			delete pMp3;
			lime::fclose (file);
			return 0;

		}

		return pMp3;

	}


	void DrMp3::Close (drmp3* pMp3) {

		if (!pMp3) return;

		if (pMp3->onRead == DrMp3_FileRead) {

			FILE_HANDLE *file = (FILE_HANDLE*)pMp3->pUserData;
			if (file) lime::fclose (file);

		}

		//delete pMp3->pUserData;
		drmp3_uninit (pMp3);

	}


}