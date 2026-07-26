#include <media/utils/AudioDataUtil.h>
#include <math.h>
#include <string.h>

#if LIME_DR_LIBS
#include <dr_wav.h>
#endif


namespace lime {


	int AudioDataUtil::GetDataFormatByteDepth (AudioDataFormat format) {

		switch (format) {

			case U8: return 1;
			case S16: return 2;
			case S24: return 3;
			case S32: return 4;
			case F32: return 4;

		}

		return 0;

	}


	double AudioDataUtil::ReadNormalized (const void* ptr, AudioDataFormat sourceFormat) {

		switch (sourceFormat) {

			case U8:
				// 0.00784313725490196078 turns 0..255 to 0.0..2.0; stolen from dr_wav drwav_u8_to_f32
				return (double)(*(const uint8_t*)ptr) * 0.00784313725490196078 - 1.0;

			case S16:
				// 0.000030517578125 turns -32768..32767 to -1.0..1.0; again stolen from dr_wav drwav_s16_to_f32
				return (double)(*(const int16_t*)ptr) * 0.000030517578125;

			case S24: {
				// stolen from dr_wav drwav_s24_to_f32
				const uint8_t* p = (const uint8_t*)ptr;
				uint32_t a = (uint32_t)(p[0]) << 8;
				uint32_t b = (uint32_t)(p[1]) << 16;
				uint32_t c = (uint32_t)(p[2]) << 24;

				return (double)((int32_t)(a | b | c) >> 8) * 0.00000011920928955078125;
			}

			case S32:
				return (double)(*(const int32_t*)ptr) / 2147483648.0;

			case F32:
				return (double)(*(const float*)ptr);

		}

		return 0.0;

	}


	void AudioDataUtil::WriteNormalized (void* ptr, AudioDataFormat sourceFormat, double sample) {

		switch (sourceFormat) {

			case U8: {
				*((uint8_t*)ptr) = (uint8_t)(((sample < -1) ? -1 : ((sample > 1) ? 1 : sample)) * 127.5 + 127.5 + (sample < 0.0 ? -0.5 : 0.5));
				break;
			}

			case S16: {
				double v = sample * 32768.0 + (sample < 0.0 ? -0.5 : 0.5);
				*((int16_t*)ptr) = (int16_t)((v > 32767.0) ? 32767.0 : ((v < -32768.0) ? -32768.0 : v));
				break;
			}

			case S24: {
				double v = sample * 8388608.0 + (sample < 0.0 ? -0.5 : 0.5);
				int32_t iv = (int32_t)((v > 8388607.0) ? 8388607.0 : ((v < -8388608.0) ? -8388608.0 : v));
				uint8_t* p = (uint8_t*)ptr;
				p[0] = (uint8_t)(iv & 0xFF);
				p[1] = (uint8_t)((iv >> 8) & 0xFF);
				p[2] = (uint8_t)((iv >> 16) & 0xFF);
				break;
			}

			case S32: {
				double v = sample * 2147483648.0 + (sample < 0.0 ? -0.5 : 0.5);
				*((int32_t*)ptr) = (int32_t)((v > 2147483647.0) ? 2147483647.0 : ((v < -2147483648.0) ? -2147483648.0 : v));
				break;
			}

			case F32:
				// No need to clamp
				*((float*)ptr) = (float)sample;
				break;

		}

	}


	void AudioDataUtil::CopyAudioData (const void* source, AudioDataFormat sourceFormat, void* destination, AudioDataFormat destFormat, size_t frames, int channels) {

		if (!source || !destination || frames <= 0 || channels <= 0) return;

		size_t count = frames * (size_t)channels;

		if (sourceFormat == destFormat) {

			memcpy (destination, source, count * (size_t)AudioDataUtil::GetDataFormatByteDepth (sourceFormat));
			return;

		}

		#if LIME_DR_LIBS
		// Use dr_wav low-level converters if possible for faster instructions.
		switch (destFormat) {
 
			case S16:
 
				switch (sourceFormat) {
 
					case U8:  drwav_u8_to_s16  ((drwav_int16*)destination, (const drwav_uint8*)source, count); return;
					case S24: drwav_s24_to_s16 ((drwav_int16*)destination, (const drwav_uint8*)source, count); return;
					case S32: drwav_s32_to_s16 ((drwav_int16*)destination, (const drwav_int32*)source, count); return;
					case F32: drwav_f32_to_s16 ((drwav_int16*)destination, (const float*)source, count); return;
					default: break;
 
				}
 
				break;
 
			case F32:
 
				switch (sourceFormat) {
 
					case U8:  drwav_u8_to_f32  ((float*)destination, (const drwav_uint8*)source, count); return;
					case S16: drwav_s16_to_f32 ((float*)destination, (const drwav_int16*)source, count); return;
					case S24: drwav_s24_to_f32 ((float*)destination, (const drwav_uint8*)source, count); return;
					case S32: drwav_s32_to_f32 ((float*)destination, (const drwav_int32*)source, count); return;
					default: break;
 
				}
 
				break;
 
			case S32:
 
				switch (sourceFormat) {
 
					case U8:  drwav_u8_to_s32  ((drwav_int32*)destination, (const drwav_uint8*)source, count); return;
					case S16: drwav_s16_to_s32 ((drwav_int32*)destination, (const drwav_int16*)source, count); return;
					case S24: drwav_s24_to_s32 ((drwav_int32*)destination, (const drwav_uint8*)source, count); return;
					case F32: drwav_f32_to_s32 ((drwav_int32*)destination, (const float*)source, count); return;
					default: break;
 
				}
 
				break;
 
			default:

				// U8 or S24 destination - dr_wav has no converter for these, fall through to the generic path below.
				break;
 
		}
		#endif

		// Generic Implementation
		uint8_t* pIn = (uint8_t*)source;
		uint8_t* pOut = (uint8_t*)destination;
		size_t inByteDepth = (size_t)AudioDataUtil::GetDataFormatByteDepth (sourceFormat);
		size_t outByteDepth = (size_t)AudioDataUtil::GetDataFormatByteDepth (destFormat);

		for (size_t i = 0; i < count; ++i) {

			AudioDataUtil::WriteNormalized (pOut, destFormat, AudioDataUtil::ReadNormalized (pIn, sourceFormat));
			pOut += outByteDepth;
			pIn += inByteDepth;

		}

	}


}