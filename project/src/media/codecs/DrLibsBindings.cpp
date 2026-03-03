#include <media/codecs/flac/DrFlac.h>
#include <media/codecs/mp3/DrMp3.h>
#include <media/codecs/wav/DrWav.h>
#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/Bytes.h>


namespace lime {


	static int id_bitsPerSample;
	static int id_channels;
	static int id_high;
	static int id_low;
	static int id_sampleRate;
	static value infoValue;
	static value int64Value;
	static vdynamic *hl_infoValue;
	static vdynamic *hl_int64Value;
	static bool init = false;


	inline void _initializeDrLibs () {

		if (!init) {

			id_bitsPerSample = val_id ("bitsPerSample");
			id_channels = val_id ("channels");
			id_high = val_id ("high");
			id_low = val_id ("low");
			id_sampleRate = val_id ("sampleRate");

			infoValue = alloc_empty_object ();
			int64Value = alloc_empty_object ();

			value* root = alloc_root ();
			*root = infoValue;

			value* root2 = alloc_root ();
			*root2 = int64Value;

			init = true;

		}

	}


	inline void _hl_initializeDrLibs () {

		if (!init) {

			id_bitsPerSample = hl_hash_utf8 ("bitsPerSample");
			id_channels = hl_hash_utf8 ("channels");
			id_high = hl_hash_utf8 ("high");
			id_low = hl_hash_utf8 ("low");
			id_sampleRate = hl_hash_utf8 ("sampleRate");

			hl_infoValue = (vdynamic*)hl_alloc_dynobj ();
			hl_int64Value = (vdynamic*)hl_alloc_dynobj ();

			hl_add_root(&hl_infoValue);
			hl_add_root(&hl_int64Value);

			init = true;

		}

	}


	value allocDrFlacInt64 (drflac_int64 val) {

		drflac_int32 low = val;
		drflac_int32 high = (val >> 32);

		_initializeDrLibs ();

		alloc_field (int64Value, id_low, alloc_int (low));
		alloc_field (int64Value, id_high, alloc_int (high));

		return int64Value;

	}


	vdynamic* hl_allocDrFlacInt64 (drflac_int64 val) {

		drflac_int32 low = val;
		drflac_int32 high = (val >> 32);

		_hl_initializeDrLibs ();

		hl_dyn_seti (hl_int64Value, id_low, &hlt_i32, low);
		hl_dyn_seti (hl_int64Value, id_high, &hlt_i32, high);

		return hl_int64Value;

	}


	value allocDrMp3Int64 (drmp3_int64 val) {

		drmp3_int32 low = val;
		drmp3_int32 high = (val >> 32);

		_initializeDrLibs ();

		alloc_field (int64Value, id_low, alloc_int (low));
		alloc_field (int64Value, id_high, alloc_int (high));

		return int64Value;

	}


	vdynamic* hl_allocDrMp3Int64 (drmp3_int64 val) {

		drmp3_int32 low = val;
		drmp3_int32 high = (val >> 32);

		_hl_initializeDrLibs ();

		hl_dyn_seti (hl_int64Value, id_low, &hlt_i32, low);
		hl_dyn_seti (hl_int64Value, id_high, &hlt_i32, high);

		return hl_int64Value;

	}


	value allocDrWavInt64 (drwav_int64 val) {

		drwav_int32 low = val;
		drwav_int32 high = (val >> 32);

		_initializeDrLibs ();

		alloc_field (int64Value, id_low, alloc_int (low));
		alloc_field (int64Value, id_high, alloc_int (high));

		return int64Value;

	}


	vdynamic* hl_allocDrWavInt64 (drwav_int64 val) {

		drwav_int32 low = val;
		drwav_int32 high = (val >> 32);

		_hl_initializeDrLibs ();

		hl_dyn_seti (hl_int64Value, id_low, &hlt_i32, low);
		hl_dyn_seti (hl_int64Value, id_high, &hlt_i32, high);

		return hl_int64Value;

	}


	void lime_drlibs_flac_close (value flac);
	HL_PRIM void HL_NAME(hl_drlibs_flac_close) (HL_CFFIPointer* flac);


	void gc_drflac (value flac) {

		lime_drlibs_flac_close (flac);

	}


	void hl_gc_drflac (HL_CFFIPointer* flac) {

		lime_hl_drlibs_flac_close (flac);

	}


