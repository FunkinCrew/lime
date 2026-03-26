#include <media/codecs/opus/OpusFile.h>
#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/Bytes.h>


namespace lime {


	static int id_high;
	static int id_low;
	static value infoValue;
	static value int64Value;
	static vdynamic *hl_int64Value;
	static bool init = false;


	inline void _initializeOpus () {

		if (!init) {

			id_high = val_id ("high");
			id_low = val_id ("low");

			int64Value = alloc_empty_object ();

			value* root = alloc_root ();
			*root = int64Value;

			init = true;

		}

	}


	inline void _hl_initializeOpus () {

		if (!init) {

			id_high = hl_hash_utf8 ("high");
			id_low = hl_hash_utf8 ("low");

			hl_int64Value = (vdynamic*)hl_alloc_dynobj ();

			hl_add_root(&hl_int64Value);

			init = true;

		}

	}


	value allocOpusInt64 (opus_int64 val) {

		opus_int32 low = val;
		opus_int32 high = (val >> 32);

		_initializeOpus ();

		alloc_field (int64Value, id_low, alloc_int (low));
		alloc_field (int64Value, id_high, alloc_int (high));

		return int64Value;

	}


	vdynamic* hl_allocOpusInt64 (opus_int64 val) {

		opus_int32 low = val;
		opus_int32 high = (val >> 32);

		_hl_initializeOpus ();

		hl_dyn_seti (hl_int64Value, id_low, &hlt_i32, low);
		hl_dyn_seti (hl_int64Value, id_high, &hlt_i32, high);

		return hl_int64Value;

	}


	void lime_opus_file_free (value opusFile);
	HL_PRIM void HL_NAME(hl_opus_file_free) (HL_CFFIPointer* opusFile);


	void gc_opus_file (value opusFile) {

		lime_opus_file_free (opusFile);

	}


	void hl_gc_opus_file (HL_CFFIPointer* opusFile) {

		lime_hl_opus_file_free (opusFile);

	}


	int lime_opus_file_channel_count (value opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
		return op_channel_count (of, -1);

	}


	HL_PRIM int HL_NAME(hl_opus_file_channel_count) (HL_CFFIPointer* opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
		return op_channel_count (of, -1);

	}


	int lime_opus_file_decode (value opusFile, value buffer, int position, int length) {

		if (val_is_null (buffer)) {
			return 0;
		}

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);

		Bytes bytes;
		bytes.Set (buffer);

		length >>= 1;

		opus_int16* data = (opus_int16*)(bytes.b + position);
		int read = 0;

		while (read < length) {

			int result = op_read (of, data, length - read, NULL);

			if (result != OP_HOLE) {

				if (result <= OP_EREAD) {

					return 0;

				}
				else if (result == 0) {

					break;

				}
				else {

					result *= op_channel_count (of, -1);
					read += result;
					data += result;

				}

			}

		}

