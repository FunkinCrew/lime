#pragma once


#include <system/CFFI.h>
#include <utils/ArrayBufferView.h>


namespace lime {


	struct AudioBuffer {

		hl_type* t;
		int bitsPerSample;
		int channels;
		ArrayBufferView* data;
		int dataFormat;
		int sampleRate;

		AudioBuffer (value audioBuffer);
		~AudioBuffer ();
		value Value (value audioBuffer);
		value Value ();

	};


}