#include <system/CFFIPointer.h>
#include <utils/Bytes.h>
#include <utils/File.h>

// MiniAudio Implementation
#define MA_NO_ENCODING
#define MA_NO_RESOURCE_MANAGER
#define MA_NO_GENERATION
#if defined(IPHONE) || defined(HX_MACOS)
#define MA_NO_RUNTIME_LINKING
#endif
#if defined(ANDROID) && !defined(MA_NO_AAUDIO)
#define MA_AAUDIO_MIN_ANDROID_SDK_VERSION 31
#endif
#define MA_IMPLEMENTATION
#include <miniaudio.h>

// Opus and Vorbis decoders
#include <extras/decoders/libopus/miniaudio_libopus.c>
#include <extras/decoders/libvorbis/miniaudio_libvorbis.c>

namespace lime
{

	value alloc_Int64(int64_t val)
	{
		int32_t high = (val >> 32);
		int32_t low = val;

		value int64Value = alloc_empty_object();
		alloc_field(int64Value, val_id("high"), alloc_int(high));
		alloc_field(int64Value, val_id("low"), alloc_int(low));
		return int64Value;
	}

	int64_t val_Int64(value inValue)
	{
		if (val_is_null(inValue))
		{
			return 0;
		}

		value lowVal = val_field(inValue, val_id("low"));
		value highVal = val_field(inValue, val_id("high"));

		if (val_is_null(lowVal) || val_is_null(highVal))
		{
			return 0;
		}

		return (((int64_t)val_int(highVal)) << 32) | (uint32_t)val_int(lowVal);
	}

	value alloc_Vec3(ma_vec3f val)
	{
		value result = alloc_array(3);
		val_array_set_i(result, 0, alloc_float(val.x));
		val_array_set_i(result, 1, alloc_float(val.y));
		val_array_set_i(result, 2, alloc_float(val.z));
		return result;
	}

	void lime_ma_log_callback_proc(void *pUserData, ma_uint32 level, const char *pMessage)
	{
		AutoGCRoot *root = (AutoGCRoot *)pUserData;

		if (root)
		{
			int base = 0;

			gc_set_top_of_stack(&base, true);

			val_call2(root->get(), alloc_int(level), alloc_string(pMessage));

			gc_set_top_of_stack(0, true);
		}
	}

	void gc_ma_log(value handle)
	{
		ma_log *log = (ma_log *)val_data(handle);

		if (log)
		{
			ma_log_uninit(log);

			delete log;
		}
	}

	value lime_ma_log_init()
	{
		ma_log *log = new ma_log();

		if (ma_log_init(NULL, log) != MA_SUCCESS)
		{
			delete log;

			return alloc_null();
		}

		return CFFIPointer(log, gc_ma_log);
	}

	void lime_ma_log_uninit(value pLog)
	{
		ma_log *log = (ma_log *)val_data(pLog);

		if (log)
		{
			ma_log_uninit(log);

			free_abstract(pLog);

			delete log;
		}
	}

	int lime_ma_log_register_callback(value pLog, value onLog)
	{
		ma_log *log = (ma_log *)val_data(pLog);

		if (!log)
		{
			return MA_INVALID_ARGS;
		}

		AutoGCRoot *root = new AutoGCRoot(onLog);

		ma_result result = ma_log_register_callback(log, ma_log_callback_init(lime_ma_log_callback_proc, root));

		if (result != MA_SUCCESS)
		{
			delete root;
		}

		return result;
	}

	int lime_ma_log_unregister_callback(value pLog, value onLog)
	{
		ma_log *log = (ma_log *)val_data(pLog);

		if (!log)
		{
			return MA_INVALID_ARGS;
		}

		ma_log_callback callback = {lime_ma_log_callback_proc, nullptr};

#ifndef MA_NO_THREADING
		ma_mutex_lock(&log->lock);
#endif

		for (ma_uint32 i = 0; i < log->callbackCount; ++i)
		{
			AutoGCRoot *root = (AutoGCRoot *)log->callbacks[i].pUserData;

			if (root && root->get() == onLog)
			{
				callback = log->callbacks[i];
				break;
			}
		}

#ifndef MA_NO_THREADING
		ma_mutex_unlock(&log->lock);
#endif

		ma_result result = ma_log_unregister_callback(log, callback);

		if (result == MA_SUCCESS)
		{
			AutoGCRoot *root = (AutoGCRoot *)callback.pUserData;

			if (root)
			{
				delete root;
			}
		}

		return result;
	}

	int lime_ma_log_post(value pLog, int level, HxString pMessage)
	{
		return ma_log_post((ma_log *)val_data(pLog), level, hxs_utf8(pMessage, nullptr));
	}

	ma_result ma_decoder_read_callback(ma_decoder *pDecoder, void *pBufferOut, size_t bytesToRead, size_t *pBytesRead)
	{
		if (pDecoder)
		{
			size_t bytesRead = ((File *)pDecoder->pUserData)->Read(pBufferOut, bytesToRead);

			if (pBytesRead != NULL)
			{
				(*pBytesRead) = bytesRead;
			}

			return MA_SUCCESS;
		}

		return MA_ERROR;
	}

	ma_result ma_decoder_seek_callback(ma_decoder *pDecoder, ma_int64 byteOffset, ma_seek_origin origin)
	{
		if (pDecoder)
		{
			switch (origin)
			{
				case MA_SEEK_SET:
					return ((File *)pDecoder->pUserData)->Seek(byteOffset, SEEK_SET) < 0 ? MA_ERROR : MA_SUCCESS;

				case MA_SEEK_CUR:
					return ((File *)pDecoder->pUserData)->Seek(byteOffset, SEEK_CUR) < 0 ? MA_ERROR : MA_SUCCESS;

				case MA_SEEK_END:
					return ((File *)pDecoder->pUserData)->Seek(byteOffset, SEEK_END) < 0 ? MA_ERROR : MA_SUCCESS;

				default:
					return MA_INVALID_ARGS;
			}
		}

		return MA_ERROR;
	}

	ma_result ma_decoder_tell_callback(ma_decoder *pDecoder, ma_int64 *pCursor)
	{
		if (pDecoder)
		{
			ma_int64 position = ((File *)pDecoder->pUserData)->Tell();

			if (position >= 0)
			{
				if (pCursor != NULL)
				{
					(*pCursor) = position;
				}

				return MA_SUCCESS;
			}
		}

		return MA_ERROR;
	}

	void gc_ma_decoder(value handle)
	{
		ma_decoder *decoder = (ma_decoder *)val_data(handle);

		if (decoder)
		{
			if (decoder->onRead == ma_decoder_read_callback)
			{
				File *file = (File *)decoder->pUserData;

				file->Close();

				delete file;
			}

			ma_decoder_uninit(decoder);

			delete decoder;
		}
	}

	value lime_ma_decoder_init_file(value pFilePath, value pConfig)
	{
		File *file = new File(val_string(pFilePath), "rb");

		if (!file->handle)
		{
			delete file;

			return alloc_null();
		}

		ma_decoder_config decoderConfig = ma_decoder_config_init_default();

		if (!val_is_null(pConfig))
		{
			decoderConfig.format = (ma_format)val_int(val_field(pConfig, val_id("format")));
			decoderConfig.channels = val_int(val_field(pConfig, val_id("channels")));
			decoderConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		}

		ma_decoding_backend_vtable *pBackendVTables[] = {ma_decoding_backend_libvorbis, ma_decoding_backend_libopus, ma_decoding_backend_wav, ma_decoding_backend_flac, ma_decoding_backend_mp3};

		decoderConfig.ppBackendVTables = pBackendVTables;

		decoderConfig.backendCount = sizeof(pBackendVTables) / sizeof(pBackendVTables[0]);

		ma_decoder *decoder = new ma_decoder();

		ma_result result = ma_decoder_init(ma_decoder_read_callback, ma_decoder_seek_callback, ma_decoder_tell_callback, file, &decoderConfig, decoder);

		if (result != MA_SUCCESS)
		{
			file->Close();

			delete file;

			delete decoder;

			return alloc_null();
		}

		return CFFIPointer(decoder, gc_ma_decoder);
	}

	value lime_ma_decoder_init_memory(value pData, value pConfig)
	{
		Bytes bytes(pData);

		File *file = new File(&bytes, true);

		if (!file->handle)
		{
			delete file;

			return alloc_null();
		}

		ma_decoder_config decoderConfig = ma_decoder_config_init_default();

		if (!val_is_null(pConfig))
		{
			decoderConfig.format = (ma_format)val_int(val_field(pConfig, val_id("format")));
			decoderConfig.channels = val_int(val_field(pConfig, val_id("channels")));
			decoderConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		}

		ma_decoding_backend_vtable *pBackendVTables[] = {ma_decoding_backend_libvorbis, ma_decoding_backend_libopus, ma_decoding_backend_wav, ma_decoding_backend_flac, ma_decoding_backend_mp3};

		decoderConfig.ppBackendVTables = pBackendVTables;

		decoderConfig.backendCount = sizeof(pBackendVTables) / sizeof(pBackendVTables[0]);

		ma_decoder *decoder = new ma_decoder();

		ma_result result = ma_decoder_init(ma_decoder_read_callback, ma_decoder_seek_callback, ma_decoder_tell_callback, file, &decoderConfig, decoder);

		if (result != MA_SUCCESS)
		{
			file->Close();

			delete file;

			delete decoder;

			return alloc_null();
		}

		return CFFIPointer(decoder, gc_ma_decoder);
	}

	void lime_ma_decoder_uninit(value pDecoder)
	{
		ma_decoder *decoder = (ma_decoder *)val_data(pDecoder);

		if (decoder)
		{
			if (decoder->onRead == ma_decoder_read_callback)
			{
				File *file = (File *)decoder->pUserData;

				file->Close();

				delete file;
			}

			ma_decoder_uninit(decoder);

			free_abstract(pDecoder);

			delete decoder;
		}
	}

	value lime_ma_decoder_read_pcm_frames(value pDecoder, value pFrames, value frameCount)
	{
		ma_uint64 framesRead = 0;

		ma_decoder_read_pcm_frames((ma_decoder *)val_data(pDecoder), (void *)val_data(pFrames), (ma_uint64)val_Int64(frameCount), &framesRead);

		return alloc_Int64(framesRead);
	}

	int lime_ma_decoder_seek_to_pcm_frame(value pDecoder, value frameIndex)
	{
		return ma_decoder_seek_to_pcm_frame((ma_decoder *)val_data(pDecoder), (ma_uint64)val_Int64(frameIndex));
	}

