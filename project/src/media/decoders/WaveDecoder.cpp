#include <media/decoders/WaveDecider.h>
#include <utils/File.h>


namespace lime {


	WaveDecoder::~WaveDecoder () {



	}


	bool WaveDecoder::Open (Resource* resource) {

		File* file = resource->path ? new File (resource->path, "rb") : new File (resource->data);

		if (!file->handle) {

			return false;

		}

		return false;		

	}


	size_t WaveDecoder::Decode (void* ptr, size_t frames, int byteDepth) {

		if (!handle) {

			return 0;

		}

		return 0;

	}


	bool WaveDecoder::Rewind () {

		return false;

	}


	bool WaveDecoder::Seek (int64_t frame) {

		return false;

	}


	bool WaveDecoder::CanSeek () {

		return false;

	}


	int64_t WaveDecoder::Tell () {

		return 0;

	}


	int64_t WaveDecoder::Total () {

		return 0;

	}


}
