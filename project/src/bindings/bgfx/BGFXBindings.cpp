#include "BGFXBindings.h"
#include <system/CFFI.h>
#include <cstring>
#include <system/CFFIPointer.h>
#include <system/ValuePointer.h>
#include <utils/ArrayBufferView.h>
#include <system/Mutex.h>
#include <map>
#include <vector>

namespace lime {

	#ifdef HXCPP_DEBUG
	class BGFXCallback : public bgfx::CallbackI {
		public:
			void fatal (const char* _filePath, uint16_t _line, bgfx::Fatal::Enum _code, const char* _str) override {
				fprintf (stderr, "[BGFX FATAL] (%d) %s at %s:%d\n", _code, _str, _filePath, _line);
				abort ();
			}

			void traceVargs (const char* _filePath, uint16_t _line, const char* _format, va_list _argList) override {
				fprintf (stderr, "[BGFX] ");
				vfprintf (stderr, _format, _argList);
			}

			void profilerBegin (const char*, uint32_t, const char*, uint16_t) override {}
			void profilerBeginLiteral (const char*, uint32_t, const char*, uint16_t) override {}
			void profilerEnd () override {}
			uint32_t cacheReadSize (uint64_t) override { return 0; }
			bool cacheRead (uint64_t, void*, uint32_t) override { return false; }
			void cacheWrite (uint64_t, const void*, uint32_t) override {}
			void screenShot (const char*, uint32_t, uint32_t, uint32_t, bgfx::TextureFormat::Enum, const void*, uint32_t, bool) override {}
			void captureBegin (uint32_t, uint32_t, uint32_t, bgfx::TextureFormat::Enum, bool) override {}
			void captureEnd () override {}
			void captureFrame (const void*, uint32_t) override {}
		};

	static BGFXCallback s_bgfxCallback;
	#endif

	std::map<void*, void*> bgfxObjectPtrs;
	std::vector<void*> gc_bgfx_ptr;
	Mutex gc_bgfx_mutex;

	void gc_bgfx_object (value object) {

		gc_bgfx_mutex.Lock ();

		void* ptr = bgfxObjectPtrs[object];
		if (ptr) {

				gc_bgfx_ptr.push_back (ptr);

				bgfxObjectPtrs.erase (object);

		}

		gc_bgfx_mutex.Unlock ();

	}

	void gc_bgfx_vertex_buffer (value handle) {

		bgfx::VertexBufferHandle* vbuff = (bgfx::VertexBufferHandle*) val_data (handle);
		if (bgfx::isValid (*vbuff)) bgfx::destroy (*vbuff);

		delete vbuff;

	}

	void gc_bgfx_index_buffer (value handle) {

		bgfx::IndexBufferHandle* ibuff = (bgfx::IndexBufferHandle*) val_data (handle);
		if (bgfx::isValid (*ibuff)) bgfx::destroy (*ibuff);

		delete ibuff;

	}

	void gc_bgfx_shader (value handle) {

		bgfx::ShaderHandle* shader = (bgfx::ShaderHandle*) val_data (handle);
		if (bgfx::isValid (*shader)) bgfx::destroy (*shader);

		delete shader;

	}

	void gc_bgfx_program (value handle) {

		bgfx::ProgramHandle* program = (bgfx::ProgramHandle*) val_data (handle);
		if (bgfx::isValid (*program)) bgfx::destroy (*program);

		delete program;

	}

	void gc_bgfx_dynamic_vertex_buffer (value handle) {

		bgfx::DynamicVertexBufferHandle* dvbh = (bgfx::DynamicVertexBufferHandle*) val_data (handle);
		if (bgfx::isValid (*dvbh)) bgfx::destroy (*dvbh);

		delete dvbh;

	}

	void gc_bgfx_dynamic_index_buffer (value handle) {

		bgfx::DynamicIndexBufferHandle* dibh = (bgfx::DynamicIndexBufferHandle*) val_data (handle);
		if (bgfx::isValid (*dibh)) bgfx::destroy (*dibh);

		delete dibh;

	}

	void gc_bgfx_occlusion_query (value handle) {

		bgfx::OcclusionQueryHandle* oqh = (bgfx::OcclusionQueryHandle*) val_data (handle);
		if (bgfx::isValid (*oqh)) bgfx::destroy (*oqh);

		delete oqh;

	}

	void gc_bgfx_indirect_buffer (value handle) {

		bgfx::IndirectBufferHandle* ixbh = (bgfx::IndirectBufferHandle*) val_data (handle);
		if (bgfx::isValid (*ixbh)) bgfx::destroy (*ixbh);

		delete ixbh;

	}

	void gc_bgfx_vertex_layout_handle (value handle) {

		bgfx::VertexLayoutHandle* vlh = (bgfx::VertexLayoutHandle*) val_data (handle);
		if (bgfx::isValid (*vlh)) bgfx::destroy (*vlh);

		delete vlh;

	}

	void gc_bgfx_val (value handle) {

		void* val = (void*) val_data (handle);
		delete val;

	}

	int lime_bgfx_render_frame () {

		return bgfx::renderFrame ();

	}


	void lime_bgfx_set_debug (int flags) {

		bgfx::setDebug ((uint32_t)flags);

	}


	void lime_bgfx_set_view_clear (int id, int flags, int rgba, double depth, int stencil) {

		bgfx::setViewClear ((bgfx::ViewId) id, (uint16_t) flags, (uint32_t) rgba, (float) depth, (uint8_t) stencil);

	}


