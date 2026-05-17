#include <media/decoders/VorbisDecider.h>
#include <utils/File.h>
#include <vorbis/vorbisfile.h>


namespace lime {


	static size_t VorbisFile_Read (void* dest, size_t eltSize, size_t nelts, File* file) {

		return file->Read (dest, eltSize * nelts) / eltSize;

	}


	static int VorbisFile_Seek (File* file, ogg_int64_t offset, int whence) {

		return static_cast<int> (file->Seek (offset, whence));

	}


	static int VorbisFile_Close (File* file) {

		return (int)file->Close ();

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


	VorbisDecoder::~VorbisDecoder () {

		if (handle) {

			OggVorbis_File* vorbisFile = (OggVorbis_File*)handle;

			ov_clear (vorbisFile);
			delete vorbisFile;

		}

	}


	bool VorbisDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			return false;

		}

		OggVorbis_File* vorbisFile = new OggVorbis_File;

		if (ov_open_callbacks (file, vorbisFile, NULL, 0, VORBISFILE_CALLBACKS) != 0) {

			file->Close ();
			delete vorbisFile;

			return false;

		}

		vorbis_info* vorbisInfo = ov_info (vorbisFile, -1);
		byteDepth = 2;
		channels = vorbisInfo->channels;
		sampleRate = (int)vorbisInfo->rate;

		handle = (void*)vorbisFile;

		return true;

	}


	size_t VorbisDecoder::Decode (void* ptr, size_t frames, int byteDepth) {

		if (!handle) {

			return 0;

		}

		OggVorbis_File* vorbisFile = (OggVorbis_File*)handle;

		size_t size = 0;
		long result;

		#ifdef HXCPP_BIG_ENDIAN
		#define BUFFER_READ_TYPE 1
		#else
		#define BUFFER_READ_TYPE 0
		#endif

		while (true) {

			result = ov_read (vorbisFile, ptr, frames - size, BUFFER_READ_TYPE, byteDepth, 1, NULL);

			if (result != OV_HOLE) {

				if (result <= OV_EREAD) {

					return 0;

				} else if (result > 0) {

					ptr += result;
					size += result;

				} else {

					break;

				}

			}

		}

		#undef HXCPP_BIG_ENDIAN

		return size / byteDepth / channels;

	}


	bool VorbisDecoder::Rewind () {

		return ov_raw_seek ((OggVorbis_File*)handle, 0) == 0;

	}


	bool VorbisDecoder::Seek (int64_t frame) {

		return ov_pcm_seek ((OggVorbis_File*)handle, frame) == 0;

	}


	bool VorbisDecoder::CanSeek () {

		return (bool)ov_seekable ((OggVorbis_File*)handle);

	}


	int64_t VorbisDecoder::Tell () {

		return ov_pcm_tell ((OggVorbis_File*)handle);

	}


	int64_t VorbisDecoder::Total () {

		return ov_pcm_total ((OggVorbis_File*)handle, -1);

	}


}
