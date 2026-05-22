#include <media/decoders/OggDecoder.h>

#include <utils/File.h>

#include <vorbis/vorbisfile.h>


namespace lime {


	static size_t VorbisFile_Read (void* dest, size_t eltSize, size_t nelts, File* file) {

		return file->Read (dest, eltSize * nelts) / eltSize;

	}


	static int VorbisFile_Seek (File* file, ogg_int64_t offset, int whence) {

		return file->Seek (offset, whence) < 0 ? -1 : 0;

	}


	static int VorbisFile_Close (File* file) {

		int result = (int)file->Close ();

		delete file;

		return result;

	}


	static long VorbisFile_Tell (File* file) {

		return static_cast<long> (file->Tell ());

	}


	static ov_callbacks VORBISFILE_CALLBACKS = {

		(size_t (*)(void *, size_t, size_t, void *)) VorbisFile_Read,
		(int (*)(void *, ogg_int64_t, int)) VorbisFile_Seek,
		(int (*)(void *)) VorbisFile_Close,
		(long (*)(void *)) VorbisFile_Tell

	};


	OggDecoder::~OggDecoder () {

		if (handle) {

			OggVorbis_File* vorbisFile = (OggVorbis_File*)handle;

			ov_clear (vorbisFile);

			delete vorbisFile;

		}

	}


	bool OggDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			delete file;

			return false;

		}

		OggVorbis_File* vorbisFile = new OggVorbis_File ();

		if (ov_open_callbacks (file, vorbisFile, NULL, 0, VORBISFILE_CALLBACKS) != 0) {

			ov_clear (vorbisFile);

			delete vorbisFile;

			return false;

		}

		vorbis_info* vorbisInfo = ov_info (vorbisFile, -1);
		channels = vorbisInfo->channels;
		sampleRate = (int)vorbisInfo->rate;
		handle = (void*)vorbisFile;

		return true;

	}


	size_t OggDecoder::Decode(void* ptr, size_t frames, AudioFormat format) {

		if (format == AudioFormat::S16) {

			size_t bytesWanted = frames * channels * 2;
			size_t bytesRead = 0;

			while (bytesRead < bytesWanted) {

				#ifdef HXCPP_BIG_ENDIAN
				long result = ov_read((OggVorbis_File*)handle, (char*)ptr + bytesRead, bytesWanted - bytesRead, 1, 2, 1, nullptr);
				#else
				long result = ov_read((OggVorbis_File*)handle, (char*)ptr + bytesRead, bytesWanted - bytesRead, 0, 2, 1, nullptr);
				#endif

				if (result == OV_HOLE) {

					continue;

				}

				if (result <= 0) {

					break;

				}

				bytesRead += result;

			}

			return bytesRead / (channels * 2);

		} else if (format == AudioFormat::F32) {

			size_t framesReadTotal = 0;
			float **pcm_channels = nullptr;
			float* out = (float*)ptr;

			while (framesReadTotal < frames) {

				long result = ov_read_float((OggVorbis_File*)handle, &pcm_channels, frames - framesReadTotal, nullptr);

				if (result == OV_HOLE) {

					continue;

				}

				if (result <= 0) {

					break;

				}

				for (long i = 0; i < result; i++) {

					size_t base = (framesReadTotal + i) * channels;

					for (int c = 0; c < channels; c++) {

						out[base + c] = pcm_channels[c][i];

					}

				}

				framesReadTotal += result;

			}

			return framesReadTotal;

		}

		return 0;

	}


	bool OggDecoder::Rewind () {

		return ov_raw_seek ((OggVorbis_File*)handle, 0) == 0;

	}


	bool OggDecoder::Seek (int64_t frame) {

		return ov_pcm_seek ((OggVorbis_File*)handle, frame) == 0;

	}


	bool OggDecoder::CanSeek () {

		return ov_seekable ((OggVorbis_File*)handle) != 0;

	}


	int64_t OggDecoder::Tell () {

		return ov_pcm_tell ((OggVorbis_File*)handle);

	}


	int64_t OggDecoder::Total () {

		return ov_pcm_total ((OggVorbis_File*)handle, -1);

	}


}