	value lime_ma_decoder_get_data_format(value pDecoder)
	{
		ma_format format;
		ma_uint32 channels;
		ma_uint32 sampleRate;
		ma_channel channelMap[MA_MAX_CHANNELS];

		if (ma_decoder_get_data_format((ma_decoder *)val_data(pDecoder), &format, &channels, &sampleRate, channelMap, MA_MAX_CHANNELS) != MA_SUCCESS)
		{
			return alloc_null();
		}

		value data_format = alloc_empty_object();

		alloc_field(data_format, val_id("format"), alloc_int(format));
		alloc_field(data_format, val_id("channels"), alloc_int(channels));
		alloc_field(data_format, val_id("sampleRate"), alloc_int(sampleRate));

		value jChannelMap = alloc_array(channels);

		for (ma_uint32 i = 0; i < channels; i++)
		{
			val_array_set_i(jChannelMap, i, alloc_int(channelMap[i]));
		}

		alloc_field(data_format, val_id("channelMap"), jChannelMap);

		return data_format;
	}

	value lime_ma_decoder_get_cursor_in_pcm_frames(value pDecoder)
	{
		ma_uint64 cursor = 0;

		ma_decoder_get_cursor_in_pcm_frames((ma_decoder *)val_data(pDecoder), &cursor);

		return alloc_Int64(cursor);
	}

	value lime_ma_decoder_get_length_in_pcm_frames(value pDecoder)
	{
		ma_uint64 length = 0;

		ma_decoder_get_length_in_pcm_frames((ma_decoder *)val_data(pDecoder), &length);

		return alloc_Int64(length);
	}

	value lime_ma_decoder_get_available_frames(value pDecoder)
	{
		ma_uint64 availableFrames = 0;

		ma_decoder_get_available_frames((ma_decoder *)val_data(pDecoder), &availableFrames);

		return alloc_Int64(availableFrames);
	}

	void gc_ma_audio_buffer(value handle)
	{
		ma_audio_buffer *buffer = (ma_audio_buffer *)val_data(handle);

		if (buffer)
		{
			ma_audio_buffer_uninit(buffer);

			delete buffer;
		}
	}

	value lime_ma_audio_buffer_init(value pConfig)
	{
		ma_audio_buffer_config bufferConfig;

		MA_ZERO_OBJECT(&bufferConfig);

		bufferConfig.format = (ma_format)val_int(val_field(pConfig, val_id("format")));
		bufferConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		bufferConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		bufferConfig.sizeInFrames = (ma_uint64)val_Int64(val_field(pConfig, val_id("sizeInFrames")));
		bufferConfig.pData = (void *)val_data(val_field(pConfig, val_id("pData")));

		ma_audio_buffer *buffer = new ma_audio_buffer();

		if (ma_audio_buffer_init(&bufferConfig, buffer) != MA_SUCCESS)
		{
			delete buffer;

			return alloc_null();
		}

		return CFFIPointer(buffer, gc_ma_audio_buffer);
	}

	value lime_ma_audio_buffer_init_and_copy_data(value pConfig)
	{
		ma_audio_buffer_config bufferConfig;

		MA_ZERO_OBJECT(&bufferConfig);

		bufferConfig.format = (ma_format)val_int(val_field(pConfig, val_id("format")));
		bufferConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		bufferConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		bufferConfig.sizeInFrames = (ma_uint64)val_Int64(val_field(pConfig, val_id("sizeInFrames")));
		bufferConfig.pData = (void *)val_data(val_field(pConfig, val_id("pData")));

		ma_audio_buffer *buffer = new ma_audio_buffer();

		if (ma_audio_buffer_init_and_copy_data(&bufferConfig, buffer) != MA_SUCCESS)
		{
			delete buffer;

			return alloc_null();
		}

		return CFFIPointer(buffer, gc_ma_audio_buffer);
	}

	void lime_ma_audio_buffer_uninit(value pAudioBuffer)
	{
		ma_audio_buffer *buffer = (ma_audio_buffer *)val_data(pAudioBuffer);

		if (buffer)
		{
			ma_audio_buffer_uninit(buffer);

			free_abstract(pAudioBuffer);

			delete buffer;
		}
	}

	value lime_ma_audio_buffer_read_pcm_frames(value pAudioBuffer, value pFrames, value frameCount)
	{
		ma_uint64 framesRead = 0;

		ma_audio_buffer_read_pcm_frames((ma_audio_buffer *)val_data(pAudioBuffer), (void *)val_data(pFrames), (ma_uint64)val_Int64(frameCount), &framesRead);

		return alloc_Int64(framesRead);
	}

	int lime_ma_audio_buffer_seek_to_pcm_frame(value pAudioBuffer, value frameIndex)
	{
		return ma_audio_buffer_seek_to_pcm_frame((ma_audio_buffer *)val_data(pAudioBuffer), (ma_uint64)val_Int64(frameIndex));
	}

	value lime_ma_audio_buffer_map(value pAudioBuffer, value ppFramesOut, value frameCount)
	{
		ma_uint64 pFrameCount = (ma_uint64)val_Int64(frameCount);

		ma_audio_buffer_map((ma_audio_buffer *)val_data(pAudioBuffer), (void **)val_data(ppFramesOut), &pFrameCount);

		return alloc_Int64(pFrameCount);
	}

	int lime_ma_audio_buffer_unmap(value pAudioBuffer, value frameCount)
	{
		return ma_audio_buffer_unmap((ma_audio_buffer *)val_data(pAudioBuffer), (ma_uint64)val_Int64(frameCount));
	}

	bool lime_ma_audio_buffer_at_end(value pAudioBuffer)
	{
		return ma_audio_buffer_at_end((ma_audio_buffer *)val_data(pAudioBuffer));
	}

	value lime_ma_audio_buffer_get_cursor_in_pcm_frames(value pAudioBuffer)
	{
		ma_uint64 cursor = 0;

		ma_audio_buffer_get_cursor_in_pcm_frames((ma_audio_buffer *)val_data(pAudioBuffer), &cursor);

		return alloc_Int64(cursor);
	}

	value lime_ma_audio_buffer_get_length_in_pcm_frames(value pAudioBuffer)
	{
		ma_uint64 length = 0;

		ma_audio_buffer_get_length_in_pcm_frames((ma_audio_buffer *)val_data(pAudioBuffer), &length);

		return alloc_Int64(length);
	}

	value lime_ma_audio_buffer_get_available_frames(value pAudioBuffer)
	{
		ma_uint64 availableFrames = 0;

		ma_audio_buffer_get_available_frames((ma_audio_buffer *)val_data(pAudioBuffer), &availableFrames);

		return alloc_Int64(availableFrames);
	}

	void gc_ma_audio_ring_buffer(value handle)
	{
		ma_audio_ring_buffer *ringBuffer = (ma_audio_ring_buffer *)val_data(handle);

		if (ringBuffer)
		{
			ma_audio_ring_buffer_uninit(ringBuffer);

			delete ringBuffer;
		}
	}

	value lime_ma_audio_ring_buffer_init(value pConfig)
	{
		ma_audio_ring_buffer_config ringBufferConfig;

		MA_ZERO_OBJECT(&ringBufferConfig);

		ringBufferConfig.format = (ma_format)val_int(val_field(pConfig, val_id("format")));
		ringBufferConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		ringBufferConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		ringBufferConfig.sizeInFrames = val_int(val_field(pConfig, val_id("sizeInFrames")));

		ma_audio_ring_buffer *ringBuffer = new ma_audio_ring_buffer();

		if (ma_audio_ring_buffer_init(&ringBufferConfig, ringBuffer) != MA_SUCCESS)
		{
			delete ringBuffer;

			return alloc_null();
		}

		return CFFIPointer(ringBuffer, gc_ma_audio_ring_buffer);
	}

	void lime_ma_audio_ring_buffer_uninit(value pRingBuffer)
	{
		ma_audio_ring_buffer *ringBuffer = (ma_audio_ring_buffer *)val_data(pRingBuffer);

		if (ringBuffer)
		{
			ma_audio_ring_buffer_uninit(ringBuffer);

			free_abstract(pRingBuffer);

			delete ringBuffer;
		}
	}

	int lime_ma_audio_ring_buffer_map_produce(value pRingBuffer, int frameCount, value ppMappedBuffer)
	{
		return ma_audio_ring_buffer_map_produce((ma_audio_ring_buffer *)val_data(pRingBuffer), frameCount, (void **)val_data(ppMappedBuffer));
	}

	void lime_ma_audio_ring_buffer_unmap_produce(value pRingBuffer, int frameCount)
	{
		ma_audio_ring_buffer_unmap_produce((ma_audio_ring_buffer *)val_data(pRingBuffer), frameCount);
	}

	int lime_ma_audio_ring_buffer_map_consume(value pRingBuffer, int frameCount, value ppMappedBuffer)
	{
		return ma_audio_ring_buffer_map_consume((ma_audio_ring_buffer *)val_data(pRingBuffer), frameCount, (void **)val_data(ppMappedBuffer));
	}

	void lime_ma_audio_ring_buffer_unmap_consume(value pRingBuffer, int frameCount)
	{
		ma_audio_ring_buffer_unmap_consume((ma_audio_ring_buffer *)val_data(pRingBuffer), frameCount);
	}

	int lime_ma_audio_ring_buffer_write_pcm_frames(value pRingBuffer, value pFrames, int frameCount)
	{
		ma_uint32 framesWritten = 0;

		ma_audio_ring_buffer_write_pcm_frames((ma_audio_ring_buffer *)val_data(pRingBuffer), (void *)val_data(pFrames), frameCount, &framesWritten);

		return framesWritten;
	}

	int lime_ma_audio_ring_buffer_read_pcm_frames(value pRingBuffer, value pFrames, int frameCount)
	{
		ma_uint32 framesRead = 0;

		ma_audio_ring_buffer_read_pcm_frames((ma_audio_ring_buffer *)val_data(pRingBuffer), (void *)val_data(pFrames), frameCount, &framesRead);

		return framesRead;
	}

	int lime_ma_audio_ring_buffer_get_length_in_pcm_frames(value pRingBuffer)
	{
		ma_uint32 length = 0;

		ma_audio_ring_buffer_get_length_in_pcm_frames((ma_audio_ring_buffer *)val_data(pRingBuffer), &length);

		return length;
	}

	int lime_ma_node_attach_output_bus(value pNode, int outputBusIndex, value pOtherNode, int otherNodeInputBusIndex)
	{
		return ma_node_attach_output_bus((ma_node *)val_data(pNode), outputBusIndex, (ma_node *)val_data(pOtherNode), otherNodeInputBusIndex);
	}

	int lime_ma_node_detach_output_bus(value pNode, int outputBusIndex)
	{
		return ma_node_detach_output_bus((ma_node *)val_data(pNode), outputBusIndex);
	}

	int lime_ma_node_detach_all_output_buses(value pNode)
	{
		return ma_node_detach_all_output_buses((ma_node *)val_data(pNode));
	}

	void gc_ma_biquad_node(value handle)
	{
		ma_biquad_node *biquadNode = (ma_biquad_node *)val_data(handle);

		if (biquadNode)
		{
			ma_biquad_node_uninit(biquadNode, NULL);

			delete biquadNode;
		}
	}