	void lime_bgfx_set_view_clear_depth (int id, int flags, double depth, int stencil) {

		bgfx::setViewClear ((bgfx::ViewId) id, (uint16_t) flags, (float) depth, (uint8_t) stencil);

	}


	void lime_bgfx_set_view_rect (int id, int x, int y, int width, int height) {

		bgfx::setViewRect ((bgfx::ViewId) id, (uint16_t) x, (uint16_t) y, (uint16_t) width, (uint16_t) height);

	}


	void lime_bgfx_set_view_rect_ratio (int id, int x, int y, int ratio) {

		bgfx::setViewRect ((bgfx::ViewId) id, (uint16_t) x, (uint16_t) y, (bgfx::BackbufferRatio::Enum) ratio);

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

	value lime_bgfx_register_object (value object) {

		value handle = CFFIPointer (object, gc_bgfx_object);

		bgfxObjectPtrs[object] = handle;

		return handle;

	}

	value lime_bgfx_create_vertex_layout () {

		return CFFIPointer (new bgfx::VertexLayout (), gc_bgfx_val);

	}

	void lime_bgfx_vertex_layout_begin (value handle, int backend) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		v_layout->begin ((bgfx::RendererType::Enum) backend);

	}

	void lime_bgfx_vertex_layout_add (value handle, int attrib, int num, int type, bool normalized, bool asInt) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		v_layout->add ((bgfx::Attrib::Enum) attrib, num, (bgfx::AttribType::Enum) type, normalized, asInt);

	}

	value lime_bgfx_vertex_layout_decode (value handle, int attrib)
	{
		uint8_t num;
		bgfx::AttribType::Enum type;
		bool normalized;
		bool asInt;

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		v_layout->decode ((bgfx::Attrib::Enum) attrib, num, type, normalized, asInt);

		value obj = alloc_empty_object ();
		alloc_field (obj, val_id ("num"), alloc_int ((int) num));
		alloc_field (obj, val_id ("type"), alloc_int ((int) type));
		alloc_field (obj, val_id ("normalized"), alloc_bool (normalized));
		alloc_field (obj, val_id ("asInt"), alloc_bool (asInt));

		return obj;
	}

	bool lime_bgfx_vertex_layout_has (value handle, int attrib) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		return v_layout->has ((bgfx::Attrib::Enum) attrib);

	}

	void lime_bgfx_vertex_layout_skip (value handle, int num) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		v_layout->skip (num);

	}

	void lime_bgfx_vertex_layout_end (value handle) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		v_layout->end ();

	}

	int lime_bgfx_vertex_layout_get_offset (value handle, int attrib) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		return v_layout->getOffset ((bgfx::Attrib::Enum) attrib);

	}

	int lime_bgfx_vertex_layout_get_stride (value handle) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		return v_layout->getStride ();

	}

	int lime_bgfx_vertex_layout_get_size (value handle, int num) {

		bgfx::VertexLayout* v_layout = (bgfx::VertexLayout*) val_data (handle);
		return v_layout->getSize (num);

	}

	value lime_bgfx_make_ref (value data, int size) {

		ArrayBufferView bufferView (data);

		const bgfx::Memory* ref = bgfx::makeRef (bufferView.buffer->b, size);
		value handle = CFFIPointer (const_cast<bgfx::Memory*> (ref));

		return handle;

	}

	value lime_bgfx_create_vertex_buffer (value _mem, value _layout, int flags) {

		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (_mem);
		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (_layout);
		bgfx::VertexBufferHandle* vbh = new bgfx::VertexBufferHandle (bgfx::createVertexBuffer (mem, *layout, (uint16_t) flags));

		return CFFIPointer (vbh, gc_bgfx_vertex_buffer);

	}

	value lime_bgfx_create_index_buffer (value _mem, int flags) {

		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (_mem);
		bgfx::IndexBufferHandle* ibh = new bgfx::IndexBufferHandle (bgfx::createIndexBuffer (mem, (uint16_t) flags));

		return CFFIPointer (ibh, gc_bgfx_index_buffer);

	}

	value lime_bgfx_create_shader(value _mem) {

		const bgfx::Memory* mem = (const bgfx::Memory*) val_data(_mem);
		bgfx::ShaderHandle* shader = new bgfx::ShaderHandle (bgfx::createShader (mem));

		return CFFIPointer (shader, gc_bgfx_shader);

	}

	value lime_bgfx_create_program (value _vsh, value _fsh, bool destroyShaders) {

		bgfx::ShaderHandle* vsh = (bgfx::ShaderHandle*) val_data (_vsh);
		bgfx::ShaderHandle* fsh = (bgfx::ShaderHandle*) val_data (_fsh);
		bgfx::ProgramHandle* program = new bgfx::ProgramHandle (bgfx::createProgram (*vsh, *fsh, destroyShaders));

		if (destroyShaders) {
			vsh->idx = bgfx::kInvalidHandle;
			fsh->idx = bgfx::kInvalidHandle;
		}

		return CFFIPointer (program, gc_bgfx_program);

	}

	value lime_bgfx_create_compute_program (value _vsh, bool destroyShaders) {

		bgfx::ShaderHandle* vsh = (bgfx::ShaderHandle*) val_data (_vsh);
		bgfx::ProgramHandle* program = new bgfx::ProgramHandle (bgfx::createProgram (*vsh, destroyShaders));

		if (destroyShaders) {
			vsh->idx = bgfx::kInvalidHandle;
		}

		return CFFIPointer (program, gc_bgfx_program);

	}

	void lime_bgfx_set_vertex_buffer (int stream, value handle) {

		bgfx::VertexBufferHandle* vbh = (bgfx::VertexBufferHandle*) val_data (handle);
		bgfx::setVertexBuffer ((uint8_t) stream, *vbh);

	}

	void lime_bgfx_set_vertex_buffer_vertices (int stream, value handle, int startVertex, int numVertices) {

		bgfx::VertexBufferHandle* vbh = (bgfx::VertexBufferHandle*) val_data(handle);
		bgfx::setVertexBuffer ((uint8_t) stream, *vbh, (uint32_t) startVertex, (uint32_t) numVertices);

	}

	void lime_bgfx_set_vertex_buffer_layout (int stream, value handle, int startVertex, int numVertices, value _layout) {

		bgfx::VertexBufferHandle* vbh = (bgfx::VertexBufferHandle*) val_data (handle);
		bgfx::VertexLayoutHandle* layout = (bgfx::VertexLayoutHandle*) val_data (_layout);
		bgfx::setVertexBuffer ((uint8_t) stream, *vbh, (uint32_t) startVertex, (uint32_t) numVertices, *layout);

	}

	void lime_bgfx_set_dynamic_vertex_buffer (int stream, value handle) {

		bgfx::DynamicVertexBufferHandle* dvbh = (bgfx::DynamicVertexBufferHandle*) val_data (handle);
		bgfx::setVertexBuffer ((uint8_t) stream, *dvbh);

	}

	void lime_bgfx_set_dynamic_vertex_buffer_vertices (int stream, value handle, int startVertex, int numVertices) {

		bgfx::DynamicVertexBufferHandle* dvbh = (bgfx::DynamicVertexBufferHandle*) val_data (handle);
		bgfx::setVertexBuffer ((uint8_t) stream, *dvbh, (uint32_t) startVertex, (uint32_t) numVertices);

	}

	void lime_bgfx_set_dynamic_vertex_buffer_layout (int stream, value handle, int startVertex, int numVertices, value _layout) {

		bgfx::DynamicVertexBufferHandle* dvbh = (bgfx::DynamicVertexBufferHandle*) val_data (handle);
		bgfx::VertexLayoutHandle* layout = (bgfx::VertexLayoutHandle*) val_data (_layout);
		bgfx::setVertexBuffer ((uint8_t) stream, *dvbh, (uint32_t) startVertex, (uint32_t) numVertices, *layout);

	}

	void lime_bgfx_set_transient_vertex_buffer (int stream, value handle) {

		bgfx::TransientVertexBuffer* tvb = (bgfx::TransientVertexBuffer*) val_data (handle);
		bgfx::setVertexBuffer ((uint8_t) stream, tvb);

	}

	void lime_bgfx_set_transient_vertex_buffer_vertices (int stream, value handle, int startVertex, int numVertices) {

		bgfx::TransientVertexBuffer* tvb = (bgfx::TransientVertexBuffer*) val_data (handle);
		bgfx::setVertexBuffer ((uint8_t) stream, tvb, (uint32_t) startVertex, (uint32_t) numVertices);

	}

	void lime_bgfx_set_transient_vertex_buffer_layout (int stream, value handle, int startVertex, int numVertices, value _layout) {

		bgfx::TransientVertexBuffer* tvb = (bgfx::TransientVertexBuffer*) val_data (handle);
		bgfx::VertexLayoutHandle* layout = (bgfx::VertexLayoutHandle*) val_data (_layout);
		bgfx::setVertexBuffer ((uint8_t) stream, tvb, (uint32_t) startVertex, (uint32_t) numVertices, *layout);

	}

	void lime_bgfx_set_index_buffer (value handle) {

		bgfx::IndexBufferHandle* ibh = (bgfx::IndexBufferHandle*) val_data (handle);
		bgfx::setIndexBuffer (*ibh);

	}

	void lime_bgfx_set_index_buffer_indices (value handle, int firstIndex, int numIndices) {

		bgfx::IndexBufferHandle* ibh = (bgfx::IndexBufferHandle*) val_data (handle);
		bgfx::setIndexBuffer (*ibh, (uint32_t) firstIndex, (uint32_t) numIndices);

	}

	void lime_bgfx_set_dynamic_index_buffer (value handle) {

		bgfx::DynamicIndexBufferHandle* dibh = (bgfx::DynamicIndexBufferHandle*) val_data (handle);
		bgfx::setIndexBuffer (*dibh);

	}

	void lime_bgfx_set_dynamic_index_buffer_indices (value handle, int firstIndex, int numIndices) {

		bgfx::DynamicIndexBufferHandle* dibh = (bgfx::DynamicIndexBufferHandle*) val_data (handle);
		bgfx::setIndexBuffer (*dibh, (uint32_t) firstIndex, (uint32_t) numIndices);

	}

	void lime_bgfx_set_transient_index_buffer (value handle) {

		bgfx::TransientIndexBuffer* tib = (bgfx::TransientIndexBuffer*) val_data (handle);
		bgfx::setIndexBuffer (tib);

	}

	void lime_bgfx_set_transient_index_buffer_indices (value handle, int firstIndex, int numIndices) {

		bgfx::TransientIndexBuffer* tib = (bgfx::TransientIndexBuffer*) val_data (handle);
		bgfx::setIndexBuffer (tib, (uint32_t) firstIndex, (uint32_t) numIndices);

	}

	void lime_bgfx_set_state (int stateA, int stateB, int rgba) {

		uint64_t state = (uint64_t)(uint32_t) stateA << 32 | (uint32_t) stateB;
		bgfx::setState (state, (uint32_t) rgba);

	}

	void lime_bgfx_set_view_transform (int id, value view, value proj) {

		ArrayBufferView viewBuffer (view);
		ArrayBufferView projBuffer (proj);

		bgfx::setViewTransform ((bgfx::ViewId) id, viewBuffer.buffer->b, projBuffer.buffer->b);

	}

	int lime_bgfx_set_transform (value mtx, int num) {

		ArrayBufferView buffer (mtx);

		return (int)bgfx::setTransform (buffer.buffer->b, (uint16_t) num);

	}

	void lime_bgfx_submit (int id, value handle, int depth, int flags) {

		bgfx::ProgramHandle* program = (bgfx::ProgramHandle*) val_data(handle);

		bgfx::submit ((bgfx::ViewId) id, *program, (uint32_t) depth, (uint8_t) flags);

	}

	void lime_bgfx_submit_occlusion_query (int id, value program_handle, value oqh_handle, int depth, int flags) {

		bgfx::ProgramHandle* program = (bgfx::ProgramHandle*) val_data(program_handle);
		bgfx::OcclusionQueryHandle* oqh = (bgfx::OcclusionQueryHandle*) val_data(oqh_handle);
		bgfx::submit ((bgfx::ViewId) id, *program, *oqh, (uint32_t) depth, (uint8_t) flags);

	}

	void lime_bgfx_submit_indirect_buffer (int id, value program_handle, value ixbh_handle, int start, int num, int depth, int flags) {

		bgfx::ProgramHandle* program = (bgfx::ProgramHandle*) val_data(program_handle);
		bgfx::IndirectBufferHandle* ixbh = (bgfx::IndirectBufferHandle*) val_data(ixbh_handle);
		bgfx::submit ((bgfx::ViewId) id, *program, *ixbh, (uint32_t) start, (uint32_t) num, (uint32_t) depth, (uint8_t) flags);

	}

	void lime_bgfx_submit_indirect_index_buffer (int id, value program_handle, value ixbh_handle, int start, value ibh_handle, int numMax, int depth, int flags) {

		bgfx::ProgramHandle* program = (bgfx::ProgramHandle*) val_data(program_handle);
		bgfx::IndirectBufferHandle* ixbh = (bgfx::IndirectBufferHandle*) val_data(ixbh_handle);
		bgfx::IndexBufferHandle* ibh = (bgfx::IndexBufferHandle*) val_data(ibh_handle);
		bgfx::submit ((bgfx::ViewId) id, *program, *ixbh, (uint32_t) start, *ibh, (uint32_t) numMax, (uint32_t) depth, (uint8_t) flags);

	}

	value lime_bgfx_create_occlusion_query () {

		bgfx::OcclusionQueryHandle* oqh = new bgfx::OcclusionQueryHandle (bgfx::createOcclusionQuery ());
		return CFFIPointer (oqh, gc_bgfx_occlusion_query);

	}


	value lime_bgfx_get_occlusion_query_result (value handle) {

		bgfx::OcclusionQueryHandle* oqh = (bgfx::OcclusionQueryHandle*) val_data (handle);
		int32_t num = 0;
		bgfx::OcclusionQueryResult::Enum result = bgfx::getResult (*oqh, &num);

		value obj = alloc_empty_object ();
		alloc_field (obj, val_id ("result"), alloc_int ((int) result));
		alloc_field (obj, val_id ("num"), alloc_int ((int) num));

		return obj;

	}


	value lime_bgfx_create_indirect_buffer (int num) {

		bgfx::IndirectBufferHandle* ixbh = new bgfx::IndirectBufferHandle (bgfx::createIndirectBuffer ((uint32_t) num));
		return CFFIPointer (ixbh, gc_bgfx_indirect_buffer);

	}


	value lime_bgfx_create_dynamic_vertex_buffer (int num, value handle, int flags) {

		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (handle);
		bgfx::DynamicVertexBufferHandle* dvbh = new bgfx::DynamicVertexBufferHandle (bgfx::createDynamicVertexBuffer ((uint32_t) num, *layout, (uint16_t) flags));

		return CFFIPointer (dvbh, gc_bgfx_dynamic_vertex_buffer);

	}


	value lime_bgfx_create_dynamic_vertex_buffer_mem (value mem_handle, value layout_handle, int flags) {

		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (mem_handle);
		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (layout_handle);
		bgfx::DynamicVertexBufferHandle* dvbh = new bgfx::DynamicVertexBufferHandle (bgfx::createDynamicVertexBuffer (mem, *layout, (uint16_t) flags));

		return CFFIPointer (dvbh, gc_bgfx_dynamic_vertex_buffer);

	}


	void lime_bgfx_update_dynamic_vertex_buffer (value handle, int startVertex, value _mem) {

		bgfx::DynamicVertexBufferHandle* dvbh = (bgfx::DynamicVertexBufferHandle*) val_data (handle);
		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (_mem);
		bgfx::update (*dvbh, (uint32_t) startVertex, mem);

	}


	value lime_bgfx_create_dynamic_index_buffer (int num, int flags) {

		bgfx::DynamicIndexBufferHandle* dibh = new bgfx::DynamicIndexBufferHandle (bgfx::createDynamicIndexBuffer ((uint32_t) num, (uint16_t) flags));

		return CFFIPointer (dibh, gc_bgfx_dynamic_index_buffer);

	}


	value lime_bgfx_create_dynamic_index_buffer_mem (value handle, int flags) {

		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (handle);
		bgfx::DynamicIndexBufferHandle* dibh = new bgfx::DynamicIndexBufferHandle (bgfx::createDynamicIndexBuffer (mem, (uint16_t) flags));

		return CFFIPointer (dibh, gc_bgfx_dynamic_index_buffer);

	}


	void lime_bgfx_update_dynamic_index_buffer (value handle, int firstIndex, value _mem) {

		bgfx::DynamicIndexBufferHandle* dibh = (bgfx::DynamicIndexBufferHandle*) val_data (handle);
		const bgfx::Memory* mem = (const bgfx::Memory*) val_data (_mem);
		bgfx::update (*dibh, (uint32_t) firstIndex, mem);

	}


	value lime_bgfx_alloc_transient_vertex_buffer (int num, value handle) {

		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (handle);
		bgfx::TransientVertexBuffer* tvb = new bgfx::TransientVertexBuffer ();
		bgfx::allocTransientVertexBuffer (tvb, (uint32_t) num, *layout);

		return CFFIPointer (tvb, gc_bgfx_val);

	}


	value lime_bgfx_alloc_transient_index_buffer (int num, bool index32) {

		bgfx::TransientIndexBuffer* tib = new bgfx::TransientIndexBuffer ();
		bgfx::allocTransientIndexBuffer (tib, (uint32_t) num, index32);

		return CFFIPointer (tib, gc_bgfx_val);

	}


	value lime_bgfx_get_transient_vertex_buffer_data (value handle) {

		bgfx::TransientVertexBuffer* tvb = (bgfx::TransientVertexBuffer*) val_data (handle);
		if (!tvb || !tvb->data || tvb->size == 0) return alloc_null ();

		ArrayBufferView abv (alloc_null ());
		abv.buffer->Resize (tvb->size);
		memcpy (abv.buffer->b, tvb->data, tvb->size);
		abv.byteLength = (int) tvb->size;
		abv.length = (int) tvb->size;
		return abv.Value ();

	}


	void lime_bgfx_set_transient_vertex_buffer_data (value handle, value data) {

		bgfx::TransientVertexBuffer* tvb = (bgfx::TransientVertexBuffer*) val_data (handle);
		if (!tvb || !tvb->data) return;

		ArrayBufferView abv (data);
		if (!abv.buffer || !abv.buffer->b || abv.byteLength == 0) return;

		uint32_t copySize = (uint32_t) abv.byteLength < tvb->size ? (uint32_t) abv.byteLength : tvb->size;
		memcpy (tvb->data, abv.buffer->b, copySize);

	}


	int lime_bgfx_get_avail_transient_vertex_buffer (int num, value handle) {

		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (handle);
		return bgfx::getAvailTransientVertexBuffer ((uint32_t) num, *layout);

	}


	int lime_bgfx_get_avail_transient_index_buffer (int num, bool index32) {

		return bgfx::getAvailTransientIndexBuffer ((uint32_t) num, index32);

	}


	value lime_bgfx_register_vertex_layout (value handle) {

		bgfx::VertexLayout* layout = (bgfx::VertexLayout*) val_data (handle);
		bgfx::VertexLayoutHandle* vlh = new bgfx::VertexLayoutHandle (bgfx::createVertexLayout (*layout));

		return CFFIPointer (vlh, gc_bgfx_vertex_layout_handle);

	}


	value lime_bgfx_get_caps () {

		const bgfx::Caps* caps = bgfx::getCaps ();

		if (caps) {

			value obj = alloc_empty_object ();
			alloc_field (obj, val_id ("rendererType"), alloc_int ((int) caps->rendererType));
			alloc_field (obj, val_id ("supported"), alloc_float ((double) (caps->supported >> 32)));
			alloc_field (obj, val_id ("vendorId"), alloc_int ((int) caps->vendorId));
			alloc_field (obj, val_id ("deviceId"), alloc_int ((int) caps->deviceId));
			alloc_field (obj, val_id ("homogeneousDepth"), alloc_bool (caps->homogeneousDepth));
			alloc_field (obj, val_id ("originBottomLeft"), alloc_bool (caps->originBottomLeft));
			alloc_field (obj, val_id ("numGPUs"), alloc_int ((int) caps->numGPUs));

			value gpus = alloc_array (caps->numGPUs);
			for (int i = 0; i < caps->numGPUs; i++) {
				value gpu = alloc_empty_object ();
				alloc_field (gpu, val_id ("vendorId"), alloc_int ((int) caps->gpu[i].vendorId));
				alloc_field (gpu, val_id ("deviceId"), alloc_int ((int) caps->gpu[i].deviceId));
				val_array_set_i (gpus, i, gpu);
			}
			alloc_field (obj, val_id ("gpus"), gpus);

			value limits = alloc_empty_object ();
			alloc_field (limits, val_id ("maxDrawCalls"), alloc_int ((int) caps->limits.maxDrawCalls));
			alloc_field (limits, val_id ("maxBlits"), alloc_int ((int) caps->limits.maxBlits));
			alloc_field (limits, val_id ("maxTextureSize"), alloc_int ((int) caps->limits.maxTextureSize));
			alloc_field (limits, val_id ("maxTextureLayers"), alloc_int ((int) caps->limits.maxTextureLayers));
			alloc_field (limits, val_id ("maxViews"), alloc_int ((int) caps->limits.maxViews));
			alloc_field (limits, val_id ("maxFrameBuffers"), alloc_int ((int) caps->limits.maxFrameBuffers));
			alloc_field (limits, val_id ("maxFBAttachments"), alloc_int ((int) caps->limits.maxFBAttachments));
			alloc_field (limits, val_id ("maxPrograms"), alloc_int ((int) caps->limits.maxPrograms));
			alloc_field (limits, val_id ("maxShaders"), alloc_int ((int) caps->limits.maxShaders));
			alloc_field (limits, val_id ("maxTextures"), alloc_int ((int) caps->limits.maxTextures));
			alloc_field (limits, val_id ("maxTextureSamplers"), alloc_int ((int) caps->limits.maxTextureSamplers));
			alloc_field (limits, val_id ("maxComputeBindings"), alloc_int ((int) caps->limits.maxComputeBindings));
			alloc_field (limits, val_id ("maxVertexLayouts"), alloc_int ((int) caps->limits.maxVertexLayouts));
			alloc_field (limits, val_id ("maxVertexStreams"), alloc_int ((int) caps->limits.maxVertexStreams));
			alloc_field (limits, val_id ("maxIndexBuffers"), alloc_int ((int) caps->limits.maxIndexBuffers));
			alloc_field (limits, val_id ("maxVertexBuffers"), alloc_int ((int) caps->limits.maxVertexBuffers));
			alloc_field (limits, val_id ("maxDynamicIndexBuffers"), alloc_int ((int) caps->limits.maxDynamicIndexBuffers));
			alloc_field (limits, val_id ("maxDynamicVertexBuffers"), alloc_int ((int) caps->limits.maxDynamicVertexBuffers));
			alloc_field (limits, val_id ("maxUniforms"), alloc_int ((int) caps->limits.maxUniforms));
			alloc_field (limits, val_id ("maxOcclusionQueries"), alloc_int ((int) caps->limits.maxOcclusionQueries));
			alloc_field (limits, val_id ("maxEncoders"), alloc_int ((int) caps->limits.maxEncoders));
			alloc_field (limits, val_id ("minResourceCbSize"), alloc_int ((int) caps->limits.minResourceCbSize));
			alloc_field (limits, val_id ("maxTransientVbSize"), alloc_int ((int) caps->limits.maxTransientVbSize));
			alloc_field (limits, val_id ("maxTransientIbSize"), alloc_int ((int) caps->limits.maxTransientIbSize));
			alloc_field (limits, val_id ("minUniformBufferSize"), alloc_int ((int) caps->limits.minUniformBufferSize));
			alloc_field (obj, val_id ("limits"), limits);

			return obj;

		}

		return alloc_null ();
	}

	value lime_bgfx_compile_shader_string (int type, HxString shaderSource, HxString varyingDef, HxString defines, HxString profile) {

		char shaderType;
		switch (type) {
			case 0: shaderType = 'v'; break;
			case 1: shaderType = 'f'; break;
			case 2: shaderType = 'c'; break;
			default: return alloc_null ();
		}

		const char* src = hxs_utf8 (shaderSource, nullptr);
		const char* varying = hxs_utf8 (varyingDef, nullptr);
		const char* defs = hxs_utf8 (defines, nullptr);
		const char* prof = hxs_utf8 (profile, nullptr);

		if (!src || !*src) return alloc_null ();

		bgfx::Options options;
		options.shaderType = shaderType;
		options.inputFilePath = "<string>";

		#if defined (ANDROID)
		options.platform = "android";
		#elif defined (HX_LINUX)
		options.platform = "linux";
		#elif defined (IPHONE)
		options.platform = "ios";
		#elif defined (HX_MACOS)
		options.platform = "osx";
		#elif defined (HX_WINDOWS)
		options.platform = "windows";
		#endif

		if (prof && *prof) {
			options.profile = prof;
		} else {
			switch (bgfx::getRendererType ()) {
				case bgfx::RendererType::Direct3D11:
					options.profile = (shaderType == 'c') ? "cs_5_0" : "s_4_0";
					break;
				case bgfx::RendererType::Direct3D12:
					options.profile = "s_5_0";
					break;
				case bgfx::RendererType::OpenGL:
				case bgfx::RendererType::OpenGLES:
					options.profile = (shaderType == 'c') ? "430" : "120";
					break;
				case bgfx::RendererType::Metal:
					options.profile = "metal";
					break;
				case bgfx::RendererType::Vulkan:
					options.profile = "spirv";
					break;
				default:
					options.profile = "";
					break;
			}
		}

		if (options.profile.empty ()) return alloc_null ();

		if (defs) {
			const char* d = defs;
			while (*d) {
				while (*d == ' ' || *d == '\t') d++;
				const char* e = d;
				while (*e && *e != ';') e++;
				if (e > d) options.defines.emplace_back (d, e);
				d = (*e == ';') ? e + 1 : e;
			}
		}

		const size_t padding = 16384;
		uint32_t srcLen = src ? static_cast<uint32_t> (std::strlen (src)) : 0;
		char* buf = new char[srcLen + padding + 1] ();
		if (src && srcLen) std::memcpy (buf, src, srcLen);
		buf[srcLen] = '\n';

		bgfx::ShaderCWriter sOut, mOut;
		if (bgfx::compileShader (varying ? varying : "", "", buf, srcLen, options, &sOut, &mOut)) {
			const bgfx::Memory* mem = sOut.finalize ();
			if (mem) return CFFIPointer (const_cast<bgfx::Memory*> (mem));
		}

		return alloc_null ();

	}


	DEFINE_PRIME0 (lime_bgfx_render_frame);
	DEFINE_PRIME1v(lime_bgfx_set_debug);
	DEFINE_PRIME5v (lime_bgfx_set_view_clear);
	DEFINE_PRIME4v (lime_bgfx_set_view_clear_depth);
	DEFINE_PRIME5v (lime_bgfx_set_view_rect);
	DEFINE_PRIME4v (lime_bgfx_set_view_rect_ratio);
	DEFINE_PRIME1v (lime_bgfx_touch);
	DEFINE_PRIME1 (lime_bgfx_frame);
	DEFINE_PRIME0 (lime_bgfx_get_stats);
	DEFINE_PRIME2v (lime_bgfx_dbg_text_clear);
	DEFINE_PRIME4v (lime_bgfx_dbg_text_printf);
	DEFINE_PRIME6v (lime_bgfx_dbg_text_image);
	DEFINE_PRIME0 (lime_bgfx_create_vertex_layout);
	DEFINE_PRIME1 (lime_bgfx_register_object);
	DEFINE_PRIME2v (lime_bgfx_vertex_layout_begin);
	DEFINE_PRIME6v (lime_bgfx_vertex_layout_add);
	DEFINE_PRIME2 (lime_bgfx_vertex_layout_decode);
	DEFINE_PRIME2 (lime_bgfx_vertex_layout_has);
	DEFINE_PRIME2v (lime_bgfx_vertex_layout_skip);
	DEFINE_PRIME2 (lime_bgfx_vertex_layout_get_offset);
	DEFINE_PRIME1 (lime_bgfx_vertex_layout_get_stride);
	DEFINE_PRIME2 (lime_bgfx_vertex_layout_get_size);
	DEFINE_PRIME1v (lime_bgfx_vertex_layout_end);
	DEFINE_PRIME2 (lime_bgfx_make_ref);
	DEFINE_PRIME3 (lime_bgfx_create_vertex_buffer);
	DEFINE_PRIME2 (lime_bgfx_create_index_buffer);
	DEFINE_PRIME1 (lime_bgfx_create_shader);
	DEFINE_PRIME3 (lime_bgfx_create_program);
	DEFINE_PRIME2  (lime_bgfx_create_compute_program);
	DEFINE_PRIME2v (lime_bgfx_set_vertex_buffer);
	DEFINE_PRIME4v (lime_bgfx_set_vertex_buffer_vertices);
	DEFINE_PRIME5v (lime_bgfx_set_vertex_buffer_layout);
	DEFINE_PRIME2v (lime_bgfx_set_dynamic_vertex_buffer);
	DEFINE_PRIME4v (lime_bgfx_set_dynamic_vertex_buffer_vertices);
	DEFINE_PRIME5v (lime_bgfx_set_dynamic_vertex_buffer_layout);
	DEFINE_PRIME2v (lime_bgfx_set_transient_vertex_buffer);
	DEFINE_PRIME4v (lime_bgfx_set_transient_vertex_buffer_vertices);
	DEFINE_PRIME5v (lime_bgfx_set_transient_vertex_buffer_layout);
	DEFINE_PRIME1v (lime_bgfx_set_index_buffer);
	DEFINE_PRIME3v (lime_bgfx_set_index_buffer_indices);
	DEFINE_PRIME1v (lime_bgfx_set_dynamic_index_buffer);
	DEFINE_PRIME3v (lime_bgfx_set_dynamic_index_buffer_indices);
	DEFINE_PRIME1v (lime_bgfx_set_transient_index_buffer);
	DEFINE_PRIME3v (lime_bgfx_set_transient_index_buffer_indices);
	DEFINE_PRIME3v (lime_bgfx_set_state);
	DEFINE_PRIME3v (lime_bgfx_set_view_transform);
	DEFINE_PRIME2 (lime_bgfx_set_transform);
	DEFINE_PRIME4v (lime_bgfx_submit);
	DEFINE_PRIME5v (lime_bgfx_submit_occlusion_query);
	DEFINE_PRIME7v (lime_bgfx_submit_indirect_buffer);
	DEFINE_PRIME8v (lime_bgfx_submit_indirect_index_buffer);
	DEFINE_PRIME0 (lime_bgfx_get_caps);
	DEFINE_PRIME0 (lime_bgfx_create_occlusion_query);
	DEFINE_PRIME1 (lime_bgfx_get_occlusion_query_result);
	DEFINE_PRIME1 (lime_bgfx_create_indirect_buffer);
	DEFINE_PRIME3 (lime_bgfx_create_dynamic_vertex_buffer);
	DEFINE_PRIME3 (lime_bgfx_create_dynamic_vertex_buffer_mem);
	DEFINE_PRIME3v (lime_bgfx_update_dynamic_vertex_buffer);
	DEFINE_PRIME2 (lime_bgfx_create_dynamic_index_buffer);
	DEFINE_PRIME2 (lime_bgfx_create_dynamic_index_buffer_mem);
	DEFINE_PRIME3v (lime_bgfx_update_dynamic_index_buffer);
	DEFINE_PRIME2 (lime_bgfx_alloc_transient_vertex_buffer);
	DEFINE_PRIME2 (lime_bgfx_alloc_transient_index_buffer);
	DEFINE_PRIME1 (lime_bgfx_get_transient_vertex_buffer_data);
	DEFINE_PRIME2v (lime_bgfx_set_transient_vertex_buffer_data);
	DEFINE_PRIME2 (lime_bgfx_get_avail_transient_vertex_buffer);
	DEFINE_PRIME2 (lime_bgfx_get_avail_transient_index_buffer);
	DEFINE_PRIME1 (lime_bgfx_register_vertex_layout);
	DEFINE_PRIME5 (lime_bgfx_compile_shader_string);

	#define DEFINE_BGFX_DESTROY(name, HandleType) \
		void lime_bgfx_destroy_##name (value handle) { \
			bgfx::HandleType* val = (bgfx::HandleType*) val_data (handle); \
			if (bgfx::isValid (*val)) { \
				bgfx::destroy (*val); \
				val->idx = bgfx::kInvalidHandle; \
			} \
		} \
		DEFINE_PRIME1v (lime_bgfx_destroy_##name);

	DEFINE_BGFX_DESTROY (vertex_buffer, VertexBufferHandle)
	DEFINE_BGFX_DESTROY (index_buffer, IndexBufferHandle)
	DEFINE_BGFX_DESTROY (dynamic_vertex_buffer, DynamicVertexBufferHandle)
	DEFINE_BGFX_DESTROY (dynamic_index_buffer, DynamicIndexBufferHandle)
	DEFINE_BGFX_DESTROY (shader, ShaderHandle)
	DEFINE_BGFX_DESTROY (program, ProgramHandle)
	DEFINE_BGFX_DESTROY (texture, TextureHandle)
	DEFINE_BGFX_DESTROY (frame_buffer, FrameBufferHandle)
	DEFINE_BGFX_DESTROY (uniform, UniformHandle)
	DEFINE_BGFX_DESTROY (vertex_layout, VertexLayoutHandle)
	DEFINE_BGFX_DESTROY (occlusion_query, OcclusionQueryHandle)
	DEFINE_BGFX_DESTROY (indirect_buffer, IndirectBufferHandle)

	#undef DEFINE_BGFX_DESTROY


	static bgfx::RendererType::Enum getRendererType () {

		#if defined (ANDROID) || defined (HX_LINUX)
		return bgfx::RendererType::Vulkan;
		#elif defined (IPHONE) || defined (HX_MACOS)
		return bgfx::RendererType::Metal;
		#elif defined (HX_WINDOWS)
		return bgfx::RendererType::Direct3D11;
		#else
		return bgfx::RendererType::Noop;
		#endif

	}


	static void* getNativeWindowHandle (SDL_Window* sdlWindow) {

		if (!sdlWindow) {

			return NULL;

		}

		SDL_PropertiesID props = SDL_GetWindowProperties (sdlWindow);

		#if defined (ANDROID)

		return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER, NULL);

		#elif defined (IPHONE)

		return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER, NULL);

		#elif defined (HX_LINUX)

		const char* driver = SDL_GetCurrentVideoDriver ();

		if (SDL_strcmp (driver, "wayland") == 0) {

			return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, NULL);

		} else if (SDL_strcmp (driver, "x11") == 0) {

			return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);

		}

		#elif defined (HX_MACOS)

		return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_COCOA_WINDOW_POINTER, NULL);

		#elif defined (HX_WINDOWS)

		return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, NULL);

		#endif

		return NULL;

	}


	static void* getNativeDisplayHandle (SDL_Window* sdlWindow) {

		if (!sdlWindow) {

			return NULL;

		}

		SDL_PropertiesID props = SDL_GetWindowProperties (sdlWindow);

		#if defined (HX_LINUX)
		const char* driver = SDL_GetCurrentVideoDriver ();

		if (SDL_strcmp (driver, "wayland") == 0) {

			return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, NULL);

		} else if (SDL_strcmp (driver, "x11") == 0) {

			return SDL_GetPointerProperty (props, SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);

		}
		#endif

		return NULL;

	}


	static bgfx::NativeWindowHandleType::Enum getNativeWindowHandleType (SDL_Window* sdlWindow) {

		#if defined (HX_LINUX)
		const char* driver = SDL_GetCurrentVideoDriver ();

		if (SDL_strcmp (driver, "wayland") == 0) {

			return bgfx::NativeWindowHandleType::Wayland;

		}
		#endif

		return bgfx::NativeWindowHandleType::Default;

	}


	bool BGFXBindings::Init (SDL_Window* sdlWindow) {

		// BGFX needs a frame render before init or it hangs
		bgfx::renderFrame ();

		// Setup bgfx init struct
		bgfx::Init init;

		// Set renderer type based on platform
		init.type = getRendererType ();

		// Get native window/display handles from SDL
		init.platformData.nwh = getNativeWindowHandle (sdlWindow);
		init.platformData.ndt = getNativeDisplayHandle (sdlWindow);
		init.platformData.type = getNativeWindowHandleType (sdlWindow);

		// Enable BGFX logging for debug
		#ifdef HXCPP_DEBUG
		init.callback = &s_bgfxCallback;
		#endif

		// Set resolution
		SDL_GetWindowSizeInPixels (sdlWindow, (int*)&init.resolution.width, (int*)&init.resolution.height);

		// Init bgfx with the config
		return bgfx::init (init);

	}


}


extern "C" int lime_bgfx_register_prims () {

	return 0;

}
