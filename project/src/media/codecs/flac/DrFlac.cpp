#include <media/codecs/flac/DrFlac.h>
#include <system/System.h>


namespace lime {


	static size_t DrFlac_FileRead (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return lime::fread (pBufferOut, 1, bytesToRead, (FILE_HANDLE*)pUserData);

	}


	static drflac_bool32 DrFlac_FileSeek (void* pUserData, int offset, drflac_seek_origin origin) {

		int whence = 0;
		if (origin == DRFLAC_SEEK_CUR) {
			whence = 1;
		}
		else if (origin == DRFLAC_SEEK_END) {
			whence = 2;
		}

		return lime::fseek ((FILE_HANDLE*)pUserData, offset, whence) == 0;

	}


	static drflac_bool32 DrFlac_FileTell (void* pUserData, drflac_int64* pCursor) {

		*pCursor = lime::ftell ((FILE_HANDLE*)pUserData);
		return DRFLAC_TRUE;

	}


	drflac* DrFlac::FromBytes (Bytes* bytes) {

		if (!bytes) return 0;

		drflac* pFlac = drflac_open_memory (bytes->b, bytes->length, NULL);
		if (!pFlac) {

			return 0;

		}

		return pFlac;

	}


	drflac* DrFlac::FromFile (const char* path) {

		if (!path) return 0;

		FILE_HANDLE *file = lime::fopen (path, "rb");
		if (!file) return 0;

		drflac* pFlac = drflac_open (DrFlac_FileRead, DrFlac_FileSeek, DrFlac_FileTell, file, NULL);
		if (!pFlac) {

			lime::fclose (file);
			return 0;

		}

		return pFlac;

	}


	void DrFlac::Close (drflac* pFlac) {

		if (!pFlac) return;

		if (pFlac->bs.onRead == DrFlac_FileRead) {

			FILE_HANDLE *file = (FILE_HANDLE*)pFlac->bs.pUserData;
			if (file) lime::fclose (file);

		}

		//delete pFlac->bs.pUserData;
		drflac_close (pFlac);

	}


}