	value lime_ma_biquad_node_init(value pNodeGraph, value pConfig)
	{
		ma_biquad_config biquadConfig;

		biquadConfig.format = ma_format_f32;
		biquadConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		biquadConfig.b0 = val_number(val_field(pConfig, val_id("b0")));
		biquadConfig.b1 = val_number(val_field(pConfig, val_id("b1")));
		biquadConfig.b2 = val_number(val_field(pConfig, val_id("b2")));
		biquadConfig.a0 = val_number(val_field(pConfig, val_id("a0")));
		biquadConfig.a1 = val_number(val_field(pConfig, val_id("a1")));
		biquadConfig.a2 = val_number(val_field(pConfig, val_id("a2")));

		ma_biquad_node_config biquadNodeConfig;

		biquadNodeConfig.nodeConfig = ma_node_config_init();
		biquadNodeConfig.biquad = biquadConfig;

		ma_biquad_node *biquadNode = new ma_biquad_node();

		if (ma_biquad_node_init((ma_node_graph *)val_data(pNodeGraph), &biquadNodeConfig, NULL, biquadNode) != MA_SUCCESS)
		{
			delete biquadNode;

			return alloc_null();
		}

		return CFFIPointer(biquadNode, gc_ma_biquad_node);
	}

	int lime_ma_biquad_node_reinit(value pConfig, value pNode)
	{
		ma_biquad_config biquadConfig;

		biquadConfig.format = ma_format_f32;
		biquadConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		biquadConfig.b0 = val_number(val_field(pConfig, val_id("b0")));
		biquadConfig.b1 = val_number(val_field(pConfig, val_id("b1")));
		biquadConfig.b2 = val_number(val_field(pConfig, val_id("b2")));
		biquadConfig.a0 = val_number(val_field(pConfig, val_id("a0")));
		biquadConfig.a1 = val_number(val_field(pConfig, val_id("a1")));
		biquadConfig.a2 = val_number(val_field(pConfig, val_id("a2")));

		return ma_biquad_node_reinit(&biquadConfig, (ma_biquad_node *)val_data(pNode));
	}

	void lime_ma_biquad_node_uninit(value pNode)
	{
		ma_biquad_node *biquadNode = (ma_biquad_node *)val_data(pNode);

		if (biquadNode)
		{
			ma_biquad_node_uninit(biquadNode, NULL);

			free_abstract(pNode);

			delete biquadNode;
		}
	}

	void gc_ma_lpf_node(value handle)
	{
		ma_lpf_node *lpfNode = (ma_lpf_node *)val_data(handle);

		if (lpfNode)
		{
			ma_lpf_node_uninit(lpfNode, NULL);

			delete lpfNode;
		}
	}

	value lime_ma_lpf_node_init(value pNodeGraph, value pConfig)
	{
		ma_lpf_config lpfConfig;

		lpfConfig.format = ma_format_f32;
		lpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		lpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		lpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		lpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		ma_lpf_node_config lpfNodeConfig;

		lpfNodeConfig.nodeConfig = ma_node_config_init();
		lpfNodeConfig.lpf = lpfConfig;

		ma_lpf_node *lpfNode = new ma_lpf_node();

		if (ma_lpf_node_init((ma_node_graph *)val_data(pNodeGraph), &lpfNodeConfig, NULL, lpfNode) != MA_SUCCESS)
		{
			delete lpfNode;

			return alloc_null();
		}

		return CFFIPointer(lpfNode, gc_ma_lpf_node);
	}

	int lime_ma_lpf_node_reinit(value pConfig, value pNode)
	{
		ma_lpf_config lpfConfig;

		lpfConfig.format = ma_format_f32;
		lpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		lpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		lpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		lpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		return ma_lpf_node_reinit(&lpfConfig, (ma_lpf_node *)val_data(pNode));
	}

	void lime_ma_lpf_node_uninit(value pNode)
	{
		ma_lpf_node *lpfNode = (ma_lpf_node *)val_data(pNode);

		if (lpfNode)
		{
			ma_lpf_node_uninit(lpfNode, NULL);

			free_abstract(pNode);

			delete lpfNode;
		}
	}

	void gc_ma_hpf_node(value handle)
	{
		ma_hpf_node *hpfNode = (ma_hpf_node *)val_data(handle);

		if (hpfNode)
		{
			ma_hpf_node_uninit(hpfNode, NULL);

			delete hpfNode;
		}
	}

	value lime_ma_hpf_node_init(value pNodeGraph, value pConfig)
	{
		ma_hpf_config hpfConfig;

		hpfConfig.format = ma_format_f32;
		hpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		hpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		hpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		hpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		ma_hpf_node_config hpfNodeConfig;

		hpfNodeConfig.nodeConfig = ma_node_config_init();
		hpfNodeConfig.hpf = hpfConfig;

		ma_hpf_node *hpfNode = new ma_hpf_node();

		if (ma_hpf_node_init((ma_node_graph *)val_data(pNodeGraph), &hpfNodeConfig, NULL, hpfNode) != MA_SUCCESS)
		{
			delete hpfNode;

			return alloc_null();
		}

		return CFFIPointer(hpfNode, gc_ma_hpf_node);
	}

	int lime_ma_hpf_node_reinit(value pConfig, value pNode)
	{
		ma_hpf_config hpfConfig;

		hpfConfig.format = ma_format_f32;
		hpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		hpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		hpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		hpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		return ma_hpf_node_reinit(&hpfConfig, (ma_hpf_node *)val_data(pNode));
	}

	void lime_ma_hpf_node_uninit(value pNode)
	{
		ma_hpf_node *hpfNode = (ma_hpf_node *)val_data(pNode);

		if (hpfNode)
		{
			ma_hpf_node_uninit(hpfNode, NULL);

			free_abstract(pNode);

			delete hpfNode;
		}
	}

	void gc_ma_bpf_node(value handle)
	{
		ma_bpf_node *bpfNode = (ma_bpf_node *)val_data(handle);

		if (bpfNode)
		{
			ma_bpf_node_uninit(bpfNode, NULL);

			delete bpfNode;
		}
	}

	value lime_ma_bpf_node_init(value pNodeGraph, value pConfig)
	{
		ma_bpf_config bpfConfig;

		bpfConfig.format = ma_format_f32;
		bpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		bpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		bpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		bpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		ma_bpf_node_config bpfNodeConfig;

		bpfNodeConfig.nodeConfig = ma_node_config_init();
		bpfNodeConfig.bpf = bpfConfig;

		ma_bpf_node *bpfNode = new ma_bpf_node();

		if (ma_bpf_node_init((ma_node_graph *)val_data(pNodeGraph), &bpfNodeConfig, NULL, bpfNode) != MA_SUCCESS)
		{
			delete bpfNode;

			return alloc_null();
		}

		return CFFIPointer(bpfNode, gc_ma_bpf_node);
	}

	int lime_ma_bpf_node_reinit(value pConfig, value pNode)
	{
		ma_bpf_config bpfConfig;

		bpfConfig.format = ma_format_f32;
		bpfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		bpfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		bpfConfig.cutoffFrequency = val_number(val_field(pConfig, val_id("cutoffFrequency")));
		bpfConfig.order = val_int(val_field(pConfig, val_id("order")));

		return ma_bpf_node_reinit(&bpfConfig, (ma_bpf_node *)val_data(pNode));
	}

	void lime_ma_bpf_node_uninit(value pNode)
	{
		ma_bpf_node *bpfNode = (ma_bpf_node *)val_data(pNode);

		if (bpfNode)
		{
			ma_bpf_node_uninit(bpfNode, NULL);

			free_abstract(pNode);

			delete bpfNode;
		}
	}

	void gc_ma_notch_node(value handle)
	{
		ma_notch_node *notchNode = (ma_notch_node *)val_data(handle);

		if (notchNode)
		{
			ma_notch_node_uninit(notchNode, NULL);

			delete notchNode;
		}
	}

	value lime_ma_notch_node_init(value pNodeGraph, value pConfig)
	{
		ma_notch_config notchConfig;

		notchConfig.format = ma_format_f32;
		notchConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		notchConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		notchConfig.q = val_number(val_field(pConfig, val_id("q")));
		notchConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		ma_notch_node_config notchNodeConfig;

		notchNodeConfig.nodeConfig = ma_node_config_init();
		notchNodeConfig.notch = notchConfig;

		ma_notch_node *notchNode = new ma_notch_node();

		if (ma_notch_node_init((ma_node_graph *)val_data(pNodeGraph), &notchNodeConfig, NULL, notchNode) != MA_SUCCESS)
		{
			delete notchNode;

			return alloc_null();
		}

		return CFFIPointer(notchNode, gc_ma_notch_node);
	}

	int lime_ma_notch_node_reinit(value pConfig, value pNode)
	{
		ma_notch_config notchConfig;

		notchConfig.format = ma_format_f32;
		notchConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		notchConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		notchConfig.q = val_number(val_field(pConfig, val_id("q")));
		notchConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		return ma_notch_node_reinit(&notchConfig, (ma_notch_node *)val_data(pNode));
	}

	void lime_ma_notch_node_uninit(value pNode)
	{
		ma_notch_node *notchNode = (ma_notch_node *)val_data(pNode);

		if (notchNode)
		{
			ma_notch_node_uninit(notchNode, NULL);

			free_abstract(pNode);

			delete notchNode;
		}
	}

	void gc_ma_peak_node(value handle)
	{
		ma_peak_node *peakNode = (ma_peak_node *)val_data(handle);

		if (peakNode)
		{
			ma_peak_node_uninit(peakNode, NULL);

			delete peakNode;
		}
	}

	value lime_ma_peak_node_init(value pNodeGraph, value pConfig)
	{
		ma_peak_config peakConfig;

		peakConfig.format = ma_format_f32;
		peakConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		peakConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		peakConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		peakConfig.q = val_number(val_field(pConfig, val_id("q")));
		peakConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		ma_peak_node_config peakNodeConfig;

		peakNodeConfig.nodeConfig = ma_node_config_init();
		peakNodeConfig.peak = peakConfig;

		ma_peak_node *peakNode = new ma_peak_node();

		if (ma_peak_node_init((ma_node_graph *)val_data(pNodeGraph), &peakNodeConfig, NULL, peakNode) != MA_SUCCESS)
		{
			delete peakNode;

			return alloc_null();
		}

		return CFFIPointer(peakNode, gc_ma_peak_node);
	}

	int lime_ma_peak_node_reinit(value pConfig, value pNode)
	{
		ma_peak_config peakConfig;

		peakConfig.format = ma_format_f32;
		peakConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		peakConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		peakConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		peakConfig.q = val_number(val_field(pConfig, val_id("q")));
		peakConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		return ma_peak_node_reinit(&peakConfig, (ma_peak_node *)val_data(pNode));
	}