		return read << 1;

	}


	HL_PRIM int HL_NAME(hl_opus_file_decode) (HL_CFFIPointer* opusFile, Bytes* buffer, int offset, int samples) {

		if (!buffer) {
			return 0;
		}

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;

		opus_int16* data = (opus_int16*)(buffer->b + offset);
		int read = 0;

		while (read < samples) {

			int result = op_read (of, data, samples, NULL);

			if (result != OP_HOLE) {

				if (result <= OP_EREAD) {

					return 0;

				}
				else if (result == 0) {

					break;

				}
				else {

					read += result;
					data += result;
					samples -= result;

				}
			}
		}

		return read;
	}


	void lime_opus_file_free (value opusFile) {

		if (!val_is_null (opusFile)) {

			OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
			val_gc (opusFile, 0);
			op_free (of);

		}

	}


	HL_PRIM void HL_NAME(hl_opus_file_free) (HL_CFFIPointer* opusFile) {

		if (opusFile) {

			OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
			opusFile->finalizer = 0;
			op_free (of);

		}

	}


	value lime_opus_file_from_bytes (value data) {

		Bytes bytes;
		bytes.Set (data);

		OggOpusFile* of = OpusFile::FromBytes (&bytes);

		if (of) return CFFIPointer ((void*)(uintptr_t)of, gc_opus_file);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_opus_file_from_bytes) (Bytes* data) {

		OggOpusFile* of = OpusFile::FromBytes (data);

		if (of) return HLCFFIPointer ((void*)(uintptr_t)of, (hl_finalizer)hl_gc_opus_file);
		return NULL;

	}


	value lime_opus_file_from_file (HxString path) {

		OggOpusFile* of = OpusFile::FromFile (path.c_str ());

		if (of) return CFFIPointer ((void*)(uintptr_t)of, gc_opus_file);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_opus_file_from_file) (hl_vstring* path) {

		OggOpusFile* of = OpusFile::FromFile (path ? hl_to_utf8 (path->bytes) : NULL);

		if (of) return HLCFFIPointer ((void*)(uintptr_t)of, (hl_finalizer)hl_gc_opus_file);
		return NULL;

	}


	int lime_opus_file_seek (value opusFile, value posLow, value posHigh) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
		opus_int64 pos = ((opus_int64)val_number (posHigh) << 32) | (opus_int64)val_number (posLow);
		if (pos > 0) return op_pcm_seek (of, pos);
		else return op_raw_seek (of, 0);

	}


	HL_PRIM int HL_NAME(hl_opus_file_seek) (HL_CFFIPointer* opusFile, int posLow, int posHigh) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
		opus_int64 pos = ((opus_int64)posHigh << 32) | (opus_int64)posLow;
		if (pos > 0) return op_pcm_seek (of, pos);
		else return op_raw_seek (of, 0);

	}


	bool lime_opus_file_seekable (value opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
		return op_seekable (of);

	}


	HL_PRIM bool HL_NAME(hl_opus_file_seekable) (HL_CFFIPointer* opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
		return op_seekable (of);

	}


	value lime_opus_file_tell (value opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
		return allocOpusInt64 (op_pcm_tell (of));

	}


	HL_PRIM vdynamic* HL_NAME(hl_opus_file_tell) (HL_CFFIPointer* opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
		return hl_allocOpusInt64 (op_pcm_tell (of));

	}


	value lime_opus_file_total (value opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)val_data (opusFile);
		return allocOpusInt64 (op_pcm_total (of, -1));

	}


	HL_PRIM vdynamic* HL_NAME(hl_opus_file_total) (HL_CFFIPointer* opusFile) {

		OggOpusFile* of = (OggOpusFile*)(uintptr_t)opusFile->ptr;
		return hl_allocOpusInt64 (op_pcm_total (of, -1));

	}


	DEFINE_PRIME1 (lime_opus_file_channel_count);
	DEFINE_PRIME4 (lime_opus_file_decode);
	DEFINE_PRIME1v (lime_opus_file_free);
	DEFINE_PRIME1 (lime_opus_file_from_bytes);
	DEFINE_PRIME1 (lime_opus_file_from_file);
	DEFINE_PRIME3 (lime_opus_file_seek);
	DEFINE_PRIME1 (lime_opus_file_seekable);
	DEFINE_PRIME1 (lime_opus_file_tell);
	DEFINE_PRIME1 (lime_opus_file_total);


	#define _TBYTES _OBJ (_I32 _BYTES)
	#define _TCFFIPOINTER _DYN

	DEFINE_HL_PRIM (_I32,          hl_opus_file_channel_count,      _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_opus_file_decode,             _TCFFIPOINTER _TBYTES _I32 _I32);
	DEFINE_HL_PRIM (_VOID,         hl_opus_file_free,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_opus_file_from_bytes,         _TBYTES);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_opus_file_from_file,          _STRING);
	DEFINE_HL_PRIM (_I32,          hl_opus_file_seek,               _TCFFIPOINTER _I32 _I32);
	DEFINE_HL_PRIM (_BOOL,         hl_opus_file_seekable,           _TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,          hl_opus_file_tell,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,          hl_opus_file_total,              _TCFFIPOINTER);


}


extern "C" int lime_opus_register_prims () {

	return 0;

}