#ifndef LIME_MEDIA_AUDIO_BUFFER_H
#define LIME_MEDIA_AUDIO_BUFFER_H


#include <system/CFFI.h>
#include <utils/ArrayBufferView.h>


namespace lime {


	struct AudioBuffer {

		hl_type* t;
		int bitsPerSample;
		int channels;
		ArrayBufferView* data;
		int sampleRate;


		AudioBuffer (value audioBuffer);
		~AudioBuffer ();
		value Value (value audioBuffer);
		value Value ();

	};


}


#endif