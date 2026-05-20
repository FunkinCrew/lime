#include <media/decoders/FlacDecoder.h>

#include <utils/File.h>


namespace lime {


	FlacDecoder::~FlacDecoder () {

	}


	bool FlacDecoder::Open (Resource* resource) {

		return false;

	}


	size_t FlacDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		return 0;

	}


	bool FlacDecoder::Rewind () {

		return false;

	}


	bool FlacDecoder::Seek (int64_t frame) {

		return false;

	}


	bool FlacDecoder::CanSeek () {

		return false;

	}


	int64_t FlacDecoder::Tell () {

		return 0;

	}


	int64_t FlacDecoder::Total () {

		return 0;

	}


}
