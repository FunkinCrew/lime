#pragma once


#include <miniaudio.h>

#include <utils/Bytes.h>

#include <hx/CFFI.h>

#include <cinttypes>

namespace lime {

    void miniaudio_backend_init();
    void miniaudio_backend_uninit();
    int32_t miniaudio_backend_engine_init(uint32_t sampleRate, uint32_t channels, uint32_t periodSizeInFrames, uint32_t gainSmoothTimeInFrames);
    void miniaudio_backend_engine_uninit(uint32_t engineIndex);
    void miniaudio_backend_engine_start(uint32_t engineIndex);
    void miniaudio_backend_engine_stop(uint32_t engineIndex);
    int32_t miniaudio_backend_sound_init_from_file(uint32_t engineIndex, float offset, const char* path);
    int32_t miniaudio_backend_sound_init_from_bytes(uint32_t engineIndex, float offset, bool stream, value bytes);
    void miniaudio_backend_sound_uninit(uint32_t soundIndex);
    void miniaudio_backend_sound_start(uint32_t soundIndex);
    void miniaudio_backend_sound_stop(uint32_t soundIndex);
    void miniaudio_backend_sound_reset(uint32_t soundIndex, float offset);
    float miniaudio_backend_sound_get_time(uint32_t soundIndex, float offset);
    void miniaudio_backend_sound_set_time(uint32_t soundIndex, float offset, float t);
    float miniaudio_backend_sound_get_volume(uint32_t soundIndex);
    void miniaudio_backend_sound_set_volume(uint32_t soundIndex, float v);
    float miniaudio_backend_sound_get_pitch(uint32_t soundIndex);
    void miniaudio_backend_sound_set_pitch(uint32_t soundIndex, float p);
    ma_vec3f miniaudio_backend_sound_get_position(uint32_t soundIndex);
    void miniaudio_backend_sound_set_position(uint32_t soundIndex, float x, float y, float z);
    float miniaudio_backend_sound_get_length(uint32_t soundIndex, float offset);
    void miniaudio_backend_sound_set_length(uint32_t soundIndex, float offset, float length);
    int32_t miniaudio_backend_sound_get_loops(uint32_t soundIndex);
    void miniaudio_backend_sound_set_loops(uint32_t soundIndex, int32_t loops);
    bool miniaudio_backend_sound_is_playing(uint32_t soundIndex);
    value miniaudio_backend_sound_readback_pcm(uint32_t soundIndex);

}
