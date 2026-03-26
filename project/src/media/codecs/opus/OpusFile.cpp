#include <media/codecs/opus/OpusFile.h>
#include <system/System.h>


namespace lime {


	typedef struct {

		unsigned char* data;
		opus_int64 size;
		opus_int64 pos;

	} OpusFile_Buffer;


	static int OpusFile_BufferRead (OpusFile_Buffer* src, void* dest, int bytesToRead) {

		if ((src->pos + bytesToRead) > src->size) {

			bytesToRead = src->size - src->pos;

		}

		if (bytesToRead > 0) {

			memcpy (dest, (src->data + src->pos), bytesToRead);
			src->pos += bytesToRead;
			return bytesToRead;

		}

		return 0;

	}


	static int OpusFile_BufferSeek (OpusFile_Buffer* src, opus_int64 offset, int whence) {

		switch (whence) {

			case SEEK_CUR:

				src->pos += offset;
				break;

			case SEEK_END:

				src->pos = src->size - offset;
				break;

			case SEEK_SET:

				src->pos = offset;
				break;

			default:

				return -1;

		}

		if (src->pos < 0) {

			src->pos = 0;
			return -1;

		}

		if (src->pos > src->size) {

			return -1;

		}

		return 0;

	}


	static opus_int64 OpusFile_BufferTell (OpusFile_Buffer* src) {

		return src->pos;

	}


	static int OpusFile_BufferClose (OpusFile_Buffer* src) {

		delete src;
		return 0;

	}


	static OpusFileCallbacks OPUS_FILE_BUFFER_CALLBACKS = {

		(int (*)(void *, unsigned char *, int)) OpusFile_BufferRead,
		(int (*)(void *, opus_int64, int)) OpusFile_BufferSeek,
		(opus_int64 (*)(void *)) OpusFile_BufferTell,
		(int (*)(void *)) OpusFile_BufferClose

	};


	static int OpusFile_FileRead (FILE_HANDLE* file, void* dest, int bytesToRead) {

		return lime::fread (dest, 1, bytesToRead, file);

	}


	static int OpusFile_FileSeek (FILE_HANDLE* file, opus_int64 offset, int whence) {

		return lime::fseek (file, offset, whence);

	}


	static opus_int64 OpusFile_FileTell (FILE_HANDLE* file) {

		return (opus_int64)lime::ftell (file);

	}


	static int OpusFile_FileClose (FILE_HANDLE* file) {

		return lime::fclose (file);

	}


	static OpusFileCallbacks OPUS_FILE_FILE_CALLBACKS = {

		(int (*)(void *, unsigned char *, int)) OpusFile_FileRead,
		(int (*)(void *, opus_int64, int)) OpusFile_FileSeek,
		(opus_int64 (*)(void *)) OpusFile_FileTell,
		(int (*)(void *)) OpusFile_FileClose

	};


	OggOpusFile* OpusFile::FromBytes (Bytes* bytes) {

		if (!bytes) return 0;

		OpusFile_Buffer* buffer = new OpusFile_Buffer ();
		buffer->data = bytes->b;
		buffer->size = bytes->length;
		buffer->pos = 0;

		OggOpusFile* opusFile = op_open_callbacks (buffer, &OPUS_FILE_BUFFER_CALLBACKS, NULL, 0, NULL);
		if (!opusFile) {

			delete buffer;
			return 0;

		}

		return opusFile;

	}


	OggOpusFile* OpusFile::FromFile (const char* path) {

		if (!path) return 0;

		FILE_HANDLE *file = lime::fopen (path, "rb");
		if (!file) return 0;

		OggOpusFile* opusFile = op_open_callbacks (file, &OPUS_FILE_FILE_CALLBACKS, NULL, 0, NULL);
		if (!opusFile) {

			lime::fclose (file);
			return 0;

		}

		return opusFile;

	}


}