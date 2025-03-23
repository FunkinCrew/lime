#include <media/decoders/SDL_sound.h>
#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/Bytes.h>

namespace lime {

	static int id_channels;
	static int id_rate;
	static int id_format;
	static value infoValue;
	static vdynamic *hl_infoValue;
	static bool init = false;

	inline void _initializeSDLSound () {

		if (!init) {

			id_channels = val_id ("channels");
			id_rate = val_id ("rate");
			id_format = val_id ("format");

			infoValue = alloc_empty_object ();

			value* root = alloc_root ();
			*root = infoValue;

			init = true;

		}
	}

	inline void _hl_initializeSDLSound () {

		if (!init) {

			id_channels = hl_hash_utf8 ("channels");
			id_rate = hl_hash_utf8 ("rate");
			id_format = hl_hash_utf8 ("format");

			hl_infoValue = (vdynamic*)hl_alloc_dynobj ();

			hl_add_root(&hl_infoValue);

			init = true;

		}
	}

	void gc_sound_sample (value soundSample);
	void hl_gc_sound_sample (HL_CFFIPointer* soundSample);

	value lime_sdl_sound_from_file (HxString path) {

		Sound_Sample* soundSample = SDL_sound::FromFile (path.c_str());

		if (soundSample) {

			return CFFIPointer ((void*)(uintptr_t)soundSample, gc_sound_sample);

		}

		return alloc_null ();

	}

	HL_PRIM HL_CFFIPointer* HL_NAME(hl_sdl_sound_from_file) (hl_vstring* path) {

		Sound_Sample* soundSample = SDL_sound::FromFile (path ? hl_to_utf8 (path->bytes) : NULL);

		if (soundSample) {

			return HLCFFIPointer ((void*)(uintptr_t)soundSample, (hl_finalizer)hl_gc_sound_sample);

		}

		return NULL;

	}

	value lime_sdl_sound_from_bytes (value data) {

		if (val_is_null (data)) {

			return alloc_null ();

		}

		Bytes bytes;
		bytes.Set (data);

		Sound_Sample* soundSample = SDL_sound::FromBytes (&bytes);

		if (soundSample) {

			return CFFIPointer ((void*)(uintptr_t)soundSample, gc_sound_sample);

		}

		return alloc_null ();

	}

	HL_PRIM HL_CFFIPointer* HL_NAME(hl_sdl_sound_from_bytes) (Bytes* data) {

		Sound_Sample* soundSample = SDL_sound::FromBytes (data);

		if (soundSample) {

			return HLCFFIPointer ((void*)(uintptr_t)soundSample, (hl_finalizer)hl_gc_sound_sample);

		}

		return NULL;

	}