	void lime_drlibs_flac_close (value flac) {

		if (!val_is_null (flac)) {

			drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);
			val_gc (flac, 0);
			DrFlac::Close (pFlac);

		}

	}


	HL_PRIM void HL_NAME(hl_drlibs_flac_close) (HL_CFFIPointer* flac) {

		if (flac) {

			drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;
			flac->finalizer = 0;
			DrFlac::Close (pFlac);

		}

	}


	int lime_drlibs_flac_decode (value flac, value buffer, int position, int length, int word) {

		if (val_is_null (buffer)) {
			return 0;
		}

		drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);

		Bytes bytes;
		bytes.Set (buffer);

		if (word == 4)
		{

			return drflac_read_pcm_frames_s32 (pFlac, (int)(length / pFlac->channels / 4), (drflac_int32 *)(bytes.b + position)) * 4 * pFlac->channels;

		}
		else if (word == 2)
		{

			return drflac_read_pcm_frames_s16 (pFlac, (int)(length / pFlac->channels / 2), (drflac_int16 *)(bytes.b + position)) * 2 * pFlac->channels;

		}
		else
		{

			return 0;

		}

	}


	HL_PRIM int HL_NAME(hl_drlibs_flac_decode) (HL_CFFIPointer* flac, Bytes* buffer, int position, int length, int word) {

		if (!buffer) {
			return 0;
		}

		drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;

		if (word == 4)
		{

			return drflac_read_pcm_frames_s32 (pFlac, (int)(length / pFlac->channels / 4), (drflac_int32 *)(buffer->b + position)) * 4 * pFlac->channels;

		}
		else if (word == 2)
		{

			return drflac_read_pcm_frames_s16 (pFlac, (int)(length / pFlac->channels / 2), (drflac_int16 *)(buffer->b + position)) * 2 * pFlac->channels;

		}
		else
		{

			return 0;

		}

	}


	value lime_drlibs_flac_from_bytes (value data) {

		Bytes bytes;
		bytes.Set (data);

		drflac* pFlac = DrFlac::FromBytes (&bytes);

		if (pFlac) return CFFIPointer ((void*)(uintptr_t)pFlac, gc_drflac);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_flac_from_bytes) (Bytes* data) {

		drflac* pFlac = DrFlac::FromBytes (data);

		if (pFlac) return HLCFFIPointer ((void*)(uintptr_t)pFlac, (hl_finalizer)hl_gc_drflac);
		return NULL;

	}


	value lime_drlibs_flac_from_file (HxString path) {

		drflac* pFlac = DrFlac::FromFile (path.c_str ());

		if (pFlac) return CFFIPointer ((void*)(uintptr_t)pFlac, gc_drflac);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_flac_from_file) (hl_vstring* path) {

		drflac* pFlac = DrFlac::FromFile (path ? hl_to_utf8 (path->bytes) : NULL);

		if (pFlac) return HLCFFIPointer ((void*)(uintptr_t)pFlac, (hl_finalizer)hl_gc_drflac);
		return NULL;

	}


	value lime_drlibs_flac_info (value flac) {

		drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);

		_initializeDrLibs ();

		alloc_field (infoValue, id_bitsPerSample, alloc_int (pFlac->bitsPerSample));
		alloc_field (infoValue, id_channels, alloc_int (pFlac->channels));
		alloc_field (infoValue, id_sampleRate, alloc_int (pFlac->sampleRate));

		return infoValue;

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_flac_info) (HL_CFFIPointer* flac) {

		drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;

		_initializeDrLibs ();

		hl_dyn_seti (hl_infoValue, id_bitsPerSample, &hlt_i32, pFlac->bitsPerSample);
		hl_dyn_seti (hl_infoValue, id_channels, &hlt_i32, pFlac->channels);
		hl_dyn_seti (hl_infoValue, id_sampleRate, &hlt_i32, pFlac->sampleRate);

		return hl_infoValue;

	}


	int lime_drlibs_flac_seek (value flac, value posLow, value posHigh) {

		drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);
		drflac_uint64 pos = ((drflac_uint64)val_number (posHigh) << 32) | (drflac_uint64)val_number (posLow);
		return drflac_seek_to_pcm_frame (pFlac, pos);

	}


	HL_PRIM int HL_NAME(hl_drlibs_flac_seek) (HL_CFFIPointer* flac, int posLow, int posHigh) {

		drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;
		drflac_uint64 pos = ((drflac_uint64)posHigh << 32) | (drflac_uint64)posLow;
		return drflac_seek_to_pcm_frame (pFlac, pos);

	}


	value lime_drlibs_flac_tell (value flac) {

		drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);
		return allocDrFlacInt64 ((drflac_int64)pFlac->currentPCMFrame);

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_flac_tell) (HL_CFFIPointer* flac) {

		drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;
		return hl_allocDrFlacInt64 ((drflac_int64)pFlac->currentPCMFrame);

	}


	value lime_drlibs_flac_total (value flac) {

		drflac* pFlac = (drflac*)(uintptr_t)val_data (flac);
		return allocDrFlacInt64 ((drflac_int64)pFlac->totalPCMFrameCount);

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_flac_total) (HL_CFFIPointer* flac) {

		drflac* pFlac = (drflac*)(uintptr_t)flac->ptr;
		return hl_allocDrFlacInt64 ((drflac_int64)pFlac->totalPCMFrameCount);

	}


	void lime_drlibs_mp3_uninit (value mp3);
	HL_PRIM void HL_NAME(hl_drlibs_mp3_uninit) (HL_CFFIPointer* mp3);


	void gc_drmp3 (value mp3) {

		lime_drlibs_mp3_uninit (mp3);

	}


	void hl_gc_drmp3 (HL_CFFIPointer* mp3) {

		lime_hl_drlibs_mp3_uninit (mp3);

	}


	int lime_drlibs_mp3_decode (value mp3, value buffer, int position, int length) {

		if (val_is_null (buffer)) {
			return 0;
		}

		drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);

		Bytes bytes;
		bytes.Set (buffer);

		return drmp3_read_pcm_frames_s16 (pMp3, (int)(length / pMp3->channels / 2), (drmp3_int16 *)(bytes.b + position)) * 2 * pMp3->channels;

	}


	HL_PRIM int HL_NAME(hl_drlibs_mp3_decode) (HL_CFFIPointer* mp3, Bytes* buffer, int position, int length) {

		if (!buffer) {
			return 0;
		}

		drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;

		return drmp3_read_pcm_frames_s16 (pMp3, (int)(length / pMp3->channels / 2), (drmp3_int16 *)(buffer->b + position)) * 2 * pMp3->channels;

	}


	value lime_drlibs_mp3_from_bytes (value data) {

		Bytes bytes;
		bytes.Set (data);

		drmp3* pMp3 = DrMp3::FromBytes (&bytes);

		if (pMp3) return CFFIPointer ((void*)(uintptr_t)pMp3, gc_drmp3);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_mp3_from_bytes) (Bytes* data) {

		drmp3* pMp3 = DrMp3::FromBytes (data);

		if (pMp3) return HLCFFIPointer ((void*)(uintptr_t)pMp3, (hl_finalizer)hl_gc_drmp3);
		return NULL;

	}


	value lime_drlibs_mp3_from_file (HxString path) {

		drmp3* pMp3 = DrMp3::FromFile (path.c_str ());

		if (pMp3) return CFFIPointer ((void*)(uintptr_t)pMp3, gc_drmp3);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_mp3_from_file) (hl_vstring* path) {

		drmp3* pMp3 = DrMp3::FromFile (path ? hl_to_utf8 (path->bytes) : NULL);

		if (pMp3) return HLCFFIPointer ((void*)(uintptr_t)pMp3, (hl_finalizer)hl_gc_drmp3);
		return NULL;

	}


	value lime_drlibs_mp3_info (value mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);

		_initializeDrLibs ();

		alloc_field (infoValue, id_bitsPerSample, alloc_int (16));
		alloc_field (infoValue, id_channels, alloc_int (pMp3->channels));
		alloc_field (infoValue, id_sampleRate, alloc_int (pMp3->sampleRate));

		return infoValue;

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_mp3_info) (HL_CFFIPointer* mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;

		_initializeDrLibs ();

		hl_dyn_seti (hl_infoValue, id_bitsPerSample, &hlt_i32, 16);
		hl_dyn_seti (hl_infoValue, id_channels, &hlt_i32, pMp3->channels);
		hl_dyn_seti (hl_infoValue, id_sampleRate, &hlt_i32, pMp3->sampleRate);

		return hl_infoValue;

	}


	int lime_drlibs_mp3_seek (value mp3, value posLow, value posHigh) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);
		drmp3_uint64 pos = ((drmp3_uint64)val_number (posHigh) << 32) | (drmp3_uint64)val_number (posLow);
		return drmp3_seek_to_pcm_frame (pMp3, pos);

	}


	HL_PRIM int HL_NAME(hl_drlibs_mp3_seek) (HL_CFFIPointer* mp3, int posLow, int posHigh) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;
		drmp3_uint64 pos = ((drmp3_uint64)posHigh << 32) | (drmp3_uint64)posLow;
		return drmp3_seek_to_pcm_frame (pMp3, pos);

	}


	value lime_drlibs_mp3_tell (value mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);
		return allocDrMp3Int64 ((drmp3_int64)pMp3->currentPCMFrame);

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_mp3_tell) (HL_CFFIPointer* mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;
		return hl_allocDrMp3Int64 ((drmp3_int64)pMp3->currentPCMFrame);

	}


	value lime_drlibs_mp3_total (value mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);
		return allocDrMp3Int64 ((drmp3_int64)drmp3_get_pcm_frame_count (pMp3));

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_mp3_total) (HL_CFFIPointer* mp3) {

		drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;
		return hl_allocDrMp3Int64 ((drmp3_int64)drmp3_get_pcm_frame_count (pMp3));

	}


	void lime_drlibs_mp3_uninit (value mp3) {

		if (!val_is_null (mp3)) {

			drmp3* pMp3 = (drmp3*)(uintptr_t)val_data (mp3);
			val_gc (mp3, 0);
			DrMp3::Close (pMp3);

		}

	}


	HL_PRIM void HL_NAME(hl_drlibs_mp3_uninit) (HL_CFFIPointer* mp3) {

		if (mp3) {

			drmp3* pMp3 = (drmp3*)(uintptr_t)mp3->ptr;
			mp3->finalizer = 0;
			DrMp3::Close (pMp3);

		}

	}


	void lime_drlibs_wav_uninit (value wav);
	HL_PRIM void HL_NAME(hl_drlibs_wav_uninit) (HL_CFFIPointer* wav);


	void gc_drwav (value wav) {

		lime_drlibs_wav_uninit (wav);

	}


	void hl_gc_drwav (HL_CFFIPointer* wav) {

		lime_hl_drlibs_wav_uninit (wav);

	}


	int lime_drlibs_wav_decode (value wav, value buffer, int position, int length, int word) {

		if (val_is_null (buffer)) {
			return 0;
		}

		drwav* pWav = (drwav*)(uintptr_t)val_data (wav);

		Bytes bytes;
		bytes.Set (buffer);

		if (word == 4)
		{

			return drwav_read_pcm_frames_s32 (pWav, (int)(length / pWav->channels / 4), (drwav_int32 *)(bytes.b + position)) * 4 * pWav->channels;

		}
		else if (word == 2)
		{

			return drwav_read_pcm_frames_s16 (pWav, (int)(length / pWav->channels / 2), (drwav_int16 *)(bytes.b + position)) * 2 * pWav->channels;

		}
		else
		{

			return 0;

		}

	}


	HL_PRIM int HL_NAME(hl_drlibs_wav_decode) (HL_CFFIPointer* wav, Bytes* buffer, int position, int length, int word) {

		if (!buffer) {
			return 0;
		}

		drwav* pWav = (drwav*)(uintptr_t)wav->ptr;

		if (word == 4)
		{

			return drwav_read_pcm_frames_s32 (pWav, (int)(length / pWav->channels / 4), (drwav_int32 *)(buffer->b + position)) * 4 * pWav->channels;

		}
		else if (word == 2)
		{

			return drwav_read_pcm_frames_s16 (pWav, (int)(length / pWav->channels / 2), (drwav_int16 *)(buffer->b + position)) * 2 * pWav->channels;

		}
		else
		{

			return 0;

		}

	}


	value lime_drlibs_wav_from_bytes (value data) {

		Bytes bytes;
		bytes.Set (data);

		drwav* pWav = DrWav::FromBytes (&bytes);

		if (pWav) return CFFIPointer ((void*)(uintptr_t)pWav, gc_drwav);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_wav_from_bytes) (Bytes* data) {

		drwav* pWav = DrWav::FromBytes (data);

		if (pWav) return HLCFFIPointer ((void*)(uintptr_t)pWav, (hl_finalizer)hl_gc_drwav);
		return NULL;

	}


	value lime_drlibs_wav_from_file (HxString path) {

		drwav* pWav = DrWav::FromFile (path.c_str ());

		if (pWav) return CFFIPointer ((void*)(uintptr_t)pWav, gc_drwav);
		return alloc_null ();

	}


	HL_PRIM HL_CFFIPointer* HL_NAME(hl_drlibs_wav_from_file) (hl_vstring* path) {

		drwav* pWav = DrWav::FromFile (path ? hl_to_utf8 (path->bytes) : NULL);

		if (pWav) return HLCFFIPointer ((void*)(uintptr_t)pWav, (hl_finalizer)hl_gc_drwav);
		return NULL;

	}


	value lime_drlibs_wav_info (value wav) {

		drwav* pWav = (drwav*)(uintptr_t)val_data (wav);

		_initializeDrLibs ();

		alloc_field (infoValue, id_bitsPerSample, alloc_int (pWav->bitsPerSample));
		alloc_field (infoValue, id_channels, alloc_int (pWav->channels));
		alloc_field (infoValue, id_sampleRate, alloc_int (pWav->sampleRate));

		return infoValue;

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_wav_info) (HL_CFFIPointer* wav) {

		drwav* pWav = (drwav*)(uintptr_t)wav->ptr;

		_initializeDrLibs ();

		hl_dyn_seti (hl_infoValue, id_bitsPerSample, &hlt_i32, pWav->bitsPerSample);
		hl_dyn_seti (hl_infoValue, id_channels, &hlt_i32, pWav->channels);
		hl_dyn_seti (hl_infoValue, id_sampleRate, &hlt_i32, pWav->sampleRate);

		return hl_infoValue;

	}


	int lime_drlibs_wav_seek (value wav, value posLow, value posHigh) {

		drwav* pWav = (drwav*)(uintptr_t)val_data (wav);
		drwav_uint64 pos = ((drwav_uint64)val_number (posHigh) << 32) | (drwav_uint64)val_number (posLow);
		return drwav_seek_to_pcm_frame (pWav, pos);

	}


	HL_PRIM int HL_NAME(hl_drlibs_wav_seek) (HL_CFFIPointer* wav, int posLow, int posHigh) {

		drwav* pWav = (drwav*)(uintptr_t)wav->ptr;
		drwav_uint64 pos = ((drwav_uint64)posHigh << 32) | (drwav_uint64)posLow;
		return drwav_seek_to_pcm_frame (pWav, pos);

	}


	value lime_drlibs_wav_tell (value wav) {

		drwav* pWav = (drwav*)(uintptr_t)val_data (wav);
		drwav_uint64 cursor;
		if (drwav_get_cursor_in_pcm_frames(pWav, &cursor) == DRWAV_SUCCESS) return allocDrWavInt64 ((drwav_int64)cursor);
		else return allocDrWavInt64 (0);

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_wav_tell) (HL_CFFIPointer* wav) {

		drwav* pWav = (drwav*)(uintptr_t)wav->ptr;
		drwav_uint64 cursor;
		if (drwav_get_cursor_in_pcm_frames(pWav, &cursor) == DRWAV_SUCCESS) return hl_allocDrWavInt64 ((drwav_int64)cursor);
		else return hl_allocDrWavInt64 (0);

	}


	value lime_drlibs_wav_total (value wav) {

		drwav* pWav = (drwav*)(uintptr_t)val_data (wav);
		drwav_uint64 length;
		if (drwav_get_length_in_pcm_frames(pWav, &length) == DRWAV_SUCCESS) return allocDrWavInt64 ((drwav_int64)length);
		else return allocDrWavInt64 (0);

	}


	HL_PRIM vdynamic* HL_NAME(hl_drlibs_wav_total) (HL_CFFIPointer* wav) {

		drwav* pWav = (drwav*)(uintptr_t)wav->ptr;
		drwav_uint64 length;
		if (drwav_get_length_in_pcm_frames(pWav, &length) == DRWAV_SUCCESS) return hl_allocDrWavInt64 ((drwav_int64)length);
		else return hl_allocDrWavInt64 (0);

	}


	void lime_drlibs_wav_uninit (value wav) {

		if (!val_is_null (wav)) {

			drwav* pWav = (drwav*)(uintptr_t)val_data (wav);
			val_gc (wav, 0);
			DrWav::Close (pWav);

		}

	}


	HL_PRIM void HL_NAME(hl_drlibs_wav_uninit) (HL_CFFIPointer* wav) {

		if (wav) {

			drwav* pWav = (drwav*)(uintptr_t)wav->ptr;
			wav->finalizer = 0;
			DrWav::Close (pWav);

		}

	}


	DEFINE_PRIME1v (lime_drlibs_flac_close);
	DEFINE_PRIME5 (lime_drlibs_flac_decode);
	DEFINE_PRIME1 (lime_drlibs_flac_from_bytes);
	DEFINE_PRIME1 (lime_drlibs_flac_from_file);
	DEFINE_PRIME1 (lime_drlibs_flac_info);
	DEFINE_PRIME3 (lime_drlibs_flac_seek);
	DEFINE_PRIME1 (lime_drlibs_flac_tell);
	DEFINE_PRIME1 (lime_drlibs_flac_total);
	DEFINE_PRIME4 (lime_drlibs_mp3_decode);
	DEFINE_PRIME1 (lime_drlibs_mp3_from_bytes);
	DEFINE_PRIME1 (lime_drlibs_mp3_from_file);
	DEFINE_PRIME1 (lime_drlibs_mp3_info);
	DEFINE_PRIME3 (lime_drlibs_mp3_seek);
	DEFINE_PRIME1 (lime_drlibs_mp3_tell);
	DEFINE_PRIME1 (lime_drlibs_mp3_total);
	DEFINE_PRIME1v (lime_drlibs_mp3_uninit);
	DEFINE_PRIME5 (lime_drlibs_wav_decode);
	DEFINE_PRIME1 (lime_drlibs_wav_from_bytes);
	DEFINE_PRIME1 (lime_drlibs_wav_from_file);
	DEFINE_PRIME1 (lime_drlibs_wav_info);
	DEFINE_PRIME3 (lime_drlibs_wav_seek);
	DEFINE_PRIME1 (lime_drlibs_wav_tell);
	DEFINE_PRIME1 (lime_drlibs_wav_total);
	DEFINE_PRIME1v (lime_drlibs_wav_uninit);


	#define _TBYTES _OBJ (_I32 _BYTES)
	#define _TCFFIPOINTER _DYN

	DEFINE_HL_PRIM (_VOID,         hl_drlibs_flac_close,              _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_flac_decode,             _TCFFIPOINTER _TBYTES _I32 _I32 _I32);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_flac_from_bytes,         _TBYTES);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_flac_from_file,          _STRING);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_flac_info,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_flac_seek,               _TCFFIPOINTER _I32 _I32);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_flac_tell,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_flac_total,              _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_mp3_decode,              _TCFFIPOINTER _TBYTES _I32 _I32);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_mp3_from_bytes,          _TBYTES);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_mp3_from_file,           _STRING);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_mp3_info,                _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_mp3_seek,                _TCFFIPOINTER _I32 _I32);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_mp3_tell,                _TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_mp3_total,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_VOID,         hl_drlibs_mp3_uninit,              _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_wav_decode,              _TCFFIPOINTER _TBYTES _I32 _I32 _I32);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_wav_from_bytes,          _TBYTES);
	DEFINE_HL_PRIM (_TCFFIPOINTER, hl_drlibs_wav_from_file,           _STRING);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_wav_info,                _TCFFIPOINTER);
	DEFINE_HL_PRIM (_I32,          hl_drlibs_wav_seek,                _TCFFIPOINTER _I32 _I32);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_wav_tell,                _TCFFIPOINTER);
	DEFINE_HL_PRIM (_DYN,          hl_drlibs_wav_total,               _TCFFIPOINTER);
	DEFINE_HL_PRIM (_VOID,         hl_drlibs_wav_uninit,              _TCFFIPOINTER);


}


extern "C" int lime_drlibs_register_prims () {

	return 0;

}