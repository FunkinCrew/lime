#include <media/AudioBuffer.h>


namespace lime {


	AudioBuffer::AudioBuffer (value audioBuffer) {

		if (!val_is_null (audioBuffer)) {

			bitsPerSample = val_int (val_field (audioBuffer, val_id ("bitsPerSample")));
			channels = val_int (val_field (audioBuffer, val_id ("channels")));
			data = new ArrayBufferView (val_field (audioBuffer, val_id ("data")));
			dataFormat = val_int (val_field (audioBuffer, val_id ("dataFormat")));
			sampleRate = val_int (val_field (audioBuffer, val_id ("sampleRate")));

		} else {

			bitsPerSample = 0;
			channels = 0;
			// data = new ArrayBufferView ();
			dataFormat = 0;
			sampleRate = 0;

		}

		// _value = audioBuffer;

	}


	AudioBuffer::~AudioBuffer () {

		if (data) {

			delete data;

		}

	}


	value AudioBuffer::Value () {

		return Value (alloc_empty_object ());

	}


	value AudioBuffer::Value (value audioBuffer) {

		alloc_field (audioBuffer, val_id ("bitsPerSample"), alloc_int (bitsPerSample));
		alloc_field (audioBuffer, val_id ("channels"), alloc_int (channels));
		alloc_field (audioBuffer, val_id ("data"), data ? data->Value (val_field (audioBuffer, val_id ("data"))) : alloc_null ());
		alloc_field (audioBuffer, val_id ("dataFormat"), alloc_int (dataFormat));
		alloc_field (audioBuffer, val_id ("sampleRate"), alloc_int (sampleRate));

		return audioBuffer;

	}


}