	void lime_ma_peak_node_uninit(value pNode)
	{
		ma_peak_node *peakNode = (ma_peak_node *)val_data(pNode);

		if (peakNode)
		{
			ma_peak_node_uninit(peakNode, NULL);

			free_abstract(pNode);

			delete peakNode;
		}
	}

	void gc_ma_loshelf_node(value handle)
	{
		ma_loshelf_node *loshelfNode = (ma_loshelf_node *)val_data(handle);

		if (loshelfNode)
		{
			ma_loshelf_node_uninit(loshelfNode, NULL);

			delete loshelfNode;
		}
	}

	value lime_ma_loshelf_node_init(value pNodeGraph, value pConfig)
	{
		ma_loshelf_config loshelfConfig;

		loshelfConfig.format = ma_format_f32;
		loshelfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		loshelfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		loshelfConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		loshelfConfig.shelfSlope = val_number(val_field(pConfig, val_id("shelfSlope")));
		loshelfConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		ma_loshelf_node_config loshelfNodeConfig;

		loshelfNodeConfig.nodeConfig = ma_node_config_init();
		loshelfNodeConfig.loshelf = loshelfConfig;

		ma_loshelf_node *loshelfNode = new ma_loshelf_node();

		if (ma_loshelf_node_init((ma_node_graph *)val_data(pNodeGraph), &loshelfNodeConfig, NULL, loshelfNode) != MA_SUCCESS)
		{
			delete loshelfNode;

			return alloc_null();
		}

		return CFFIPointer(loshelfNode, gc_ma_loshelf_node);
	}

	int lime_ma_loshelf_node_reinit(value pConfig, value pNode)
	{
		ma_loshelf_config loshelfConfig;

		loshelfConfig.format = ma_format_f32;
		loshelfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		loshelfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		loshelfConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		loshelfConfig.shelfSlope = val_number(val_field(pConfig, val_id("shelfSlope")));
		loshelfConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		return ma_loshelf_node_reinit(&loshelfConfig, (ma_loshelf_node *)val_data(pNode));
	}

	void lime_ma_loshelf_node_uninit(value pNode)
	{
		ma_loshelf_node *loshelfNode = (ma_loshelf_node *)val_data(pNode);

		if (loshelfNode)
		{
			ma_loshelf_node_uninit(loshelfNode, NULL);

			free_abstract(pNode);

			delete loshelfNode;
		}
	}

	void gc_ma_hishelf_node(value handle)
	{
		ma_hishelf_node *hishelfNode = (ma_hishelf_node *)val_data(handle);

		if (hishelfNode)
		{
			ma_hishelf_node_uninit(hishelfNode, NULL);

			delete hishelfNode;
		}
	}

	value lime_ma_hishelf_node_init(value pNodeGraph, value pConfig)
	{
		ma_hishelf_config hishelfConfig;

		hishelfConfig.format = ma_format_f32;
		hishelfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		hishelfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		hishelfConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		hishelfConfig.shelfSlope = val_number(val_field(pConfig, val_id("shelfSlope")));
		hishelfConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		ma_hishelf_node_config hishelfNodeConfig;

		hishelfNodeConfig.nodeConfig = ma_node_config_init();
		hishelfNodeConfig.hishelf = hishelfConfig;

		ma_hishelf_node *hishelfNode = new ma_hishelf_node();

		if (ma_hishelf_node_init((ma_node_graph *)val_data(pNodeGraph), &hishelfNodeConfig, NULL, hishelfNode) != MA_SUCCESS)
		{
			delete hishelfNode;

			return alloc_null();
		}

		return CFFIPointer(hishelfNode, gc_ma_hishelf_node);
	}

	int lime_ma_hishelf_node_reinit(value pConfig, value pNode)
	{
		ma_hishelf_config hishelfConfig;

		hishelfConfig.format = ma_format_f32;
		hishelfConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		hishelfConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		hishelfConfig.gainDB = val_number(val_field(pConfig, val_id("gainDB")));
		hishelfConfig.shelfSlope = val_number(val_field(pConfig, val_id("shelfSlope")));
		hishelfConfig.frequency = val_number(val_field(pConfig, val_id("frequency")));

		return ma_hishelf_node_reinit(&hishelfConfig, (ma_hishelf_node *)val_data(pNode));
	}

	void lime_ma_hishelf_node_uninit(value pNode)
	{
		ma_hishelf_node *hishelfNode = (ma_hishelf_node *)val_data(pNode);

		if (hishelfNode)
		{
			ma_hishelf_node_uninit(hishelfNode, NULL);

			free_abstract(pNode);

			delete hishelfNode;
		}
	}

	void gc_ma_delay_node(value handle)
	{
		ma_delay_node *delayNode = (ma_delay_node *)val_data(handle);

		if (delayNode)
		{
			ma_delay_node_uninit(delayNode, NULL);

			delete delayNode;
		}
	}

	value lime_ma_delay_node_init(value pNodeGraph, value pConfig)
	{
		ma_delay_config delayConfig;

		delayConfig.channels = val_int(val_field(pConfig, val_id("channels")));
		delayConfig.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		delayConfig.delayInFrames = val_int(val_field(pConfig, val_id("delayInFrames")));
		delayConfig.decay = val_number(val_field(pConfig, val_id("decay")));

		ma_delay_node_config delayNodeConfig;

		delayNodeConfig.nodeConfig = ma_node_config_init();
		delayNodeConfig.delay = delayConfig;

		ma_delay_node *delayNode = new ma_delay_node();

		if (ma_delay_node_init((ma_node_graph *)val_data(pNodeGraph), &delayNodeConfig, NULL, delayNode) != MA_SUCCESS)
		{
			delete delayNode;

			return alloc_null();
		}

		return CFFIPointer(delayNode, gc_ma_delay_node);
	}

	void lime_ma_delay_node_uninit(value pDelayNode)
	{
		ma_delay_node *delayNode = (ma_delay_node *)val_data(pDelayNode);

		if (delayNode)
		{
			ma_delay_node_uninit(delayNode, NULL);

			free_abstract(pDelayNode);

			delete delayNode;
		}
	}

	void lime_ma_delay_node_set_decay(value pDelayNode, double value)
	{
		ma_delay_node_set_decay((ma_delay_node *)val_data(pDelayNode), value);
	}

	double lime_ma_delay_node_get_decay(value pDelayNode)
	{
		return ma_delay_node_get_decay((ma_delay_node *)val_data(pDelayNode));
	}

	void gc_ma_engine(value handle)
	{
		ma_engine *engine = (ma_engine *)val_data(handle);

		if (engine)
		{
			ma_engine_uninit(engine);

			delete engine;
		}
	}

	void lime_ma_engine_process_proc(void *pUserData, float *pFramesOut, ma_uint64 frameCount)
	{
		AutoGCRoot *root = (AutoGCRoot *)pUserData;

		if (root)
		{
			int base = 0;

			gc_set_top_of_stack(&base, true);

			val_call2(root->get(), CFFIPointer(pFramesOut, NULL), alloc_Int64(frameCount));

			gc_set_top_of_stack(0, true);
		}
	}

	value lime_ma_engine_init(value pConfig)
	{
		ma_engine_config config = ma_engine_config_init();

		// WASAPI Device Config
		config.deviceConfig.wasapi.usage = ma_wasapi_usage_games;

		// AAudio Device Config
		config.deviceConfig.aaudio.usage = ma_aaudio_usage_game;
		config.deviceConfig.aaudio.performanceMode = ma_aaudio_performance_mode_low_latency;

		// CoreAudio Device Context Config
		config.deviceConfig.contextConfig.coreaudio.sessionCategory = ma_ios_session_category_playback;
		config.deviceConfig.contextConfig.coreaudio.sessionCategoryOptions = ma_ios_session_category_option_mix_with_others;

		config.pLog = (ma_log *)val_data(val_field(pConfig, val_id("pLog")));
		config.listenerCount = val_int(val_field(pConfig, val_id("listenerCount")));
		config.channels = val_int(val_field(pConfig, val_id("channels")));
		config.sampleRate = val_int(val_field(pConfig, val_id("sampleRate")));
		config.processingSizeInFrames = val_int(val_field(pConfig, val_id("processingSizeInFrames")));
		config.spatializationVolumeSmoothTimeInFrames = val_int(val_field(pConfig, val_id("spatializationVolumeSmoothTimeInFrames")));
		config.spatializationVolumeSmoothTimeInMilliseconds = val_int(val_field(pConfig, val_id("spatializationVolumeSmoothTimeInMilliseconds")));
		config.defaultVolumeSmoothTimeInFrames = val_int(val_field(pConfig, val_id("defaultVolumeSmoothTimeInFrames")));
		config.preMixStackSizeInBytes = val_int(val_field(pConfig, val_id("preMixStackSizeInBytes")));
		config.noAutoStart = val_bool(val_field(pConfig, val_id("noAutoStart")));
		config.noDevice = val_bool(val_field(pConfig, val_id("noDevice")));
		config.noClip = val_bool(val_field(pConfig, val_id("noClip")));

		value onProcess = val_field(pConfig, val_id("onProcess"));

		if (!val_is_null(onProcess))
		{
			config.pProcessUserData = new AutoGCRoot(onProcess);
			config.onProcess = lime_ma_engine_process_proc;
		}

		ma_engine *engine = new ma_engine();

		if (ma_engine_init(&config, engine) != MA_SUCCESS)
		{
			delete engine;

			return alloc_null();
		}

#if defined(IPHONE)
		AVAudioSession *pAudioSession = [AVAudioSession sharedInstance];

		NSError *pError = nil;

		if (@available(iOS 17.0, *))
		{
			if (![pAudioSession setPrefersInterruptionOnRouteDisconnect:false error:&pError])
			{
				ma_log_post_nserror__coreaudio(ma_engine_get_log(engine), MA_LOG_LEVEL_WARNING, "AVAudioSession setPrefersInterruptionOnRouteDisconnect(false)", pError);
				ma_log_post_audio_session__coreaudio(ma_engine_get_log(engine));
			}
			else
			{
				ma_log_postf(ma_engine_get_log(engine), MA_LOG_LEVEL_DEBUG, "[Core Audio] AVAudioSession setPrefersInterruptionOnRouteDisconnect(false) succeeded.");
			}
		}

		if (@available(iOS 14.5, *))
		{
			pError = nil;

			if (![pAudioSession setPrefersNoInterruptionsFromSystemAlerts:true error:&pError])
			{
				ma_log_post_nserror__coreaudio(ma_engine_get_log(engine), MA_LOG_LEVEL_WARNING, "AVAudioSession setPrefersNoInterruptionsFromSystemAlerts(true)", pError);
				ma_log_post_audio_session__coreaudio(ma_engine_get_log(engine));
			}
			else
			{
				ma_log_postf(ma_engine_get_log(engine), MA_LOG_LEVEL_DEBUG, "[Core Audio] AVAudioSession setPrefersNoInterruptionsFromSystemAlerts(true) succeeded.");
			}
		}
#endif

		return CFFIPointer(engine, gc_ma_engine);
	}

