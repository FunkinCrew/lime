#define MINIAUDIO_IMPLEMENTATION
#include <miniaudio.h>
#include <miniaudio_libopus.h>
#include <miniaudio_libvorbis.h>

#include <utils/File.h>
#include <utils/Bytes.h>

#include <hx/CFFI.h>

#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>
#include <memory.h>

namespace lime {

    #define ENGINE_VECTOR_STARTING_CAPACITY 4
    #define SOUND_VECTOR_STARTING_CAPACITY 32

    typedef enum {
        MA_BACKEND_SOUND_DATA_SOURCE_TYPE_INTERNAL = 0, // the data source is managed internally by miniaudio (this happens when we init from a file)
        MA_BACKEND_SOUND_DATA_SOURCE_TYPE_DECODER = 1,
        MA_BACKEND_SOUND_DATA_SOURCE_TYPE_AUDIO_BUFFER = 2
    } MABackendSoundDataSourceType;

    typedef struct {
        uint32_t soundIndex;
    } MABackendEndCallbackData;

    typedef struct {
        ma_resource_manager resourceManager;
        ma_engine engine;
        bool locked;
    } MABackendEngine;

    typedef struct {
        float stopTime;
        int32_t loops;
        MABackendEndCallbackData endCallbackData;
        ma_sound sound;
        MABackendSoundDataSourceType dataSourceType;
        union {
            ma_decoder decoder;
            ma_audio_buffer audioBuffer;
        } dataSource;
        bool locked;
    } MABackendSound;

    typedef struct {
        uint32_t capacity;

        void* ptr;
    } Vector;

    Vector engineVector = {0, NULL};
    Vector soundVector = {0, NULL};

    static inline void vec_expand(Vector* vec, uint32_t elementSize) {
        uint32_t initialCapacity = vec->capacity;
        vec->capacity *= 2;

        vec->ptr = realloc(vec->ptr, elementSize * vec->capacity);

        memset(((uint8_t*)vec->ptr) + initialCapacity * elementSize, 0, (vec->capacity - initialCapacity) * elementSize);
    }

    #define vec_access(vec, type, idx) ((type*)vec.ptr)[idx]