	void lime_sdl_sound_free (value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			Sound_FreeSample (sample);

		}

	}

	HL_PRIM void HL_NAME(hl_sdl_sound_free) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			soundSample->finalizer = 0;
			Sound_FreeSample (sample);

		}

	}

	value lime_sdl_sound_info (value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			_initializeSDLSound ();

			alloc_field (infoValue, id_channels, alloc_int (sample->desired.channels));
			alloc_field (infoValue, id_rate, alloc_int (sample->desired.rate));
			alloc_field (infoValue, id_format, alloc_int (sample->desired.format));

			return infoValue;

		}

		return alloc_null ();

	}


	HL_PRIM vdynamic* HL_NAME(hl_sdl_sound_info) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			_hl_initializeSDLSound ();

			hl_dyn_seti (hl_infoValue, id_channels, &hlt_i32, sample->desired.channels);
			hl_dyn_seti (hl_infoValue, id_rate, &hlt_i32, sample->desired.rate);
			hl_dyn_seti (hl_infoValue, id_format, &hlt_i32, sample->desired.format);

			return hl_infoValue;

		}

		return NULL;

	}

	int lime_sdl_sound_duration(value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);

		if (sample) {

			return Sound_GetDuration (sample);

		}

		return 0;
	}

	HL_PRIM int HL_NAME(hl_sdl_sound_duration) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;

		if (sample) {

			return Sound_GetDuration (sample);

		}

		return 0;
	}

	int lime_sdl_sound_get_buffer_size (value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			return sample->buffer_size;

		}

		return 0;
	}

	HL_PRIM int HL_NAME(hl_sdl_sound_get_buffer_size) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			return sample->buffer_size;

		}

		return 0;
	}

	bool lime_sdl_sound_set_buffer_size (value soundSample, int newSize) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			return Sound_SetBufferSize(sample, (Uint32)newSize) != 0;

		}

		return false;
	}

	HL_PRIM bool HL_NAME(hl_sdl_sound_set_buffer_size) (HL_CFFIPointer* soundSample, int newSize) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			return Sound_SetBufferSize(sample, (Uint32)newSize) != 0;

		}

		return false;
	}

	int decode_real(Sound_Sample* sample, Bytes* buffer) {

		if (sample) {

			Uint32 decoded = Sound_Decode (sample);

			if (decoded > 0) {

				if (decoded > buffer->length) decoded = buffer->length;
				memcpy(buffer->b, sample->buffer, decoded);

			}

			return decoded;
		}

		return 0;
	}

	int lime_sdl_sound_decode(value soundSample, value buffer) {

		if (val_is_null (buffer)) {

			return 0;
		}

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);

		Bytes bytes;
		bytes.Set(buffer);

		return decode_real(sample, &bytes);
	}

	HL_PRIM int HL_NAME(hl_sdl_sound_decode) (HL_CFFIPointer* soundSample, Bytes* buffer) {

		if (!buffer) {

			return 0;
		}

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;

		return decode_real(sample, buffer);
	}

	int decode_all_real(Sound_Sample* sample, Bytes* buffer) {

		if (sample) {

			Uint32 result = Sound_DecodeAll (sample);

			if (result > 0) {

				if (buffer->length != result) {
					buffer->Resize(result);
				}

				memcpy(buffer->b, sample->buffer, result);
			}

			return result;
		}

		return 0;
	}

	int lime_sdl_sound_decode_all(value soundSample, value buffer) {

		if (val_is_null (buffer)) {

			return 0;

		}

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);

		Bytes bytes;
		bytes.Set(buffer);

		return decode_all_real(sample, &bytes);
	}

	HL_PRIM int HL_NAME(hl_sdl_sound_decode_all) (HL_CFFIPointer* soundSample, Bytes* buffer) {

		if (!buffer) {

			return 0;
		}

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;

		return decode_all_real(sample, buffer);
	}

	bool lime_sdl_sound_seekable(value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);

		if (sample) {

			return (sample->flags & SOUND_SAMPLEFLAG_CANSEEK) != 0;

		}

		return false;
	}

	HL_PRIM bool HL_NAME(hl_sdl_sound_seekable) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;

		if (sample) {

			return (sample->flags & SOUND_SAMPLEFLAG_CANSEEK) != 0;

		}

		return false;
	}

	void lime_sdl_sound_seek (value soundSample, int ms) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			Sound_Seek (sample, ms);

		}

	}

	HL_PRIM void HL_NAME(hl_sdl_sound_seek) (HL_CFFIPointer* soundSample, int ms) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			Sound_Seek (sample, ms);

		}

	}

	void lime_sdl_sound_rewind (value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);
		if (sample) {

			Sound_Rewind (sample);

		}

	}

	HL_PRIM void HL_NAME(hl_sdl_sound_rewind) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;
		if (sample) {

			Sound_Rewind (sample);

		}

	}

	int lime_sdl_sound_get_flags(value soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)val_data (soundSample);

		if (sample) {

			return sample->flags;
		}

		return 0;
	}

	HL_PRIM int HL_NAME(hl_sdl_sound_get_flags) (HL_CFFIPointer* soundSample) {

		Sound_Sample* sample = (Sound_Sample*)(uintptr_t)soundSample->ptr;

		if (sample) {

			return sample->flags;
		}

		return 0;
	}

	void gc_sound_sample (value soundSample) {

		lime_sdl_sound_free (soundSample);

	}

	void hl_gc_sound_sample (HL_CFFIPointer* soundSample) {

		lime_hl_sdl_sound_free (soundSample);

	}

	DEFINE_PRIME1  (lime_sdl_sound_from_file		);
	DEFINE_PRIME1  (lime_sdl_sound_from_bytes		);
	DEFINE_PRIME1v (lime_sdl_sound_free				);
	DEFINE_PRIME1  (lime_sdl_sound_info				);
	DEFINE_PRIME1  (lime_sdl_sound_duration			);
	DEFINE_PRIME1  (lime_sdl_sound_get_buffer_size	);
	DEFINE_PRIME2  (lime_sdl_sound_set_buffer_size	);
	DEFINE_PRIME2  (lime_sdl_sound_decode			);
	DEFINE_PRIME2  (lime_sdl_sound_decode_all		);
	DEFINE_PRIME2v (lime_sdl_sound_seek				);
	DEFINE_PRIME1  (lime_sdl_sound_seekable			);
	DEFINE_PRIME1v (lime_sdl_sound_rewind			);
	DEFINE_PRIME1  (lime_sdl_sound_get_flags		);

	#ifndef _TBYTES
	#define _TBYTES _OBJ (_I32 _BYTES)
	#endif

	#ifndef _TCFFIPOINTER
	#define _TCFFIPOINTER _DYN
	#endif

	DEFINE_HL_PRIM (_TCFFIPOINTER,	hl_sdl_sound_from_file,			_STRING);
	DEFINE_HL_PRIM (_TCFFIPOINTER,	hl_sdl_sound_from_bytes,		_TBYTES);
	DEFINE_HL_PRIM (_VOID,			hl_sdl_sound_free, 				_TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,			hl_sdl_sound_info,				_TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,			hl_sdl_sound_duration,			_TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,			hl_sdl_sound_get_buffer_size,	_TCFFIPOINTER);
	DEFINE_HL_PRIM (_BOOL,			hl_sdl_sound_set_buffer_size,	_TCFFIPOINTER _I32);
	DEFINE_HL_PRIM (_I32,			hl_sdl_sound_decode,			_TCFFIPOINTER _TBYTES);
	DEFINE_HL_PRIM (_I32,			hl_sdl_sound_decode_all,		_TCFFIPOINTER _TBYTES);
	DEFINE_HL_PRIM (_VOID,			hl_sdl_sound_seek,				_TCFFIPOINTER _I32);
	DEFINE_HL_PRIM (_BOOL,			hl_sdl_sound_seekable,			_TCFFIPOINTER);
	DEFINE_HL_PRIM (_VOID,			hl_sdl_sound_rewind,			_TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,			hl_sdl_sound_get_flags,			_TCFFIPOINTER);
}


extern "C" int lime_sdl_sound_register_prims () {

	return 0;

}