	void lime_ma_engine_uninit(value pEngine)
	{
		ma_engine *engine = (ma_engine *)val_data(pEngine);

		if (engine)
		{
			ma_engine_uninit(engine);

			free_abstract(pEngine);

			delete engine;
		}
	}

	value lime_ma_engine_read_pcm_frames(value pEngine, value pFrames, value frameCount)
	{
		ma_uint64 framesRead = 0;

		ma_engine_read_pcm_frames((ma_engine *)val_data(pEngine), (void *)val_data(pFrames), (ma_uint64)val_Int64(frameCount), &framesRead);

		return alloc_Int64(framesRead);
	}

	value lime_ma_engine_get_node_graph(value pEngine)
	{
		return CFFIPointer(ma_engine_get_node_graph((ma_engine *)val_data(pEngine)), NULL);
	}

	value lime_ma_engine_get_log(value pEngine)
	{
		return CFFIPointer(ma_engine_get_log((ma_engine *)val_data(pEngine)), NULL);
	}

	value lime_ma_engine_get_endpoint(value pEngine)
	{
		return CFFIPointer(ma_engine_get_endpoint((ma_engine *)val_data(pEngine)), NULL);
	}

	value lime_ma_engine_get_time_in_pcm_frames(value pEngine)
	{
		return alloc_Int64(ma_engine_get_time_in_pcm_frames((ma_engine *)val_data(pEngine)));
	}

	value lime_ma_engine_get_time_in_milliseconds(value pEngine)
	{
		return alloc_Int64(ma_engine_get_time_in_milliseconds((ma_engine *)val_data(pEngine)));
	}

	int lime_ma_engine_set_time_in_pcm_frames(value pEngine, value globalTime)
	{
		return ma_engine_set_time_in_pcm_frames((ma_engine *)val_data(pEngine), (ma_uint64)val_Int64(globalTime));
	}

	int lime_ma_engine_set_time_in_milliseconds(value pEngine, value globalTime)
	{
		return ma_engine_set_time_in_milliseconds((ma_engine *)val_data(pEngine), (ma_uint64)val_Int64(globalTime));
	}