    #define vec_get_unlocked(vec, type, out) { \
            out = ~0U; \
            for (uint32_t i = 0; i < vec.capacity; i++) { \
                if (!vec_access(vec, type, i).locked) { \
                    out = i; \
                    break; \
                } \
            } \
            if (out == ~0U) { \
                out = vec.capacity; \
                vec_expand(&vec, sizeof(type)); \
            } \
        }
    
    ma_result ma_File_onOpen(ma_vfs* pVFS, const char* pFilePath, ma_uint32 openMode, ma_vfs_file* pFile) {
        if (openMode & MA_OPEN_MODE_READ) {
            if (openMode & MA_OPEN_MODE_WRITE) 
                *pFile = File(pFilePath, "rb+").handle;
            else *pFile = File(pFilePath, "rb").handle;
        } else if (openMode & MA_OPEN_MODE_WRITE)
            *pFile = File(pFilePath, "wb").handle;

        if (!(*pFile)) return MA_IO_ERROR;

        return MA_SUCCESS;
    }

    ma_result ma_File_onClose(ma_vfs* pVFS, ma_vfs_file file) {
        File f(file);
        f.Close();

        return MA_SUCCESS;
    }

    ma_result ma_File_onRead(ma_vfs* pVFS, ma_vfs_file file, void* pDst, size_t sizeInBytes, size_t* pBytesRead) {
        File f(file);
        *pBytesRead = f.Read(pDst, sizeInBytes);

        if (*pBytesRead < sizeInBytes) return MA_AT_END;

        return MA_SUCCESS;
    }

    ma_result ma_File_onWrite(ma_vfs* pVFS, ma_vfs_file file, const void* pSrc, size_t sizeInBytes, size_t* pBytesWritten) {
        File f(file);
        *pBytesWritten = f.Write(pSrc, sizeInBytes);

        if (*pBytesWritten < sizeInBytes) return MA_IO_ERROR;

        return MA_SUCCESS;
    }

    ma_result ma_File_onSeek(ma_vfs* pVFS, ma_vfs_file file, ma_int64 offset, ma_seek_origin origin) {
        File f(file);

        int corigin;

        switch (origin) {
            case ma_seek_origin_start:
                corigin = SEEK_SET;
                break;
            case ma_seek_origin_end:
                corigin = SEEK_END;
                break;
            case ma_seek_origin_current:
                corigin = SEEK_CUR;
                break;
        }

        if (f.Seek(offset, corigin) == -1) return MA_IO_ERROR;

        return MA_SUCCESS;
    }

    ma_result ma_File_onTell(ma_vfs* pVFS, ma_vfs_file file, ma_int64* pCursor) {
        File f(file);

        *pCursor = f.Tell();

        if (*pCursor == -1) return MA_IO_ERROR;

        return MA_SUCCESS;
    }

    ma_result ma_File_onInfo(ma_vfs* pVFS, ma_vfs_file file, ma_file_info* pInfo) {
        File f(file);

        uint64_t current = f.Tell();

        if (f.Seek(0, SEEK_END) == -1) return MA_IO_ERROR;

        pInfo->sizeInBytes = f.Tell();

        if (pInfo->sizeInBytes == -1) return MA_IO_ERROR;

        if (f.Seek(current == -1 ? 0 : current, SEEK_SET) == -1) return MA_IO_ERROR;

        return MA_SUCCESS;
    }

    ma_vfs_callbacks vfscb;

    ma_decoding_backend_vtable* pCustomDecodingBackends[] = {
        ma_decoding_backend_libvorbis,
        ma_decoding_backend_libopus
    };

    void miniaudio_backend_sound_end_callback(void* pUserData, ma_sound* pSound) {
        MABackendEndCallbackData* endCallbackData = (MABackendEndCallbackData*)pUserData;

        if (vec_access(soundVector, MABackendSound, endCallbackData->soundIndex).loops < 1) {
            ma_sound_stop(pSound);
        } else {
            vec_access(soundVector, MABackendSound, endCallbackData->soundIndex).loops--;
            ma_sound_start(pSound);
        }
    }

    void miniaudio_backend_init() {
        engineVector.capacity = ENGINE_VECTOR_STARTING_CAPACITY;
        engineVector.ptr = malloc(sizeof(MABackendEngine) * ENGINE_VECTOR_STARTING_CAPACITY);
        soundVector.capacity = SOUND_VECTOR_STARTING_CAPACITY;
        soundVector.ptr = malloc(sizeof(MABackendSound) * SOUND_VECTOR_STARTING_CAPACITY);

        memset(((uint8_t*)engineVector.ptr), 0, sizeof(MABackendEngine) * ENGINE_VECTOR_STARTING_CAPACITY);
        memset(((uint8_t*)soundVector.ptr), 0, sizeof(MABackendSound) * SOUND_VECTOR_STARTING_CAPACITY);

        vfscb.onOpen = ma_File_onOpen;
        vfscb.onClose = ma_File_onClose;
        vfscb.onRead = ma_File_onRead;
        vfscb.onWrite = ma_File_onWrite;
        vfscb.onSeek = ma_File_onSeek;
        vfscb.onTell = ma_File_onTell;
        vfscb.onInfo = ma_File_onInfo;
    }

    void miniaudio_backend_uninit() {
        free(soundVector.ptr);
        free(engineVector.ptr);
    }

    int32_t miniaudio_backend_engine_init(uint32_t sampleRate, uint32_t channels, uint32_t periodSizeInFrames, uint32_t gainSmoothTimeInFrames) {
        uint32_t unlockedIndex;
        vec_get_unlocked(engineVector, MABackendEngine, unlockedIndex);

        ma_resource_manager_config rmConfig = ma_resource_manager_config_init();
        rmConfig.ppCustomDecodingBackendVTables = pCustomDecodingBackends;
        rmConfig.customDecodingBackendCount = 2;
        rmConfig.pVFS = &vfscb;

        if (ma_resource_manager_init(&rmConfig, &vec_access(engineVector, MABackendEngine, unlockedIndex).resourceManager) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to initialize an ma_resource_manager\n");
            return -1;
        }

        ma_engine_config engineConfig = ma_engine_config_init();
        engineConfig.sampleRate = sampleRate;
        engineConfig.channels = channels;
        engineConfig.periodSizeInFrames = periodSizeInFrames;
        engineConfig.gainSmoothTimeInFrames = gainSmoothTimeInFrames;
        engineConfig.pResourceManager = &vec_access(engineVector, MABackendEngine, unlockedIndex).resourceManager;

        if (ma_engine_init(&engineConfig, &vec_access(engineVector, MABackendEngine, unlockedIndex).engine) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to initialize an ma_engine\n");
            return -1;
        }

        vec_access(engineVector, MABackendEngine, unlockedIndex).locked = true;

        return unlockedIndex;
    }

    void miniaudio_backend_engine_uninit(uint32_t engineIndex) {
        ma_engine_uninit(&vec_access(engineVector, MABackendEngine, engineIndex).engine);
        ma_resource_manager_uninit(&vec_access(engineVector, MABackendEngine, engineIndex).resourceManager);
        vec_access(engineVector, MABackendEngine, engineIndex).locked = false;
    }

    void miniaudio_backend_engine_start(uint32_t engineIndex) {
        if (ma_engine_start(&vec_access(engineVector, MABackendEngine, engineIndex).engine) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed start an ma_engine with index %d\n", engineIndex);
        }
    }

    void miniaudio_backend_engine_stop(uint32_t engineIndex) {
        if (ma_engine_stop(&vec_access(engineVector, MABackendEngine, engineIndex).engine) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed stop an ma_engine with index %d\n", engineIndex);
        }
    }

    int32_t miniaudio_backend_sound_init_from_file(uint32_t engineIndex, float offset, const char* path) {
        uint32_t unlockedIndex;
        vec_get_unlocked(soundVector, MABackendSound, unlockedIndex);

        if (ma_sound_init_from_file(&vec_access(engineVector, MABackendEngine, engineIndex).engine, path, MA_SOUND_FLAG_STREAM, NULL, NULL, &vec_access(soundVector, MABackendSound, unlockedIndex).sound) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to initialize an ma_sound at path %s\n", path);
            return -1;
        }

        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", unlockedIndex);
            sampleRate = 0;
        }

        uint64_t frameOffset = offset * sampleRate / 1000;

        if (ma_sound_seek_to_pcm_frame(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, frameOffset) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to seek an ma_sound with index %d to pcm frame offset %I64d\n", unlockedIndex, frameOffset);
        }

        vec_access(soundVector, MABackendSound, unlockedIndex).dataSourceType = MA_BACKEND_SOUND_DATA_SOURCE_TYPE_INTERNAL;
        vec_access(soundVector, MABackendSound, unlockedIndex).stopTime = 0;
        vec_access(soundVector, MABackendSound, unlockedIndex).loops = 0;
        vec_access(soundVector, MABackendSound, unlockedIndex).endCallbackData = {unlockedIndex};
        vec_access(soundVector, MABackendSound, unlockedIndex).locked = true;

        if (ma_sound_set_end_callback(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, miniaudio_backend_sound_end_callback, &vec_access(soundVector, MABackendSound, unlockedIndex).endCallbackData) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to the end callback for an ma_sound with index %d\n", unlockedIndex);
        }

        return unlockedIndex;
    }

    int32_t miniaudio_backend_sound_init_from_bytes(uint32_t engineIndex, float offset, bool stream, value bytes) {
        uint32_t unlockedIndex;
        vec_get_unlocked(soundVector, MABackendSound, unlockedIndex);

        ma_data_source* pDataSource = NULL;

        if (stream) {
            ma_decoder_config decoderConfig = ma_decoder_config_init(ma_format_unknown, 0, 0);

            decoderConfig.ppCustomBackendVTables = pCustomDecodingBackends;
            decoderConfig.customBackendCount = 2;

            if (ma_decoder_init_memory(buffer_data(val_to_buffer(bytes)), val_array_size(bytes), &decoderConfig, &vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.decoder) != MA_SUCCESS) {
                fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to create an ma_decoder for bytes\n");
                return -1;
            }

            pDataSource = &vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.decoder;
            vec_access(soundVector, MABackendSound, unlockedIndex).dataSourceType = MA_BACKEND_SOUND_DATA_SOURCE_TYPE_DECODER;
        } else {
            ma_decoder_config decoderConfig = ma_decoder_config_init(ma_format_unknown, 0, 0);

            decoderConfig.ppCustomBackendVTables = pCustomDecodingBackends;
            decoderConfig.customBackendCount = 2;

            uint64_t pcmFrameCount;
            void* pPcmFrames;

            // we cant avoid allocating memory here, creating a lot of non-streamed sounds is not intended
            if (ma_decode_memory(buffer_data(val_to_buffer(bytes)), val_array_size(bytes), &decoderConfig, &pcmFrameCount, &pPcmFrames) != MA_SUCCESS) {
                fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to decode bytes when creating a non-streamed ma_sound\n");
                return -1;
            }

            ma_audio_buffer_config audioBufferConfig = ma_audio_buffer_config_init(decoderConfig.format, decoderConfig.channels, pcmFrameCount, pPcmFrames, NULL);
            audioBufferConfig.sampleRate = decoderConfig.sampleRate; // miniaudio dev, why is this not an argument of ma_audio_buffer_config_init?

            if (ma_audio_buffer_init(&audioBufferConfig, &vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.audioBuffer) != MA_SUCCESS) {
                fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to an ma_audio_buffer for decoded bytes\n");
            }

            vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.audioBuffer.ownsData = MA_TRUE; // hijack this so that the audio buffer will free the memory allocated in ma_decode_memory

            pDataSource = &vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.audioBuffer;
            vec_access(soundVector, MABackendSound, unlockedIndex).dataSourceType = MA_BACKEND_SOUND_DATA_SOURCE_TYPE_AUDIO_BUFFER;
        }

        // note that MA_SOUND_FLAG_STREAM is useless here, as it is a resource manager flag, ma_decoder does streaming automatically
        if (ma_sound_init_from_data_source(&vec_access(engineVector, MABackendEngine, engineIndex).engine, pDataSource, 0, NULL, &vec_access(soundVector, MABackendSound, unlockedIndex).sound) != MA_SUCCESS) {
            ma_decoder_uninit(&vec_access(soundVector, MABackendSound, unlockedIndex).dataSource.decoder);
            fprintf(stderr, "[lime miniaudio backend]: ERROR: failed to initialize an ma_sound from bytes\n");
            return -1;
        }

        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", unlockedIndex);
            sampleRate = 0;
        }

        uint64_t frameOffset = offset * sampleRate / 1000;

        if (ma_sound_seek_to_pcm_frame(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, frameOffset) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to seek an ma_sound with index %d to pcm frame offset %I64d\n", unlockedIndex, frameOffset);
        }

        vec_access(soundVector, MABackendSound, unlockedIndex).stopTime = 0;
        vec_access(soundVector, MABackendSound, unlockedIndex).loops = 0;
        vec_access(soundVector, MABackendSound, unlockedIndex).endCallbackData = {unlockedIndex};
        vec_access(soundVector, MABackendSound, unlockedIndex).locked = false;

        if (ma_sound_set_end_callback(&vec_access(soundVector, MABackendSound, unlockedIndex).sound, miniaudio_backend_sound_end_callback, &vec_access(soundVector, MABackendSound, unlockedIndex).endCallbackData) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to the end callback for an ma_sound with index %d\n", unlockedIndex);
        }

        return unlockedIndex;
    }

    void miniaudio_backend_sound_uninit(uint32_t soundIndex) {
        ma_sound_uninit(&vec_access(soundVector, MABackendSound, soundIndex).sound);

        switch (vec_access(soundVector, MABackendSound, soundIndex).dataSourceType) {
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_DECODER:
                ma_decoder_uninit(&vec_access(soundVector, MABackendSound, soundIndex).dataSource.decoder);
                break;
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_AUDIO_BUFFER:
                ma_audio_buffer_uninit(&vec_access(soundVector, MABackendSound, soundIndex).dataSource.audioBuffer);
                break;
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_INTERNAL: break;
        }

        vec_access(soundVector, MABackendSound, soundIndex).locked = false;
    }

    void miniaudio_backend_sound_start(uint32_t soundIndex) {
        if (ma_sound_start(&vec_access(soundVector, MABackendSound, soundIndex).sound) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to start a sound with index %d\n", soundIndex);
        }
    }

    void miniaudio_backend_sound_stop(uint32_t soundIndex) {
        if (ma_sound_stop(&vec_access(soundVector, MABackendSound, soundIndex).sound) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to stop a sound with index %d\n", soundIndex);
        }
    }

    void miniaudio_backend_sound_reset(uint32_t soundIndex, float offset) {
        miniaudio_backend_sound_stop(soundIndex);

        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, soundIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", soundIndex);
            return;
        }

        uint64_t frameOffset = offset * sampleRate / 1000;

        if (ma_sound_seek_to_pcm_frame(&vec_access(soundVector, MABackendSound, soundIndex).sound, frameOffset) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to seek an ma_sound with index %d to pcm frame offset %I64d\n", soundIndex, frameOffset);
        }
    }

    float miniaudio_backend_sound_get_time(uint32_t soundIndex, float offset) {
        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, soundIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", soundIndex);
        }

        uint64_t cursorPcmFrames = 0;

        if (ma_sound_get_cursor_in_pcm_frames(&vec_access(soundVector, MABackendSound, soundIndex).sound, &cursorPcmFrames) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get cursor of an ma_sound with index %d\n", soundIndex);
        }

        return cursorPcmFrames * 1000 / sampleRate - offset;
    }

    void miniaudio_backend_sound_set_time(uint32_t soundIndex, float offset, float t) {
        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, soundIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", soundIndex);
            return;
        }

        uint64_t frameOffset = offset * sampleRate / 1000;

        float tPcmFrames = t * sampleRate / 1000;

        if (ma_sound_seek_to_pcm_frame(&vec_access(soundVector, MABackendSound, soundIndex).sound, tPcmFrames - frameOffset) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to seek an ma_sound with index %d to pcm frame offset %I64d\n", soundIndex, frameOffset);
        }
    }

    float miniaudio_backend_sound_get_volume(uint32_t soundIndex) {
        return ma_sound_get_volume(&vec_access(soundVector, MABackendSound, soundIndex).sound);
    }

    void miniaudio_backend_sound_set_volume(uint32_t soundIndex, float v) {
        ma_sound_set_volume(&vec_access(soundVector, MABackendSound, soundIndex).sound, v);
    }

    float miniaudio_backend_sound_get_pitch(uint32_t soundIndex) {
        return ma_sound_get_pitch(&vec_access(soundVector, MABackendSound, soundIndex).sound);
    }

    void miniaudio_backend_sound_set_pitch(uint32_t soundIndex, float p) {
        ma_sound_set_pitch(&vec_access(soundVector, MABackendSound, soundIndex).sound, p);
    }

    ma_vec3f miniaudio_backend_sound_get_position(uint32_t soundIndex) {
        return ma_sound_get_position(&vec_access(soundVector, MABackendSound, soundIndex).sound);
    }

    void miniaudio_backend_sound_set_position(uint32_t soundIndex, float x, float y, float z) {
        ma_sound_set_position(&vec_access(soundVector, MABackendSound, soundIndex).sound, x, y, z);
    }

    float miniaudio_backend_sound_get_length(uint32_t soundIndex, float offset) {
        uint64_t lengthPcmFrames;
        if (ma_sound_get_length_in_pcm_frames(&vec_access(soundVector, MABackendSound, soundIndex).sound, &lengthPcmFrames) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get length of an ma_sound with index\n", soundIndex);
        }

        uint32_t sampleRate;
        if (ma_sound_get_data_format(&vec_access(soundVector, MABackendSound, soundIndex).sound, NULL, NULL, &sampleRate, NULL, 0) != MA_SUCCESS) {
            fprintf(stderr, "[lime miniaudio backend]: WARNING: failed to get data format of an ma_sound with index %d\n", soundIndex);
            return vec_access(soundVector, MABackendSound, soundIndex).stopTime;
        }

        float length = lengthPcmFrames * 1000 / sampleRate - offset;

        if (vec_access(soundVector, MABackendSound, soundIndex).stopTime < length && vec_access(soundVector, MABackendSound, soundIndex).stopTime > 0)
            length = vec_access(soundVector, MABackendSound, soundIndex).stopTime;

        return length;
    }

    void miniaudio_backend_sound_set_length(uint32_t soundIndex, float offset, float length) {
        vec_access(soundVector, MABackendSound, soundIndex).stopTime = length;

        ma_sound_set_stop_time_in_milliseconds(&vec_access(soundVector, MABackendSound, soundIndex).sound, length + offset);
    }

    int32_t miniaudio_backend_sound_get_loops(uint32_t soundIndex) {
        return vec_access(soundVector, MABackendSound, soundIndex).loops;
    }

    void miniaudio_backend_sound_set_loops(uint32_t soundIndex, int32_t loops) {
        vec_access(soundVector, MABackendSound, soundIndex).loops = loops;
    }

    bool miniaudio_backend_sound_is_playing(uint32_t soundIndex) {
        return ma_sound_is_playing(&vec_access(soundVector, MABackendSound, soundIndex).sound) == MA_TRUE ? true : false;
    }

    value miniaudio_backend_sound_readback_pcm(uint32_t soundIndex) {
        ma_audio_buffer* pAudioBuffer = NULL;
        value obj = alloc_empty_object();

        switch (vec_access(soundVector, MABackendSound, soundIndex).dataSourceType) {
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_INTERNAL:
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_DECODER:
                fprintf(stderr, "[lime miniaudio backend]: WARNING: ma_sound with index %d is streamed and does not support readback\n", soundIndex);
                return alloc_null();
            case MA_BACKEND_SOUND_DATA_SOURCE_TYPE_AUDIO_BUFFER:
                pAudioBuffer = &vec_access(soundVector, MABackendSound, soundIndex).dataSource.audioBuffer;

                alloc_field(obj, val_id("format"), alloc_int(pAudioBuffer->ref.format));
                alloc_field(obj, val_id("channels"), alloc_int(pAudioBuffer->ref.channels));
                alloc_field(obj, val_id("sampleRate"), alloc_int(pAudioBuffer->ref.sampleRate));
                alloc_field(obj, val_id("pcmFrameCount"), alloc_int(pAudioBuffer->ref.sizeInFrames));
                alloc_field(obj, val_id("pcmFrames"), cffi::alloc_pointer((void*)pAudioBuffer->ref.pData));

                break;
        }

        return obj;
    }

}