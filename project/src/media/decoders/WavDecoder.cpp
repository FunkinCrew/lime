#include <media/decoders/WavDecoder.h>

#include <utils/File.h>


namespace lime {


	WavDecoder::~WavDecoder () {

	}


	bool WavDecoder::Open (Resource* resource) {

		return false;

	}


	size_t WavDecoder::Decode (void* ptr, size_t frames, AudioFormat format) {

		return 0;

	}


	bool WavDecoder::Rewind () {

		return false;

	}


	bool WavDecoder::Seek (int64_t frame) {

		return false;

	}


	bool WavDecoder::CanSeek () {

		return false;

	}


	int64_t WavDecoder::Tell () {

		return 0;

	}


	int64_t WavDecoder::Total () {

		return 0;

	}


}
