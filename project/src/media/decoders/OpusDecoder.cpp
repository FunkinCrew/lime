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
		format = AudioDataFormat::UNKNOWN;
		handle = (void*)opusFile;

		return true;

	}


	size_t OpusDecoder::Decode (void* ptr, size_t frames, AudioDataFormat format) {

		if (format == AudioDataFormat::S16) {

			int total = frames * channels;
			int read = 0;

			while (read < total) {

				int ret = op_read ((OggOpusFile*) handle, (opus_int16*) ptr + read, total - read, NULL);
				if (ret == OP_HOLE) continue;
				else if (ret <= 0) break;

				read += ret * channels;

			}

			return (size_t)(samplesRead / channels);

		} else if (format == AudioDataFormat::F32) {

			int total = frames * channels;
			int read = 0;

			while (read < total) {

				int ret = op_read_float ((OggOpusFile*) handle, (float*) ptr + read, total - read, NULL);
				if (ret == OP_HOLE) continue;
				else if (ret <= 0) break;

				read += ret * channels;

			}

			return (size_t)(samplesRead / channels);

		}

		return -1;

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
