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


	size_t OggDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		if (!handle) {

			return 0;

		}

		size_t size = 0;
		long result;
		size_t bytesWanted = frames * channels * 2;

		while (true) {

			#ifdef HXCPP_BIG_ENDIAN
			result = ov_read ((OggVorbis_File*)handle, (char*)ptr + size, bytesWanted - size, 1, 2, 1, nullptr);
			#else
			result = ov_read ((OggVorbis_File*)handle, (char*)ptr + size, bytesWanted - size, 0, 2, 1, nullptr);
			#endif

			if (result == OV_HOLE) {

				continue;

			}

			if (result <= 0) {

				break;

			}

			size += result;

			if (size >= bytesWanted) {

				break;

			}

		}

		return size / 2 / channels;

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
