#include <media/decoders/OpusDecoder.h>

#include <utils/File.h>
#include <opusfile.h>

namespace lime {


	static int OpusFile_Read (File* file, void* dest, int bytesToRead) {

		return (int)file->Read (dest, bytesToRead);

	}


	static int OpusFile_Seek (File* file, opus_int64 offset, int whence) {

		return file->Seek (offset, whence) < 0 ? -1 : 0;

	}


	static int OpusFile_Close (File* file) {

		int result = (int)file->Close ();

		delete file;

		return result;

	}


	static opus_int64 OpusFile_Tell (File* file) {

		return (opus_int64)file->Tell ();

	}


	static OpusFileCallbacks OPUSFILE_CALLBACKS = {

		(int (*)(void *, unsigned char *, int)) OpusFile_Read,
		(int (*)(void *, opus_int64, int)) OpusFile_Seek,
		(opus_int64 (*)(void *)) OpusFile_Tell,
		(int (*)(void *)) OpusFile_Close

	};


	OpusDecoder::~OpusDecoder () {

		if (handle) {

			OggOpusFile* opusFile = (OggOpusFile*)handle;

			op_free (opusFile);

			handle = NULL;

		}

	}


	bool OpusDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File(resource->path, "rb") : new File(resource->data);

		if (!file->handle) {

			delete file;

			return false;

		}

		OggOpusFile* opusFile = op_open_callbacks (file, &OPUSFILE_CALLBACKS, NULL, 0, NULL);

		if (!opusFile) {

			file->Close ();

			delete file;

			return false;

		}

		channels = op_channel_count (opusFile, -1);
		sampleRate = 48000;
		handle = (void*)opusFile;

		return true;

	}


	size_t OpusDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		if (!handle) {

			return 0;

		}

		int totalSamples = frames * channels;
		int16_t* out = (int16_t*)ptr;
		int samplesRead = 0;

		while (samplesRead < totalSamples) {

			int result = op_read ((OggOpusFile*)handle, out + samplesRead, totalSamples - samplesRead, NULL);

			if (result <= 0) {

				break;

			}

			samplesRead += result * channels;

		}

		return samplesRead / channels;

	}


	bool OpusDecoder::Rewind () {

		return op_pcm_seek ((OggOpusFile*)handle, 0) == 0;

	}


	bool OpusDecoder::Seek (int64_t frame) {

		return op_pcm_seek ((OggOpusFile*)handle, frame) == 0;

	}


	bool OpusDecoder::CanSeek () {

		return op_seekable ((OggOpusFile*)handle) != 0;

	}


	int64_t OpusDecoder::Tell () {

		return op_pcm_tell ((OggOpusFile*)handle);

	}


	int64_t OpusDecoder::Total () {

		return op_pcm_total ((OggOpusFile*)handle, -1);

	}


}
