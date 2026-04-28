#include "BGFXBindings.h"
#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <system/ValuePointer.h>
#include <utils/ArrayBufferView.h>
#include <graphics/Image.h>
#include <graphics/ImageBuffer.h>

namespace lime {


	void lime_bgfx_set_debug (int flags) {

		bgfx::setDebug ((uint32_t)flags);

	}


	void lime_bgfx_set_view_clear (int id, int flags, int rgba, double depth, int stencil) {

		bgfx::setViewClear ((bgfx::ViewId) id, (uint16_t) flags, (uint32_t) rgba, (float) depth, (uint8_t) stencil);

	}


	void lime_bgfx_set_view_rect (int id, int x, int y, int width, int height) {

		bgfx::setViewRect ((bgfx::ViewId) id, (uint16_t) x, (uint16_t) y, (uint16_t) width, (uint16_t) height);

	}


	void lime_bgfx_touch (int id) {

		bgfx::touch ((bgfx::ViewId) id);

	}


	int lime_bgfx_frame (int flags) {

		return bgfx::frame (flags);

	}


	value lime_bgfx_get_stats () {

		const bgfx::Stats* bgfxStats = bgfx::getStats ();

		if (bgfxStats)
		{
			value stats = alloc_empty_object ();

			alloc_field (stats, val_id ("cpuTimeFrame"), alloc_float ((double) bgfxStats->cpuTimeFrame));
			alloc_field (stats, val_id ("cpuTimeBegin"), alloc_float ((double) bgfxStats->cpuTimeBegin));
			alloc_field (stats, val_id ("cpuTimeEnd"), alloc_float ((double) bgfxStats->cpuTimeEnd));
			alloc_field (stats, val_id ("cpuTimerFreq"), alloc_float ((double) bgfxStats->cpuTimerFreq));
			alloc_field (stats, val_id ("gpuTimeBegin"), alloc_float ((double) bgfxStats->gpuTimeBegin));
			alloc_field (stats, val_id ("gpuTimeEnd"), alloc_float ((double) bgfxStats->gpuTimeEnd));
			alloc_field (stats, val_id ("gpuTimerFreq"), alloc_float ((double) bgfxStats->gpuTimerFreq));
			alloc_field (stats, val_id ("waitRender"), alloc_float ((double) bgfxStats->waitRender));
			alloc_field (stats, val_id ("waitSubmit"), alloc_float ((double) bgfxStats->waitSubmit));
			alloc_field (stats, val_id ("numDraw"), alloc_int ((int)bgfxStats->numDraw));
			alloc_field (stats, val_id ("numCompute"), alloc_int ((int)bgfxStats->numCompute));
			alloc_field (stats, val_id ("numBlit"), alloc_int ((int)bgfxStats->numBlit));
			alloc_field (stats, val_id ("maxGpuLatency"), alloc_int ((int)bgfxStats->maxGpuLatency));
			alloc_field (stats, val_id ("gpuFrameNum"), alloc_int ((int)bgfxStats->gpuFrameNum));
			alloc_field (stats, val_id ("numDynamicIndexBuffers"), alloc_int ((int)bgfxStats->numDynamicIndexBuffers));
			alloc_field (stats, val_id ("numDynamicVertexBuffers"), alloc_int ((int)bgfxStats->numDynamicVertexBuffers));
			alloc_field (stats, val_id ("numFrameBuffers"), alloc_int ((int)bgfxStats->numFrameBuffers));
			alloc_field (stats, val_id ("numIndexBuffers"), alloc_int ((int)bgfxStats->numIndexBuffers));
			alloc_field (stats, val_id ("numOcclusionQueries"), alloc_int ((int)bgfxStats->numOcclusionQueries));
			alloc_field (stats, val_id ("numPrograms"), alloc_int ((int)bgfxStats->numPrograms));
			alloc_field (stats, val_id ("numShaders"), alloc_int ((int)bgfxStats->numShaders));
			alloc_field (stats, val_id ("numTextures"), alloc_int ((int)bgfxStats->numTextures));
			alloc_field (stats, val_id ("numUniforms"), alloc_int ((int)bgfxStats->numUniforms));
			alloc_field (stats, val_id ("numVertexBuffers"), alloc_int ((int)bgfxStats->numVertexBuffers));
			alloc_field (stats, val_id ("numVertexLayouts"), alloc_int ((int)bgfxStats->numVertexLayouts));
			alloc_field (stats, val_id ("textureMemoryUsed"), alloc_float ((double) bgfxStats->textureMemoryUsed));
			alloc_field (stats, val_id ("rtMemoryUsed"), alloc_float ((double) bgfxStats->rtMemoryUsed));
			alloc_field (stats, val_id ("transientVbUsed"), alloc_int ((int)bgfxStats->transientVbUsed));
			alloc_field (stats, val_id ("transientIbUsed"), alloc_int ((int)bgfxStats->transientIbUsed));

			value numPrims = alloc_array (bgfx::Topology::Count);

			for (int i = 0; i < bgfx::Topology::Count; i++) {

				val_array_set_i (numPrims, i, alloc_int (bgfxStats->numPrims[i]));

			}

			alloc_field (stats, val_id ("numPrims"), numPrims);

			alloc_field (stats, val_id ("gpuMemoryMax"), alloc_float ((double) bgfxStats->gpuMemoryMax));
			alloc_field (stats, val_id ("gpuMemoryUsed"), alloc_float ((double) bgfxStats->gpuMemoryUsed));
			alloc_field (stats, val_id ("width"), alloc_int ((int)bgfxStats->width));
			alloc_field (stats, val_id ("height"), alloc_int ((int)bgfxStats->height));
			alloc_field (stats, val_id ("textWidth"), alloc_int ((int)bgfxStats->textWidth));
			alloc_field (stats, val_id ("textHeight"), alloc_int ((int)bgfxStats->textHeight));

			value viewStats = alloc_array (bgfxStats->numViews);

			for (int i = 0; i < bgfxStats->numViews; i++) {

				value viewStat = alloc_empty_object ();
				alloc_field (viewStat, val_id ("name"), alloc_string (bgfxStats->viewStats[i].name));
				alloc_field (viewStat, val_id ("view"), alloc_int ((int)bgfxStats->viewStats[i].view));
				alloc_field (viewStat, val_id ("cpuTimeBegin"), alloc_float ((double) bgfxStats->viewStats[i].cpuTimeBegin));
				alloc_field (viewStat, val_id ("cpuTimeEnd"), alloc_float ((double) bgfxStats->viewStats[i].cpuTimeEnd));
				alloc_field (viewStat, val_id ("gpuTimeBegin"), alloc_float ((double) bgfxStats->viewStats[i].gpuTimeBegin));
				alloc_field (viewStat, val_id ("gpuTimeEnd"), alloc_float ((double) bgfxStats->viewStats[i].gpuTimeEnd));
				alloc_field (viewStat, val_id ("gpuFrameNum"), alloc_int ((int)bgfxStats->viewStats[i].gpuFrameNum));
				val_array_set_i (viewStats, i, viewStat);

			}

			alloc_field (stats, val_id ("viewStats"), viewStats);

			value encoderStats = alloc_array (bgfxStats->numEncoders);

			for (int i = 0; i < bgfxStats->numEncoders; i++) {

				value encoderStat = alloc_empty_object ();
				alloc_field (encoderStat, val_id ("cpuTimeBegin"), alloc_float ((double) bgfxStats->encoderStats[i].cpuTimeBegin));
				alloc_field (encoderStat, val_id ("cpuTimeEnd"), alloc_float ((double) bgfxStats->encoderStats[i].cpuTimeEnd));
				val_array_set_i (encoderStats, i, encoderStat);

			}

			alloc_field (stats, val_id ("encoderStats"), encoderStats);

			return stats;
		}

		return alloc_null ();

	}