	int lime_ma_engine_get_channels(value pEngine)
	{
		return ma_engine_get_channels((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_get_sample_rate(value pEngine)
	{
		return ma_engine_get_sample_rate((ma_engine *)val_data(pEngine));
	}

	double lime_ma_engine_get_latency(value pEngine)
	{
		ma_device *device = ma_engine_get_device((ma_engine *)val_data(pEngine));

		if (device == NULL || device->playback.internalSampleRate == 0)
		{
			return 0;
		}

		return (double)device->playback.internalPeriodSizeInFrames * device->playback.internalPeriods * 1000.0 / device->playback.internalSampleRate;
	}

	int lime_ma_engine_start(value pEngine)
	{
		return ma_engine_start((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_stop(value pEngine)
	{
		return ma_engine_stop((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_set_volume(value pEngine, double volume)
	{
		return ma_engine_set_volume((ma_engine *)val_data(pEngine), volume);
	}

	double lime_ma_engine_get_volume(value pEngine)
	{
		return ma_engine_get_volume((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_set_gain_db(value pEngine, double gainDB)
	{
		return ma_engine_set_gain_db((ma_engine *)val_data(pEngine), gainDB);
	}

	double lime_ma_engine_get_gain_db(value pEngine)
	{
		return ma_engine_get_gain_db((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_get_listener_count(value pEngine)
	{
		return ma_engine_get_listener_count((ma_engine *)val_data(pEngine));
	}

	int lime_ma_engine_find_closest_listener(value pEngine, double absolutePosX, double absolutePosY, double absolutePosZ)
	{
		return ma_engine_find_closest_listener((ma_engine *)val_data(pEngine), absolutePosX, absolutePosY, absolutePosZ);
	}

	void lime_ma_engine_listener_set_position(value pEngine, int listenerIndex, double x, double y, double z)
	{
		ma_engine_listener_set_position((ma_engine *)val_data(pEngine), listenerIndex, x, y, z);
	}

	value lime_ma_engine_listener_get_position(value pEngine, int listenerIndex)
	{
		return alloc_Vec3(ma_engine_listener_get_position((ma_engine *)val_data(pEngine), listenerIndex));
	}

	void lime_ma_engine_listener_set_direction(value pEngine, int listenerIndex, double x, double y, double z)
	{
		ma_engine_listener_set_direction((ma_engine *)val_data(pEngine), listenerIndex, x, y, z);
	}

	value lime_ma_engine_listener_get_direction(value pEngine, int listenerIndex)
	{
		return alloc_Vec3(ma_engine_listener_get_direction((ma_engine *)val_data(pEngine), listenerIndex));
	}

	void lime_ma_engine_listener_set_velocity(value pEngine, int listenerIndex, double x, double y, double z)
	{
		ma_engine_listener_set_velocity((ma_engine *)val_data(pEngine), listenerIndex, x, y, z);
	}

	value lime_ma_engine_listener_get_velocity(value pEngine, int listenerIndex)
	{
		return alloc_Vec3(ma_engine_listener_get_velocity((ma_engine *)val_data(pEngine), listenerIndex));
	}

	void lime_ma_engine_listener_set_cone(value pEngine, int listenerIndex, double innerAngleInRadians, double outerAngleInRadians, double outerGain)
	{
		ma_engine_listener_set_cone((ma_engine *)val_data(pEngine), listenerIndex, innerAngleInRadians, outerAngleInRadians, outerGain);
	}

	value lime_ma_engine_listener_get_cone(value pEngine, int listenerIndex)
	{
		ma_vec3f result;

		ma_engine_listener_get_cone((ma_engine *)val_data(pEngine), listenerIndex, &(result.x), &(result.y), &(result.z));

		return alloc_Vec3(result);
	}

	void lime_ma_engine_listener_set_world_up(value pEngine, int listenerIndex, double x, double y, double z)
	{
		ma_engine_listener_set_world_up((ma_engine *)val_data(pEngine), listenerIndex, x, y, z);
	}

	value lime_ma_engine_listener_get_world_up(value pEngine, int listenerIndex)
	{
		return alloc_Vec3(ma_engine_listener_get_world_up((ma_engine *)val_data(pEngine), listenerIndex));
	}

	void lime_ma_engine_listener_set_enabled(value pEngine, int listenerIndex, bool isEnabled)
	{
		ma_engine_listener_set_enabled((ma_engine *)val_data(pEngine), listenerIndex, isEnabled);
	}

	bool lime_ma_engine_listener_is_enabled(value pEngine, int listenerIndex)
	{
		return ma_engine_listener_is_enabled((ma_engine *)val_data(pEngine), listenerIndex);
	}

	struct ma_sound_notifications_gc_roots
	{
		AutoGCRoot *onAtEnd;
		AutoGCRoot *onPreProcess;
		AutoGCRoot *onProcess;
	};

	void ma_sound_notifications_on_at_end(void *pUserData, ma_sound *pSound)
	{
		AutoGCRoot *root = (AutoGCRoot *)(((ma_sound_notifications_gc_roots *)pUserData)->onAtEnd);

		if (root)
		{
			int base = 0;

			gc_set_top_of_stack(&base, true);

			val_call1(root->get(), CFFIPointer(pSound, NULL));

			gc_set_top_of_stack(0, true);
		}
	}

	void ma_sound_notifications_on_pre_process(void *pUserData, ma_sound *pSound, float *pFrames, ma_uint64 frameCount)
	{
		AutoGCRoot *root = (AutoGCRoot *)(((ma_sound_notifications_gc_roots *)pUserData)->onPreProcess);

		if (root)
		{
			int base = 0;

			gc_set_top_of_stack(&base, true);

			val_call3(root->get(), CFFIPointer(pSound, NULL), CFFIPointer(pFrames, NULL), alloc_Int64(frameCount));

			gc_set_top_of_stack(0, true);
		}
	}

	void ma_sound_notifications_on_process(void *pUserData, ma_sound *pSound, float *pFrames, ma_uint64 frameCount)
	{
		AutoGCRoot *root = (AutoGCRoot *)(((ma_sound_notifications_gc_roots *)pUserData)->onProcess);

		if (root)
		{
			int base = 0;

			gc_set_top_of_stack(&base, true);

			val_call3(root->get(), CFFIPointer(pSound, NULL), CFFIPointer(pFrames, NULL), alloc_Int64(frameCount));

			gc_set_top_of_stack(0, true);
		}
	}

	void gc_ma_sound(value handle)
	{
		ma_sound *sound = (ma_sound *)val_data(handle);

		if (sound)
		{
			ma_sound_notifications_gc_roots *gc_roots = (ma_sound_notifications_gc_roots *)sound->notifications.pUserData;

			ma_sound_uninit(sound);

			if (gc_roots)
			{
				if (gc_roots->onAtEnd)
				{
					delete gc_roots->onAtEnd;
				}

				if (gc_roots->onPreProcess)
				{
					delete gc_roots->onPreProcess;
				}

				if (gc_roots->onProcess)
				{
					delete gc_roots->onProcess;
				}

				delete gc_roots;
			}

			delete sound;
		}
	}

	value lime_ma_sound_init(value pEngine, value pConfig)
	{
		ma_engine *engine = (ma_engine *)val_data(pEngine);

		if (!engine)
		{
			return alloc_null();
		}

		ma_sound_config config = ma_sound_config_init(engine);

		config.pDataSource = (ma_data_source *)val_data(val_field(pConfig, val_id("pDataSource")));
		config.pInitialAttachment = (ma_node *)val_data(val_field(pConfig, val_id("pInitialAttachment")));
		config.initialAttachmentInputBusIndex = val_int(val_field(pConfig, val_id("initialAttachmentInputBusIndex")));
		config.flags = val_int(val_field(pConfig, val_id("flags")));
		config.volumeSmoothTimeInPCMFrames = val_int(val_field(pConfig, val_id("volumeSmoothTimeInPCMFrames")));
		config.initialSeekPointInPCMFrames = (ma_uint64)val_Int64(val_field(pConfig, val_id("initialSeekPointInPCMFrames")));

		value rangeBegInPCMFrames = val_field(pConfig, val_id("rangeBegInPCMFrames"));
		value rangeEndInPCMFrames = val_field(pConfig, val_id("rangeEndInPCMFrames"));
		value loopPointBegInPCMFrames = val_field(pConfig, val_id("loopPointBegInPCMFrames"));
		value loopPointEndInPCMFrames = val_field(pConfig, val_id("loopPointEndInPCMFrames"));

		config.rangeBegInPCMFrames = (ma_uint64)val_Int64(rangeBegInPCMFrames);
		config.rangeEndInPCMFrames = val_is_null(rangeEndInPCMFrames) ? ~((ma_uint64)0) : (ma_uint64)val_Int64(rangeEndInPCMFrames);
		config.loopPointBegInPCMFrames = (ma_uint64)val_Int64(loopPointBegInPCMFrames);
		config.loopPointEndInPCMFrames = val_is_null(loopPointEndInPCMFrames) ? ~((ma_uint64)0) : (ma_uint64)val_Int64(loopPointEndInPCMFrames);

		value pNotifications = val_field(pConfig, val_id("pNotifications"));

		ma_sound_notifications notifications;

		ma_sound_notifications_gc_roots *gc_roots = nullptr;

		if (!val_is_null(pNotifications))
		{
			value onAtEnd = val_field(pNotifications, val_id("onAtEnd"));
			value onPreProcess = val_field(pNotifications, val_id("onPreProcess"));
			value onProcess = val_field(pNotifications, val_id("onProcess"));

			if (!val_is_null(onAtEnd) || !val_is_null(onPreProcess) || !val_is_null(onProcess))
			{
				notifications = ma_sound_notifications_init();

				gc_roots = new ma_sound_notifications_gc_roots{nullptr, nullptr};

				if (!val_is_null(onAtEnd))
				{
					notifications.onAtEnd = ma_sound_notifications_on_at_end;

					gc_roots->onAtEnd = new AutoGCRoot(onAtEnd);
				}

				if (!val_is_null(onPreProcess))
				{
					notifications.onPreProcess = ma_sound_notifications_on_pre_process;

					gc_roots->onPreProcess = new AutoGCRoot(onPreProcess);
				}

				if (!val_is_null(onProcess))
				{
					notifications.onProcess = ma_sound_notifications_on_process;

					gc_roots->onProcess = new AutoGCRoot(onProcess);
				}

				notifications.pUserData = gc_roots;

				config.pNotifications = &notifications;
			}
		}

		ma_sound *sound = new ma_sound();

		ma_result result = ma_sound_init_ex(engine, &config, sound);

		if (result != MA_SUCCESS)
		{
			if (gc_roots)
			{
				if (gc_roots->onAtEnd)
				{
					delete gc_roots->onAtEnd;
				}

				if (gc_roots->onPreProcess)
				{
					delete gc_roots->onPreProcess;
				}

				if (gc_roots->onProcess)
				{
					delete gc_roots->onProcess;
				}

				delete gc_roots;
			}

			delete sound;

			return alloc_null();
		}

		return CFFIPointer(sound, gc_ma_sound);
	}

	void lime_ma_sound_uninit(value pSound)
	{
		ma_sound *sound = (ma_sound *)val_data(pSound);

		if (sound)
		{
			ma_sound_notifications_gc_roots *gc_roots = (ma_sound_notifications_gc_roots *)sound->notifications.pUserData;

			ma_sound_uninit(sound);

			if (gc_roots)
			{
				if (gc_roots->onAtEnd)
				{
					delete gc_roots->onAtEnd;
				}

				if (gc_roots->onPreProcess)
				{
					delete gc_roots->onPreProcess;
				}

				if (gc_roots->onProcess)
				{
					delete gc_roots->onProcess;
				}

				delete gc_roots;
			}

			free_abstract(pSound);

			delete sound;
		}
	}

	value lime_ma_sound_get_engine(value pSound)
	{
		return CFFIPointer(ma_sound_get_engine((ma_sound *)val_data(pSound)), NULL);
	}

	value lime_ma_sound_get_data_source(value pSound)
	{
		return CFFIPointer(ma_sound_get_data_source((ma_sound *)val_data(pSound)), NULL);
	}

	int lime_ma_sound_start(value pSound)
	{
		return ma_sound_start((ma_sound *)val_data(pSound));
	}

	int lime_ma_sound_stop(value pSound)
	{
		return ma_sound_stop((ma_sound *)val_data(pSound));
	}

	int lime_ma_sound_stop_with_fade_in_pcm_frames(value pSound, value fadeLength)
	{
		return ma_sound_stop_with_fade_in_pcm_frames((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(fadeLength));
	}

	int lime_ma_sound_stop_with_fade_in_milliseconds(value pSound, value fadeLength)
	{
		return ma_sound_stop_with_fade_in_milliseconds((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(fadeLength));
	}

	void lime_ma_sound_reset_start_time(value pSound)
	{
		ma_sound_reset_start_time((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_reset_stop_time(value pSound)
	{
		ma_sound_reset_stop_time((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_reset_fade(value pSound)
	{
		ma_sound_reset_fade((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_reset_stop_time_and_fade(value pSound)
	{
		ma_sound_reset_stop_time_and_fade((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_volume(value pSound, double volume)
	{
		ma_sound_set_volume((ma_sound *)val_data(pSound), volume);
	}

	double lime_ma_sound_get_volume(value pSound)
	{
		return ma_sound_get_volume((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_pan(value pSound, double pan)
	{
		ma_sound_set_pan((ma_sound *)val_data(pSound), pan);
	}

	double lime_ma_sound_get_pan(value pSound)
	{
		return ma_sound_get_pan((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_pan_mode(value pSound, int panMode)
	{
		ma_sound_set_pan_mode((ma_sound *)val_data(pSound), (ma_pan_mode)panMode);
	}

	int lime_ma_sound_get_pan_mode(value pSound)
	{
		return ma_sound_get_pan_mode((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_pitch(value pSound, double pitch)
	{
		ma_sound_set_pitch((ma_sound *)val_data(pSound), pitch);
	}

	double lime_ma_sound_get_pitch(value pSound)
	{
		return ma_sound_get_pitch((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_spatialization_enabled(value pSound, bool enabled)
	{
		ma_sound_set_spatialization_enabled((ma_sound *)val_data(pSound), enabled);
	}

	bool lime_ma_sound_is_spatialization_enabled(value pSound)
	{
		return ma_sound_is_spatialization_enabled((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_pinned_listener_index(value pSound, int listenerIndex)
	{
		ma_sound_set_pinned_listener_index((ma_sound *)val_data(pSound), listenerIndex);
	}

	int lime_ma_sound_get_pinned_listener_index(value pSound)
	{
		return ma_sound_get_pinned_listener_index((ma_sound *)val_data(pSound));
	}

	int lime_ma_sound_get_listener_index(value pSound)
	{
		return ma_sound_get_listener_index((ma_sound *)val_data(pSound));
	}

	value lime_ma_sound_get_direction_to_listener(value pSound)
	{
		return alloc_Vec3(ma_sound_get_direction_to_listener((ma_sound *)val_data(pSound)));
	}

	void lime_ma_sound_set_position(value pSound, double x, double y, double z)
	{
		ma_sound_set_position((ma_sound *)val_data(pSound), x, y, z);
	}

	value lime_ma_sound_get_position(value pSound)
	{
		return alloc_Vec3(ma_sound_get_position((ma_sound *)val_data(pSound)));
	}

	void lime_ma_sound_set_direction(value pSound, double x, double y, double z)
	{
		ma_sound_set_direction((ma_sound *)val_data(pSound), x, y, z);
	}

	value lime_ma_sound_get_direction(value pSound)
	{
		return alloc_Vec3(ma_sound_get_direction((ma_sound *)val_data(pSound)));
	}

	void lime_ma_sound_set_velocity(value pSound, double x, double y, double z)
	{
		ma_sound_set_velocity((ma_sound *)val_data(pSound), x, y, z);
	}

	value lime_ma_sound_get_velocity(value pSound)
	{
		return alloc_Vec3(ma_sound_get_velocity((ma_sound *)val_data(pSound)));
	}

	void lime_ma_sound_set_attenuation_model(value pSound, int attenuationModel)
	{
		ma_attenuation_model attenuation_model = ma_attenuation_model_none;

		switch (attenuationModel)
		{
			case 1:
				attenuation_model = ma_attenuation_model_inverse;
				break;
			case 2:
				attenuation_model = ma_attenuation_model_linear;
				break;
			case 3:
				attenuation_model = ma_attenuation_model_exponential;
				break;
		}

		ma_sound_set_attenuation_model((ma_sound *)val_data(pSound), attenuation_model, NULL);
	}

	int lime_ma_sound_get_attenuation_model(value pSound)
	{
		ma_attenuation_model attenuation_model = ma_sound_get_attenuation_model((ma_sound *)val_data(pSound));

		if (attenuation_model == ma_attenuation_model_inverse)
		{
			return 1;
		}
		else if (attenuation_model == ma_attenuation_model_linear)
		{
			return 2;
		}
		else if (attenuation_model == ma_attenuation_model_exponential)
		{
			return 3;
		}

		return 0;
	}

	void lime_ma_sound_set_positioning(value pSound, int positioning)
	{
		ma_sound_set_positioning((ma_sound *)val_data(pSound), (ma_positioning)positioning);
	}

	int lime_ma_sound_get_positioning(value pSound)
	{
		return ma_sound_get_positioning((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_rolloff(value pSound, double rolloff)
	{
		ma_sound_set_rolloff((ma_sound *)val_data(pSound), rolloff);
	}

	double lime_ma_sound_get_rolloff(value pSound)
	{
		return ma_sound_get_rolloff((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_min_gain(value pSound, double minGain)
	{
		ma_sound_set_min_gain((ma_sound *)val_data(pSound), minGain);
	}

	double lime_ma_sound_get_min_gain(value pSound)
	{
		return ma_sound_get_min_gain((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_max_gain(value pSound, double maxGain)
	{
		ma_sound_set_max_gain((ma_sound *)val_data(pSound), maxGain);
	}

	double lime_ma_sound_get_max_gain(value pSound)
	{
		return ma_sound_get_max_gain((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_min_distance(value pSound, double minDistance)
	{
		ma_sound_set_min_distance((ma_sound *)val_data(pSound), minDistance);
	}

	double lime_ma_sound_get_min_distance(value pSound)
	{
		return ma_sound_get_min_distance((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_max_distance(value pSound, double maxDistance)
	{
		ma_sound_set_max_distance((ma_sound *)val_data(pSound), maxDistance);
	}

	double lime_ma_sound_get_max_distance(value pSound)
	{
		return ma_sound_get_max_distance((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_cone(value pSound, double innerAngleInRadians, double outerAngleInRadians, double outerGain)
	{
		ma_sound_set_cone((ma_sound *)val_data(pSound), innerAngleInRadians, outerAngleInRadians, outerGain);
	}

	value lime_ma_sound_get_cone(value pSound)
	{
		ma_vec3f result;

		ma_sound_get_cone((ma_sound *)val_data(pSound), &(result.x), &(result.y), &(result.z));

		return alloc_Vec3(result);
	}

	void lime_ma_sound_set_doppler_factor(value pSound, double dopplerFactor)
	{
		ma_sound_set_doppler_factor((ma_sound *)val_data(pSound), dopplerFactor);
	}

	double lime_ma_sound_get_doppler_factor(value pSound)
	{
		return ma_sound_get_doppler_factor((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_directional_attenuation_factor(value pSound, double directionalAttenuationFactor)
	{
		ma_sound_set_directional_attenuation_factor((ma_sound *)val_data(pSound), directionalAttenuationFactor);
	}

	double lime_ma_sound_get_directional_attenuation_factor(value pSound)
	{
		return ma_sound_get_directional_attenuation_factor((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_fade_in_pcm_frames(value pSound, double volumeBeg, double volumeEnd, value fadeLengthInFrames)
	{
		ma_sound_set_fade_in_pcm_frames((ma_sound *)val_data(pSound), volumeBeg, volumeEnd, (ma_uint64)val_Int64(fadeLengthInFrames));
	}

	void lime_ma_sound_set_fade_in_milliseconds(value pSound, double volumeBeg, double volumeEnd, value fadeLengthInMilliseconds)
	{
		ma_sound_set_fade_in_milliseconds((ma_sound *)val_data(pSound), volumeBeg, volumeEnd, (ma_uint64)val_Int64(fadeLengthInMilliseconds));
	}

	void lime_ma_sound_set_fade_start_in_pcm_frames(value pSound, double volumeBeg, double volumeEnd, value fadeLengthInFrames, value absoluteGlobalTimeInFrames)
	{
		ma_sound_set_fade_start_in_pcm_frames((ma_sound *)val_data(pSound), volumeBeg, volumeEnd, (ma_uint64)val_Int64(fadeLengthInFrames), (ma_uint64)val_Int64(absoluteGlobalTimeInFrames));
	}

	void lime_ma_sound_set_fade_start_in_milliseconds(value pSound, double volumeBeg, double volumeEnd, value fadeLengthInMilliseconds, value absoluteGlobalTimeInMilliseconds)
	{
		ma_sound_set_fade_start_in_milliseconds((ma_sound *)val_data(pSound), volumeBeg, volumeEnd, (ma_uint64)val_Int64(fadeLengthInMilliseconds), (ma_uint64)val_Int64(absoluteGlobalTimeInMilliseconds));
	}

	double lime_ma_sound_get_current_fade_volume(value pSound)
	{
		return ma_sound_get_current_fade_volume((ma_sound *)val_data(pSound));
	}

	void lime_ma_sound_set_start_time_in_pcm_frames(value pSound, value absoluteGlobalTimeInFrames)
	{
		ma_sound_set_start_time_in_pcm_frames((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(absoluteGlobalTimeInFrames));
	}

	void lime_ma_sound_set_start_time_in_milliseconds(value pSound, value absoluteGlobalTimeInMilliseconds)
	{
		ma_sound_set_start_time_in_milliseconds((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(absoluteGlobalTimeInMilliseconds));
	}

	void lime_ma_sound_set_stop_time_in_pcm_frames(value pSound, value absoluteGlobalTimeInFrames)
	{
		ma_sound_set_stop_time_in_pcm_frames((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(absoluteGlobalTimeInFrames));
	}

	void lime_ma_sound_set_stop_time_in_milliseconds(value pSound, value absoluteGlobalTimeInMilliseconds)
	{
		ma_sound_set_stop_time_in_milliseconds((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(absoluteGlobalTimeInMilliseconds));
	}

	void lime_ma_sound_set_stop_time_with_fade_in_pcm_frames(value pSound, value stopAbsoluteGlobalTimeInFrames, value fadeLengthInFrames)
	{
		ma_sound_set_stop_time_with_fade_in_pcm_frames((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(stopAbsoluteGlobalTimeInFrames), (ma_uint64)val_Int64(fadeLengthInFrames));
	}

	void lime_ma_sound_set_stop_time_with_fade_in_milliseconds(value pSound, value stopAbsoluteGlobalTimeInMilliseconds, value fadeLengthInMilliseconds)
	{
		ma_sound_set_stop_time_with_fade_in_milliseconds((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(stopAbsoluteGlobalTimeInMilliseconds), (ma_uint64)val_Int64(fadeLengthInMilliseconds));
	}

	bool lime_ma_sound_is_playing(value pSound)
	{
		return ma_sound_is_playing((ma_sound *)val_data(pSound));
	}

	value lime_ma_sound_get_time_in_pcm_frames(value pSound)
	{
		return alloc_Int64(ma_sound_get_time_in_pcm_frames((ma_sound *)val_data(pSound)));
	}

	value lime_ma_sound_get_time_in_milliseconds(value pSound)
	{
		return alloc_Int64(ma_sound_get_time_in_milliseconds((ma_sound *)val_data(pSound)));
	}

	void lime_ma_sound_set_looping(value pSound, bool isLooping)
	{
		ma_sound_set_looping((ma_sound *)val_data(pSound), isLooping);
	}

	bool lime_ma_sound_is_looping(value pSound)
	{
		return ma_sound_is_looping((ma_sound *)val_data(pSound));
	}

	bool lime_ma_sound_at_end(value pSound)
	{
		return ma_sound_at_end((ma_sound *)val_data(pSound));
	}

	int lime_ma_sound_seek_to_pcm_frame(value pSound, value frameIndex)
	{
		return ma_sound_seek_to_pcm_frame((ma_sound *)val_data(pSound), (ma_uint64)val_Int64(frameIndex));
	}

	int lime_ma_sound_seek_to_second(value pSound, double seekPointInSeconds)
	{
		return ma_sound_seek_to_second((ma_sound *)val_data(pSound), seekPointInSeconds);
	}

	value lime_ma_sound_get_data_format(value pSound)
	{
		ma_format format;
		ma_uint32 channels;
		ma_uint32 sampleRate;
		ma_channel channelMap[MA_MAX_CHANNELS];

		if (ma_sound_get_data_format((ma_sound *)val_data(pSound), &format, &channels, &sampleRate, channelMap, MA_MAX_CHANNELS) != MA_SUCCESS)
		{
			return alloc_null();
		}

		value data_format = alloc_empty_object();

		alloc_field(data_format, val_id("format"), alloc_int(format));
		alloc_field(data_format, val_id("channels"), alloc_int(channels));
		alloc_field(data_format, val_id("sampleRate"), alloc_int(sampleRate));

		value jChannelMap = alloc_array(channels);

		for (ma_uint32 i = 0; i < channels; i++)
		{
			val_array_set_i(jChannelMap, i, alloc_int(channelMap[i]));
		}

		alloc_field(data_format, val_id("channelMap"), jChannelMap);

		return data_format;
	}

	value lime_ma_sound_get_cursor_in_pcm_frames(value pSound)
	{
		ma_uint64 cursor = 0;

		ma_sound_get_cursor_in_pcm_frames((ma_sound *)val_data(pSound), &cursor);

		return alloc_Int64(cursor);
	}

	value lime_ma_sound_get_length_in_pcm_frames(value pSound)
	{
		ma_uint64 length = 0;

		ma_sound_get_length_in_pcm_frames((ma_sound *)val_data(pSound), &length);

		return alloc_Int64(length);
	}

	double lime_ma_sound_get_cursor_in_seconds(value pSound)
	{
		float cursor = 0.0f;

		ma_sound_get_cursor_in_seconds((ma_sound *)val_data(pSound), &cursor);

		return cursor;
	}

	double lime_ma_sound_get_length_in_seconds(value pSound)
	{
		float length = 0.0f;

		ma_sound_get_length_in_seconds((ma_sound *)val_data(pSound), &length);

		return length;
	}

	value lime_ma_get_format_name(int format)
	{
		return alloc_string(ma_get_format_name((ma_format)format));
	}

	int lime_ma_get_bytes_per_sample(int format)
	{
		return ma_get_bytes_per_sample((ma_format)format);
	}

	int lime_ma_get_bytes_per_frame(int format, int channels)
	{
		return ma_get_bytes_per_frame((ma_format)format, channels);
	}

	value lime_ma_log_level_to_string(int logLevel)
	{
		return alloc_string(ma_log_level_to_string(logLevel));
	}

	DEFINE_PRIME0(lime_ma_log_init);
	DEFINE_PRIME1v(lime_ma_log_uninit);
	DEFINE_PRIME2(lime_ma_log_register_callback);
	DEFINE_PRIME2(lime_ma_log_unregister_callback);
	DEFINE_PRIME3(lime_ma_log_post);
	DEFINE_PRIME2(lime_ma_decoder_init_file);
	DEFINE_PRIME2(lime_ma_decoder_init_memory);
	DEFINE_PRIME1v(lime_ma_decoder_uninit);
	DEFINE_PRIME3(lime_ma_decoder_read_pcm_frames);
	DEFINE_PRIME2(lime_ma_decoder_seek_to_pcm_frame);
	DEFINE_PRIME1(lime_ma_decoder_get_data_format);
	DEFINE_PRIME1(lime_ma_decoder_get_cursor_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_decoder_get_length_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_decoder_get_available_frames);
	DEFINE_PRIME1(lime_ma_audio_buffer_init);
	DEFINE_PRIME1(lime_ma_audio_buffer_init_and_copy_data);
	DEFINE_PRIME1v(lime_ma_audio_buffer_uninit);
	DEFINE_PRIME3(lime_ma_audio_buffer_read_pcm_frames);
	DEFINE_PRIME2(lime_ma_audio_buffer_seek_to_pcm_frame);
	DEFINE_PRIME3(lime_ma_audio_buffer_map);
	DEFINE_PRIME2(lime_ma_audio_buffer_unmap);
	DEFINE_PRIME1(lime_ma_audio_buffer_at_end);
	DEFINE_PRIME1(lime_ma_audio_buffer_get_cursor_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_audio_buffer_get_length_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_audio_buffer_get_available_frames);
	DEFINE_PRIME1(lime_ma_audio_ring_buffer_init);
	DEFINE_PRIME1v(lime_ma_audio_ring_buffer_uninit);
	DEFINE_PRIME3(lime_ma_audio_ring_buffer_map_produce);
	DEFINE_PRIME2v(lime_ma_audio_ring_buffer_unmap_produce);
	DEFINE_PRIME3(lime_ma_audio_ring_buffer_map_consume);
	DEFINE_PRIME2v(lime_ma_audio_ring_buffer_unmap_consume);
	DEFINE_PRIME3(lime_ma_audio_ring_buffer_write_pcm_frames);
	DEFINE_PRIME3(lime_ma_audio_ring_buffer_read_pcm_frames);
	DEFINE_PRIME1(lime_ma_audio_ring_buffer_get_length_in_pcm_frames);
	DEFINE_PRIME4(lime_ma_node_attach_output_bus);
	DEFINE_PRIME2(lime_ma_node_detach_output_bus);
	DEFINE_PRIME1(lime_ma_node_detach_all_output_buses);
	DEFINE_PRIME2(lime_ma_biquad_node_init);
	DEFINE_PRIME2(lime_ma_biquad_node_reinit);
	DEFINE_PRIME1v(lime_ma_biquad_node_uninit);
	DEFINE_PRIME2(lime_ma_lpf_node_init);
	DEFINE_PRIME2(lime_ma_lpf_node_reinit);
	DEFINE_PRIME1v(lime_ma_lpf_node_uninit);
	DEFINE_PRIME2(lime_ma_hpf_node_init);
	DEFINE_PRIME2(lime_ma_hpf_node_reinit);
	DEFINE_PRIME1v(lime_ma_hpf_node_uninit);
	DEFINE_PRIME2(lime_ma_bpf_node_init);
	DEFINE_PRIME2(lime_ma_bpf_node_reinit);
	DEFINE_PRIME1v(lime_ma_bpf_node_uninit);
	DEFINE_PRIME2(lime_ma_notch_node_init);
	DEFINE_PRIME2(lime_ma_notch_node_reinit);
	DEFINE_PRIME1v(lime_ma_notch_node_uninit);
	DEFINE_PRIME2(lime_ma_peak_node_init);
	DEFINE_PRIME2(lime_ma_peak_node_reinit);
	DEFINE_PRIME1v(lime_ma_peak_node_uninit);
	DEFINE_PRIME2(lime_ma_loshelf_node_init);
	DEFINE_PRIME2(lime_ma_loshelf_node_reinit);
	DEFINE_PRIME1v(lime_ma_loshelf_node_uninit);
	DEFINE_PRIME2(lime_ma_hishelf_node_init);
	DEFINE_PRIME2(lime_ma_hishelf_node_reinit);
	DEFINE_PRIME1v(lime_ma_hishelf_node_uninit);
	DEFINE_PRIME2(lime_ma_delay_node_init);
	DEFINE_PRIME1v(lime_ma_delay_node_uninit);
	DEFINE_PRIME2v(lime_ma_delay_node_set_decay);
	DEFINE_PRIME1(lime_ma_delay_node_get_decay);
	DEFINE_PRIME1(lime_ma_engine_init);
	DEFINE_PRIME1v(lime_ma_engine_uninit);
	DEFINE_PRIME3(lime_ma_engine_read_pcm_frames);
	DEFINE_PRIME1(lime_ma_engine_get_node_graph);
	DEFINE_PRIME1(lime_ma_engine_get_log);
	DEFINE_PRIME1(lime_ma_engine_get_endpoint);
	DEFINE_PRIME1(lime_ma_engine_get_time_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_engine_get_time_in_milliseconds);
	DEFINE_PRIME2(lime_ma_engine_set_time_in_pcm_frames);
	DEFINE_PRIME2(lime_ma_engine_set_time_in_milliseconds);
	DEFINE_PRIME1(lime_ma_engine_get_channels);
	DEFINE_PRIME1(lime_ma_engine_get_sample_rate);
	DEFINE_PRIME1(lime_ma_engine_get_latency);
	DEFINE_PRIME1(lime_ma_engine_start);
	DEFINE_PRIME1(lime_ma_engine_stop);
	DEFINE_PRIME2(lime_ma_engine_set_volume);
	DEFINE_PRIME1(lime_ma_engine_get_volume);
	DEFINE_PRIME2(lime_ma_engine_set_gain_db);
	DEFINE_PRIME1(lime_ma_engine_get_gain_db);
	DEFINE_PRIME1(lime_ma_engine_get_listener_count);
	DEFINE_PRIME4(lime_ma_engine_find_closest_listener);
	DEFINE_PRIME5v(lime_ma_engine_listener_set_position);
	DEFINE_PRIME2(lime_ma_engine_listener_get_position);
	DEFINE_PRIME5v(lime_ma_engine_listener_set_direction);
	DEFINE_PRIME2(lime_ma_engine_listener_get_direction);
	DEFINE_PRIME5v(lime_ma_engine_listener_set_velocity);
	DEFINE_PRIME2(lime_ma_engine_listener_get_velocity);
	DEFINE_PRIME5v(lime_ma_engine_listener_set_cone);
	DEFINE_PRIME2(lime_ma_engine_listener_get_cone);
	DEFINE_PRIME5v(lime_ma_engine_listener_set_world_up);
	DEFINE_PRIME2(lime_ma_engine_listener_get_world_up);
	DEFINE_PRIME3v(lime_ma_engine_listener_set_enabled);
	DEFINE_PRIME2(lime_ma_engine_listener_is_enabled);
	DEFINE_PRIME2(lime_ma_sound_init);
	DEFINE_PRIME1v(lime_ma_sound_uninit);
	DEFINE_PRIME1(lime_ma_sound_get_engine);
	DEFINE_PRIME1(lime_ma_sound_get_data_source);
	DEFINE_PRIME1(lime_ma_sound_start);
	DEFINE_PRIME1(lime_ma_sound_stop);
	DEFINE_PRIME2(lime_ma_sound_stop_with_fade_in_pcm_frames);
	DEFINE_PRIME2(lime_ma_sound_stop_with_fade_in_milliseconds);
	DEFINE_PRIME1v(lime_ma_sound_reset_start_time);
	DEFINE_PRIME1v(lime_ma_sound_reset_stop_time);
	DEFINE_PRIME1v(lime_ma_sound_reset_fade);
	DEFINE_PRIME1v(lime_ma_sound_reset_stop_time_and_fade);
	DEFINE_PRIME2v(lime_ma_sound_set_volume);
	DEFINE_PRIME1(lime_ma_sound_get_volume);
	DEFINE_PRIME2v(lime_ma_sound_set_pan);
	DEFINE_PRIME1(lime_ma_sound_get_pan);
	DEFINE_PRIME2v(lime_ma_sound_set_pan_mode);
	DEFINE_PRIME1(lime_ma_sound_get_pan_mode);
	DEFINE_PRIME2v(lime_ma_sound_set_pitch);
	DEFINE_PRIME1(lime_ma_sound_get_pitch);
	DEFINE_PRIME2v(lime_ma_sound_set_spatialization_enabled);
	DEFINE_PRIME1(lime_ma_sound_is_spatialization_enabled);
	DEFINE_PRIME2v(lime_ma_sound_set_pinned_listener_index);
	DEFINE_PRIME1(lime_ma_sound_get_pinned_listener_index);
	DEFINE_PRIME1(lime_ma_sound_get_listener_index);
	DEFINE_PRIME1(lime_ma_sound_get_direction_to_listener);
	DEFINE_PRIME4v(lime_ma_sound_set_position);
	DEFINE_PRIME1(lime_ma_sound_get_position);
	DEFINE_PRIME4v(lime_ma_sound_set_direction);
	DEFINE_PRIME1(lime_ma_sound_get_direction);
	DEFINE_PRIME4v(lime_ma_sound_set_velocity);
	DEFINE_PRIME1(lime_ma_sound_get_velocity);
	DEFINE_PRIME2v(lime_ma_sound_set_attenuation_model);
	DEFINE_PRIME1(lime_ma_sound_get_attenuation_model);
	DEFINE_PRIME2v(lime_ma_sound_set_positioning);
	DEFINE_PRIME1(lime_ma_sound_get_positioning);
	DEFINE_PRIME2v(lime_ma_sound_set_rolloff);
	DEFINE_PRIME1(lime_ma_sound_get_rolloff);
	DEFINE_PRIME2v(lime_ma_sound_set_min_gain);
	DEFINE_PRIME1(lime_ma_sound_get_min_gain);
	DEFINE_PRIME2v(lime_ma_sound_set_max_gain);
	DEFINE_PRIME1(lime_ma_sound_get_max_gain);
	DEFINE_PRIME2v(lime_ma_sound_set_min_distance);
	DEFINE_PRIME1(lime_ma_sound_get_min_distance);
	DEFINE_PRIME2v(lime_ma_sound_set_max_distance);
	DEFINE_PRIME1(lime_ma_sound_get_max_distance);
	DEFINE_PRIME4v(lime_ma_sound_set_cone);
	DEFINE_PRIME1(lime_ma_sound_get_cone);
	DEFINE_PRIME2v(lime_ma_sound_set_doppler_factor);
	DEFINE_PRIME1(lime_ma_sound_get_doppler_factor);
	DEFINE_PRIME2v(lime_ma_sound_set_directional_attenuation_factor);
	DEFINE_PRIME1(lime_ma_sound_get_directional_attenuation_factor);
	DEFINE_PRIME4v(lime_ma_sound_set_fade_in_pcm_frames);
	DEFINE_PRIME4v(lime_ma_sound_set_fade_in_milliseconds);
	DEFINE_PRIME5v(lime_ma_sound_set_fade_start_in_pcm_frames);
	DEFINE_PRIME5v(lime_ma_sound_set_fade_start_in_milliseconds);
	DEFINE_PRIME1(lime_ma_sound_get_current_fade_volume);
	DEFINE_PRIME2v(lime_ma_sound_set_start_time_in_pcm_frames);
	DEFINE_PRIME2v(lime_ma_sound_set_start_time_in_milliseconds);
	DEFINE_PRIME2v(lime_ma_sound_set_stop_time_in_pcm_frames);
	DEFINE_PRIME2v(lime_ma_sound_set_stop_time_in_milliseconds);
	DEFINE_PRIME3v(lime_ma_sound_set_stop_time_with_fade_in_pcm_frames);
	DEFINE_PRIME3v(lime_ma_sound_set_stop_time_with_fade_in_milliseconds);
	DEFINE_PRIME1(lime_ma_sound_is_playing);
	DEFINE_PRIME1(lime_ma_sound_get_time_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_sound_get_time_in_milliseconds);
	DEFINE_PRIME2v(lime_ma_sound_set_looping);
	DEFINE_PRIME1(lime_ma_sound_is_looping);
	DEFINE_PRIME1(lime_ma_sound_at_end);
	DEFINE_PRIME2(lime_ma_sound_seek_to_pcm_frame);
	DEFINE_PRIME2(lime_ma_sound_seek_to_second);
	DEFINE_PRIME1(lime_ma_sound_get_data_format);
	DEFINE_PRIME1(lime_ma_sound_get_cursor_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_sound_get_length_in_pcm_frames);
	DEFINE_PRIME1(lime_ma_sound_get_cursor_in_seconds);
	DEFINE_PRIME1(lime_ma_sound_get_length_in_seconds);
	DEFINE_PRIME1(lime_ma_get_format_name);
	DEFINE_PRIME1(lime_ma_get_bytes_per_sample);
	DEFINE_PRIME2(lime_ma_get_bytes_per_frame);
	DEFINE_PRIME1(lime_ma_log_level_to_string);

} // namespace lime

extern "C" int lime_ma_register_prims()
{
	return 0;
}
