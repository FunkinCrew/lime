#include <media/decoders/FlacDecoder.h>

#include <utils/File.h>

#include <dr_flac.h>


namespace lime {


	static size_t FlacFile_Read (void* pUserData, void* pBufferOut, size_t bytesToRead) {

		return ((File*) pUserData)->Read (pBufferOut, bytesToRead);

	}


	static drflac_bool32 FlacFile_Seek (void* pUserData, int offset, drflac_seek_origin origin) {

		switch (origin) {

			case DRFLAC_SEEK_SET:
				return ((File*) pUserData)->Seek (offset, SEEK_SET) ? DRFLAC_TRUE : DRFLAC_FALSE;

			case DRFLAC_SEEK_CUR:
				return ((File*) pUserData)->Seek (offset, SEEK_CUR) ? DRFLAC_TRUE : DRFLAC_FALSE;

			case DRFLAC_SEEK_END:
				return ((File*) pUserData)->Seek (offset, SEEK_END) ? DRFLAC_TRUE : DRFLAC_FALSE;

		}

		return DRFLAC_FALSE;

	}


	static drflac_bool32 FlacFile_Tell (void* pUserData, drflac_int64* pCursor) {

		(*pCursor) = ((File*) pUserData)->Tell ();

		return DRFLAC_TRUE;

	}


	FlacDecoder::~FlacDecoder () {

		if (handle) {

			drflac* flac = (drflac*) handle;

			if (flac->bs.onRead == FlacFile_Read) {

				File* file = (File*) flac->bs.pUserData;

				file->Close ();

				delete file;

			}

			drflac_close (flac);

		}

	}


	bool FlacDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			delete file;

			return false;

		}

		drflac* flacFile = drflac_open (FlacFile_Read, FlacFile_Seek, FlacFile_Tell, file, NULL);

		if (!flacFile) {

			file->Close ();

			delete file;

			return false;

		}

		channels = flacFile->channels;
		sampleRate = flacFile->sampleRate;
		handle = (void*) flacFile;

		return true;

	}


	size_t FlacDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		if (format == AudioFormat::S16) {

			return drflac_read_pcm_frames_s16 ((drflac*) handle, frames, (drflac_int16*) ptr);

		} else if (format == AudioFormat::F32) {

			return drflac_read_pcm_frames_f32 ((drflac*) handle, frames, (float*) ptr);

		}

		return 0;

	}


	bool FlacDecoder::Rewind () {

		return drflac_seek_to_pcm_frame ((drflac*) handle, 0) == DRFLAC_TRUE;

	}


	bool FlacDecoder::Seek (int64_t frame) {

		return drflac_seek_to_pcm_frame ((drflac*) handle, frame) == DRFLAC_TRUE;

	}


	bool FlacDecoder::CanSeek () {

		return handle != nullptr;

	}


	int64_t FlacDecoder::Tell () {

		return ((drflac*) handle)->currentPCMFrame;

	}


	int64_t FlacDecoder::Total () {

		return ((drflac*) handle)->totalPCMFrameCount;

	}


}
