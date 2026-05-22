#include <media/decoders/WavDecoder.h>

#include <utils/File.h>

#include <dr_wav.h>


namespace lime {


	static size_t WavFile_Read (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return ((File*) pUserData)->Read (pBufferOut, bytesToRead);

	}


	static drwav_bool32 WavFile_Seek (void* pUserData, int offset, drwav_seek_origin origin) {

		switch (origin) {

			case DRWAV_SEEK_SET:
				return ((File*) pUserData)->Seek (offset, SEEK_SET) < 0 ? DRWAV_FALSE : DRWAV_TRUE;

			case DRWAV_SEEK_CUR:
				return ((File*) pUserData)->Seek (offset, SEEK_CUR) < 0 ? DRWAV_FALSE : DRWAV_TRUE;

			case DRWAV_SEEK_END:
				return ((File*) pUserData)->Seek (offset, SEEK_END) < 0 ? DRWAV_FALSE : DRWAV_TRUE;

		}

		return DRWAV_FALSE;

	}


	static drwav_bool32 WavFile_Tell (void* pUserData, drwav_int64* pCursor) {

		(*pCursor) = ((File*) pUserData)->Tell ();

		return DRWAV_TRUE;

	}


	WavDecoder::~WavDecoder () {

		if (handle) {

			drwav* wav = (drwav*) handle;

			File* file = (File*) wav->pUserData;

			if (file) {

				file->Close ();

				delete file;

			}

			drwav_uninit (wav);

			delete wav;

		}

	}


	bool WavDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			delete file;

			return false;

		}

		drwav* wavFile = new drwav;

		if (drwav_init (wavFile, WavFile_Read, WavFile_Seek, WavFile_Tell, file, NULL) != DRWAV_TRUE) {

			file->Close ();

			delete file;

			delete wavFile;

			return false;

		}

		channels = wavFile->channels;
		sampleRate = wavFile->sampleRate;
		handle = (void*) wavFile;

		return true;

	}


	size_t WavDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		if (format == AudioFormat::S16) {

			return drwav_read_pcm_frames_s16 ((drwav*) handle, frames, (drwav_int16*) ptr);

		} else if (format == AudioFormat::F32) {

			return drwav_read_pcm_frames_f32 ((drwav*) handle, frames, (float*) ptr);

		}

		return 0;

	}


	bool WavDecoder::Rewind () {

		return drwav_seek_to_pcm_frame ((drwav*) handle, 0) == DRWAV_TRUE;

	}


	bool WavDecoder::Seek (int64_t frame) {

		return drwav_seek_to_pcm_frame ((drwav*) handle, frame) == DRWAV_TRUE;

	}


	bool WavDecoder::CanSeek () {

		return handle != nullptr;

	}


	int64_t WavDecoder::Tell () {

		return ((drwav*) handle)->readCursorInPCMFrames;

	}


	int64_t WavDecoder::Total () {

		return ((drwav*) handle)->totalPCMFrameCount;

	}


}