	void lime_bgfx_dbg_text_clear (int attr, bool _small) {

		bgfx::dbgTextClear ((uint8_t) attr, _small);

	}


	void lime_bgfx_dbg_text_printf (int x, int y, int attr, HxString text) {

		bgfx::dbgTextPrintf ((uint16_t)x, (uint16_t)y, (uint8_t)attr, "%s", hxs_utf8 (text, nullptr));

	}


	void lime_bgfx_dbg_text_image (int x, int y, int width, int height, value data, int pitch) {

		ArrayBufferView bufferView (data);

		bgfx::dbgTextImage ((uint16_t) x, (uint16_t) y, (uint16_t )width, (uint16_t) height, bufferView.buffer->b, (uint16_t) pitch);

	}


	DEFINE_PRIME1v(lime_bgfx_set_debug);
	DEFINE_PRIME5v (lime_bgfx_set_view_clear);
	DEFINE_PRIME5v (lime_bgfx_set_view_rect);
	DEFINE_PRIME1v (lime_bgfx_touch);
	DEFINE_PRIME1 (lime_bgfx_frame);
	DEFINE_PRIME0 (lime_bgfx_get_stats);
	DEFINE_PRIME2v (lime_bgfx_dbg_text_clear);
	DEFINE_PRIME4v (lime_bgfx_dbg_text_printf);
	DEFINE_PRIME6v (lime_bgfx_dbg_text_image);


}


extern "C" int lime_bgfx_register_prims () {

	return 0;

}
