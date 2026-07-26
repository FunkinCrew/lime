#pragma once


#include <media/AudioDataFormat.h>


namespace lime {


	class AudioDataUtil {


		public:

			static int getDataFormatByteDepth (AudioDataFormat format);
			static double ReadNormalized (const void* ptr, AudioDataFormat sourceFormat);
			static void WriteNormalized (void* ptr, AudioDataFormat sourceFormat, double sample);
			static void CopyAudioData (void* source, AudioDataFormat sourceFormat, void* destination, AudioDataFormat destFormat, size_t frames, int channels);


	}


}