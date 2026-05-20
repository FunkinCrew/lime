#include <media/decoders/MP3Decoder.h>

#include <utils/File.h>


namespace lime {


	MP3Decoder::~MP3Decoder () {

	}


	bool MP3Decoder::Open (Resource* resource) {

		return false;

	}


	size_t MP3Decoder::Decode (void* ptr, size_t frames, int byteDepth) {

		return 0;

	}


	bool MP3Decoder::Rewind () {

		return false;

	}


	bool MP3Decoder::Seek (int64_t frame) {

		return false;

	}


	bool MP3Decoder::CanSeek () {

		return false;

	}


	int64_t MP3Decoder::Tell () {

		return 0;

	}


	int64_t MP3Decoder::Total () {

		return 0;

	}


}
