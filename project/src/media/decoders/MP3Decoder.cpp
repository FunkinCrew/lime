#include <media/decoders/MP3Decoder.h>

#include <utils/File.h>

#include <dr_mp3.h>


namespace lime {


	static size_t MP3File_Read (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return ((File*) pUserData)->Read (pBufferOut, bytesToRead);

	}


	static drmp3_bool32 MP3File_Seek (void* pUserData, int offset, drmp3_seek_origin origin) {

		switch (origin) {

			case DRMP3_SEEK_SET:
				return ((File*) pUserData)->Seek (offset, SEEK_SET) < 0 ? DRMP3_FALSE : DRMP3_TRUE;

			case DRMP3_SEEK_CUR:
				return ((File*) pUserData)->Seek (offset, SEEK_CUR) < 0 ? DRMP3_FALSE : DRMP3_TRUE;

			case DRMP3_SEEK_END:
				return ((File*) pUserData)->Seek (offset, SEEK_END) < 0 ? DRMP3_FALSE : DRMP3_TRUE;

		}

		return DRMP3_FALSE;

	}


	static drmp3_bool32 MP3File_Tell (void* pUserData, drmp3_int64* pCursor) {

		(*pCursor) = ((File*) pUserData)->Tell ();

		return DRMP3_TRUE;

	}


	MP3Decoder::~MP3Decoder () {

		if (handle) {

			drmp3* mp3 = (drmp3*) handle;

			if (mp3->onRead == MP3File_Read) {

				File* file = (File*) mp3->pUserData;

				file->Close ();

				delete file;

			}

			drmp3_uninit (mp3);

			delete mp3;

		}

	}


	bool MP3Decoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			delete file;

			return false;

		}

		drmp3* mp3File = new drmp3;

		if (drmp3_init (mp3File, MP3File_Read, MP3File_Seek, MP3File_Tell, NULL, file, NULL) != DRMP3_TRUE) {

			file->Close ();

			delete file;

			delete mp3File;

			return false;

		}

		channels = mp3File->channels;
		sampleRate = mp3File->sampleRate;
		handle = (void*) mp3File;

		return true;

	}


	size_t MP3Decoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		if (format == AudioFormat::S16) {

			return drmp3_read_pcm_frames_s16 ((drmp3*) handle, frames, (drmp3_int16*) ptr);

		} else if (format == AudioFormat::F32) {

			return drmp3_read_pcm_frames_f32 ((drmp3*) handle, frames, (float*) ptr);

		}

		return 0;

	}


	bool MP3Decoder::Rewind () {

		return drmp3_seek_to_pcm_frame ((drmp3*) handle, 0) == DRMP3_TRUE;

	}


	bool MP3Decoder::Seek (int64_t frame) {

		return drmp3_seek_to_pcm_frame ((drmp3*) handle, frame) == DRMP3_TRUE;

	}


	bool MP3Decoder::CanSeek () {

		return handle != nullptr;

	}


	int64_t MP3Decoder::Tell () {

		return ((drmp3*) handle)->currentPCMFrame;

	}


	int64_t MP3Decoder::Total () {

		return ((drmp3*) handle)->totalPCMFrameCount;

	}


}
