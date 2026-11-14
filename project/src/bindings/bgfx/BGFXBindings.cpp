#ifdef min
#undef min
#endif
#ifdef max
#undef max
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <bgfx/bgfx.h>
#include <bindings/bgfx/BGFXBindings.h>
#include <cstring>
#include <hx/CFFIPrime.h>
#include <map>
#include <set>
#include <shaderc/shaderc.h>
#include <string>
#include <system/CFFIPointer.h>
#include <system/Mutex.h>
#include <system/ValuePointer.h>
#include <ui/Window.h>
#include <utils/ArrayBufferView.h>
#include <utils/Bytes.h>
#include <utils/HaxeResource.h>
#include <vector>

#if defined(IPHONE) || defined(HX_MACOS)
#import <QuartzCore/QuartzCore.h>
#include <SDL3/SDL_metal.h>
#endif

namespace lime
{

	class ShaderCWriter : public bx::WriterI
	{
	  public:
		int32_t write(const void *_data, int32_t _size, bx::Error *) override
		{
			const uint8_t *bytes = static_cast<const uint8_t *>(_data);
			m_buffer.insert(m_buffer.end(), bytes, bytes + _size);
			return _size;
		}

		const bgfx::Memory *finalize()
		{
			if (m_buffer.empty())
				return nullptr;
			const bgfx::Memory *mem = bgfx::alloc(static_cast<uint32_t>(m_buffer.size()));
			std::memcpy(mem->data, m_buffer.data(), m_buffer.size());
			return mem;
		}

		std::string str() const { return std::string(m_buffer.begin(), m_buffer.end()); }

	  private:
		std::vector<uint8_t> m_buffer;
	};

	struct BGFXScreenShotRequest
	{
		std::string filePath;
		AutoGCRoot *data;
		AutoGCRoot *callback;
	};

	static std::vector<BGFXScreenShotRequest> s_screenShotRequests;
	static Mutex s_screenShotRequestsMutex;

	struct BGFXScreenShotData
	{
		BGFXScreenShotRequest request;
		uint32_t width;
		uint32_t height;
		uint32_t pitch;
		bgfx::TextureFormat::Enum format;
		bool yflip;
		std::vector<uint8_t> data;
	};

	static void SDLCALL screenShotMainThreadCallback(void *userdata)
	{
		auto *screenShotData = static_cast<BGFXScreenShotData *>(userdata);

		{
			Bytes bytes(screenShotData->request.data->get());
			bytes.Resize((int)screenShotData->data.size());
			memcpy(bytes.b, screenShotData->data.data(), screenShotData->data.size());
		}

		value screenShot = alloc_empty_object();
		alloc_field(screenShot, val_id("filePath"), alloc_string(screenShotData->request.filePath.c_str()));
		alloc_field(screenShot, val_id("width"), alloc_int((int)screenShotData->width));
		alloc_field(screenShot, val_id("height"), alloc_int((int)screenShotData->height));
		alloc_field(screenShot, val_id("pitch"), alloc_int((int)screenShotData->pitch));
		alloc_field(screenShot, val_id("format"), alloc_int((int)screenShotData->format));
		alloc_field(screenShot, val_id("data"), screenShotData->request.data->get());
		alloc_field(screenShot, val_id("yflip"), alloc_bool(screenShotData->yflip));

		val_call1(screenShotData->request.callback->get(), screenShot);

		delete screenShotData->request.data;
		delete screenShotData->request.callback;
		delete screenShotData;
	}

	class BGFXCallback : public bgfx::CallbackI
	{
	  public:
		void fatal(const char *_filePath, uint16_t _line, bgfx::Fatal::Enum _code, const char *_str) override
		{
			SDL_Log("[BGFX FATAL] (%d) %s at %s:%d", _code, _str, _filePath, _line);
			abort();
		}

		void traceVargs(const char *_filePath, uint16_t _line, const char *_format, va_list _argList) override
		{
#ifdef HXCPP_DEBUG
			char message[2048];
			vsnprintf(message, sizeof(message), _format, _argList);
			SDL_Log("[BGFX] %s", message);
#endif
		}

		void profilerBegin(const char *, uint32_t, const char *, uint16_t) override {}
		void profilerBeginLiteral(const char *, uint32_t, const char *, uint16_t) override {}
		void profilerEnd() override {}
		uint32_t cacheReadSize(uint64_t) override { return 0; }
		bool cacheRead(uint64_t, void *, uint32_t) override { return false; }
		void cacheWrite(uint64_t, const void *, uint32_t) override {}

		void screenShot(const char *_filePath, uint32_t _width, uint32_t _height, uint32_t _pitch, bgfx::TextureFormat::Enum _format, const void *_data, uint32_t _size, bool _yflip) override
		{
			BGFXScreenShotRequest request = {};

			s_screenShotRequestsMutex.Lock();

			for (auto it = s_screenShotRequests.begin(); it != s_screenShotRequests.end(); it++)
			{
				if (it->filePath == _filePath)
				{
					request = *it;
					s_screenShotRequests.erase(it);
					break;
				}
			}

			s_screenShotRequestsMutex.Unlock();

			if (!request.callback) return;

			const uint8_t *data = (const uint8_t *)_data;
			auto *screenShotData = new BGFXScreenShotData{request, _width, _height, _pitch, _format, _yflip, std::vector<uint8_t>(data, data + _size)};

			SDL_RunOnMainThread(screenShotMainThreadCallback, screenShotData, false);
		}

		void captureBegin(uint32_t, uint32_t, uint32_t, bgfx::TextureFormat::Enum, bool) override {}
		void captureEnd() override {}
		void captureFrame(const void *, uint32_t) override {}

	  private:
		std::set<std::string> m_reportedChecks;
		Mutex m_reportedChecksMutex;
	};

	static BGFXCallback s_bgfxCallback;

	std::map<void *, void *> bgfxObjectPtrs;
	std::vector<void *> gc_bgfx_ptr;
	Mutex gc_bgfx_mutex;

	void gc_bgfx_object(value object)
	{
		gc_bgfx_mutex.Lock();

		void *ptr = bgfxObjectPtrs[object];

		if (ptr)
		{
			gc_bgfx_ptr.push_back(ptr);

			bgfxObjectPtrs.erase(object);
		}

		gc_bgfx_mutex.Unlock();
	}

	void gc_bgfx_vertex_buffer(value handle)
	{
		bgfx::VertexBufferHandle *vbuff = (bgfx::VertexBufferHandle *)val_data(handle);

		if (bgfx::isValid(*vbuff))
		{
			bgfx::destroy(*vbuff);
		}

		delete vbuff;
	}

	void gc_bgfx_index_buffer(value handle)
	{
		bgfx::IndexBufferHandle *ibuff = (bgfx::IndexBufferHandle *)val_data(handle);

		if (bgfx::isValid(*ibuff))
		{
			bgfx::destroy(*ibuff);
		}

		delete ibuff;
	}

	void gc_bgfx_shader(value handle)
	{
		bgfx::ShaderHandle *shader = (bgfx::ShaderHandle *)val_data(handle);

		if (bgfx::isValid(*shader))
		{
			bgfx::destroy(*shader);
		}

		delete shader;
	}

	void gc_bgfx_program(value handle)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(handle);

		if (bgfx::isValid(*program))
		{
			bgfx::destroy(*program);
		}

		delete program;
	}

	void gc_bgfx_dynamic_vertex_buffer(value handle)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);

		if (bgfx::isValid(*dvbh))
		{
			bgfx::destroy(*dvbh);
		}

		delete dvbh;
	}

	void gc_bgfx_dynamic_index_buffer(value handle)
	{
		bgfx::DynamicIndexBufferHandle *dibh = (bgfx::DynamicIndexBufferHandle *)val_data(handle);

		if (bgfx::isValid(*dibh))
		{
			bgfx::destroy(*dibh);
		}

		delete dibh;
	}

	void gc_bgfx_occlusion_query(value handle)
	{
		bgfx::OcclusionQueryHandle *oqh = (bgfx::OcclusionQueryHandle *)val_data(handle);

		if (bgfx::isValid(*oqh))
		{
			bgfx::destroy(*oqh);
		}

		delete oqh;
	}

	void gc_bgfx_indirect_buffer(value handle)
	{
		bgfx::IndirectBufferHandle *ixbh = (bgfx::IndirectBufferHandle *)val_data(handle);

		if (bgfx::isValid(*ixbh))
		{
			bgfx::destroy(*ixbh);
		}

		delete ixbh;
	}

	void gc_bgfx_vertex_layout_handle(value handle)
	{
		bgfx::VertexLayoutHandle *vlh = (bgfx::VertexLayoutHandle *)val_data(handle);

		if (bgfx::isValid(*vlh))
		{
			bgfx::destroy(*vlh);
		}

		delete vlh;
	}

	void gc_bgfx_texture(value handle)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(handle);

		if (bgfx::isValid(*th))
		{
			bgfx::destroy(*th);
		}

		delete th;
	}

	void gc_bgfx_uniform(value handle)
	{
		bgfx::UniformHandle *uh = (bgfx::UniformHandle *)val_data(handle);

		if (bgfx::isValid(*uh))
		{
			bgfx::destroy(*uh);
		}

		delete uh;
	}

	void gc_bgfx_frame_buffer(value handle)
	{
		bgfx::FrameBufferHandle *fbh = (bgfx::FrameBufferHandle *)val_data(handle);

		if (bgfx::isValid(*fbh))
		{
			bgfx::destroy(*fbh);
		}

		delete fbh;
	}

	void gc_bgfx_val(value handle)
	{
		void *val = (void *)val_data(handle);

		delete val;
	}

	int lime_bgfx_render_frame()
	{
		return bgfx::renderFrame();
	}

	void lime_bgfx_set_debug(int debug, value handle, int scale)
	{
		bgfx::FrameBufferHandle fbh = BGFX_INVALID_HANDLE;

		if (!val_is_null(handle))
		{
			fbh = *(bgfx::FrameBufferHandle *)val_data(handle);
		}

		bgfx::setDebug((uint32_t)debug, fbh, (uint8_t)scale);
	}

	void lime_bgfx_set_view_clear(int id, int flags, int rgba, double depth, int stencil)
	{
		bgfx::setViewClear((bgfx::ViewId)id, (uint16_t)flags, (uint32_t)rgba, (float)depth, (uint8_t)stencil);
	}

	void lime_bgfx_set_view_clear_depth(int id, int flags, double depth, int stencil)
	{
		bgfx::setViewClear((bgfx::ViewId)id, (uint16_t)flags, (float)depth, (uint8_t)stencil);
	}

	void lime_bgfx_set_view_rect(int id, int x, int y, int width, int height)
	{
		bgfx::setViewRect((bgfx::ViewId)id, (uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height);
	}

	void lime_bgfx_set_view_rect_ratio(int id, int x, int y, int ratio)
	{
		bgfx::setViewRect((bgfx::ViewId)id, (uint16_t)x, (uint16_t)y, (bgfx::BackbufferRatio::Enum)ratio);
	}

	void lime_bgfx_touch(int id)
	{
		bgfx::touch((bgfx::ViewId)id);
	}

	int lime_bgfx_frame(int flags)
	{
		return bgfx::frame(flags);
	}

	value lime_bgfx_get_stats()
	{
		const bgfx::Stats *bgfxStats = bgfx::getStats();

		if (bgfxStats)
		{
			value stats = alloc_empty_object();

			alloc_field(stats, val_id("cpuTimeFrame"), alloc_float((double)bgfxStats->cpuTimeFrame));
			alloc_field(stats, val_id("cpuTimeBegin"), alloc_float((double)bgfxStats->cpuTimeBegin));
			alloc_field(stats, val_id("cpuTimeEnd"), alloc_float((double)bgfxStats->cpuTimeEnd));
			alloc_field(stats, val_id("cpuTimerFreq"), alloc_float((double)bgfxStats->cpuTimerFreq));
			alloc_field(stats, val_id("gpuTimeBegin"), alloc_float((double)bgfxStats->gpuTimeBegin));
			alloc_field(stats, val_id("gpuTimeEnd"), alloc_float((double)bgfxStats->gpuTimeEnd));
			alloc_field(stats, val_id("gpuTimerFreq"), alloc_float((double)bgfxStats->gpuTimerFreq));
			alloc_field(stats, val_id("waitRender"), alloc_float((double)bgfxStats->waitRender));
			alloc_field(stats, val_id("waitSubmit"), alloc_float((double)bgfxStats->waitSubmit));
			alloc_field(stats, val_id("latencySleep"), alloc_float((double)bgfxStats->latencySleep));
			alloc_field(stats, val_id("latencyTotal"), alloc_float((double)bgfxStats->latencyTotal));
			alloc_field(stats, val_id("latencySimulation"), alloc_float((double)bgfxStats->latencySimulation));
			alloc_field(stats, val_id("latencyRenderSubmit"), alloc_float((double)bgfxStats->latencyRenderSubmit));
			alloc_field(stats, val_id("latencyPresent"), alloc_float((double)bgfxStats->latencyPresent));
			alloc_field(stats, val_id("latencyQueue"), alloc_float((double)bgfxStats->latencyQueue));
			alloc_field(stats, val_id("latencyGpu"), alloc_float((double)bgfxStats->latencyGpu));
			alloc_field(stats, val_id("numDraw"), alloc_int((int)bgfxStats->numDraw));
			alloc_field(stats, val_id("numCompute"), alloc_int((int)bgfxStats->numCompute));
			alloc_field(stats, val_id("numBlit"), alloc_int((int)bgfxStats->numBlit));
			alloc_field(stats, val_id("numBlitRepack"), alloc_int((int)bgfxStats->numBlitRepack));
			alloc_field(stats, val_id("numDrawCallsPeak"), alloc_int((int)bgfxStats->numDrawCallsPeak));
			alloc_field(stats, val_id("maxGpuLatency"), alloc_int((int)bgfxStats->maxGpuLatency));
			alloc_field(stats, val_id("gpuFrameNum"), alloc_int((int)bgfxStats->gpuFrameNum));
			alloc_field(stats, val_id("numDynamicIndexBuffers"), alloc_int((int)bgfxStats->numDynamicIndexBuffers));
			alloc_field(stats, val_id("numDynamicVertexBuffers"), alloc_int((int)bgfxStats->numDynamicVertexBuffers));
			alloc_field(stats, val_id("numFrameBuffers"), alloc_int((int)bgfxStats->numFrameBuffers));
			alloc_field(stats, val_id("numIndexBuffers"), alloc_int((int)bgfxStats->numIndexBuffers));
			alloc_field(stats, val_id("numOcclusionQueries"), alloc_int((int)bgfxStats->numOcclusionQueries));
			alloc_field(stats, val_id("numPrograms"), alloc_int((int)bgfxStats->numPrograms));
			alloc_field(stats, val_id("numShaders"), alloc_int((int)bgfxStats->numShaders));
			alloc_field(stats, val_id("numTextures"), alloc_int((int)bgfxStats->numTextures));
			alloc_field(stats, val_id("numUniforms"), alloc_int((int)bgfxStats->numUniforms));
			alloc_field(stats, val_id("numVertexBuffers"), alloc_int((int)bgfxStats->numVertexBuffers));
			alloc_field(stats, val_id("numVertexLayouts"), alloc_int((int)bgfxStats->numVertexLayouts));
			alloc_field(stats, val_id("textureMemoryUsed"), alloc_float((double)bgfxStats->textureMemoryUsed));
			alloc_field(stats, val_id("rtMemoryUsed"), alloc_float((double)bgfxStats->rtMemoryUsed));
			alloc_field(stats, val_id("transientVbUsed"), alloc_int((int)bgfxStats->transientVbUsed));
			alloc_field(stats, val_id("transientIbUsed"), alloc_int((int)bgfxStats->transientIbUsed));

			value numPrims = alloc_array(bgfx::Topology::Count);

			for (int i = 0; i < bgfx::Topology::Count; i++)
			{
				val_array_set_i(numPrims, i, alloc_int(bgfxStats->numPrims[i]));
			}

			alloc_field(stats, val_id("numPrims"), numPrims);

			alloc_field(stats, val_id("gpuMemoryMax"), alloc_float((double)bgfxStats->gpuMemoryMax));
			alloc_field(stats, val_id("gpuMemoryUsed"), alloc_float((double)bgfxStats->gpuMemoryUsed));
			alloc_field(stats, val_id("width"), alloc_int((int)bgfxStats->width));
			alloc_field(stats, val_id("height"), alloc_int((int)bgfxStats->height));
			alloc_field(stats, val_id("textWidth"), alloc_int((int)bgfxStats->textWidth));
			alloc_field(stats, val_id("textHeight"), alloc_int((int)bgfxStats->textHeight));
			alloc_field(stats, val_id("numViews"), alloc_int((int)bgfxStats->numViews));
			alloc_field(stats, val_id("numEncoders"), alloc_int((int)bgfxStats->numEncoders));

			value viewStats = alloc_array(bgfxStats->numViews);

			for (int i = 0; i < bgfxStats->numViews; i++)
			{
				value viewStat = alloc_empty_object();
				alloc_field(viewStat, val_id("name"), alloc_string(bgfxStats->viewStats[i].name));
				alloc_field(viewStat, val_id("view"), alloc_int((int)bgfxStats->viewStats[i].view));
				alloc_field(viewStat, val_id("cpuTimeBegin"), alloc_float((double)bgfxStats->viewStats[i].cpuTimeBegin));
				alloc_field(viewStat, val_id("cpuTimeEnd"), alloc_float((double)bgfxStats->viewStats[i].cpuTimeEnd));
				alloc_field(viewStat, val_id("gpuTimeBegin"), alloc_float((double)bgfxStats->viewStats[i].gpuTimeBegin));
				alloc_field(viewStat, val_id("gpuTimeEnd"), alloc_float((double)bgfxStats->viewStats[i].gpuTimeEnd));
				alloc_field(viewStat, val_id("gpuFrameNum"), alloc_int((int)bgfxStats->viewStats[i].gpuFrameNum));
				val_array_set_i(viewStats, i, viewStat);
			}

			alloc_field(stats, val_id("viewStats"), viewStats);

			value encoderStats = alloc_array(bgfxStats->numEncoders);

			for (int i = 0; i < bgfxStats->numEncoders; i++)
			{
				value encoderStat = alloc_empty_object();
				alloc_field(encoderStat, val_id("cpuTimeBegin"), alloc_float((double)bgfxStats->encoderStats[i].cpuTimeBegin));
				alloc_field(encoderStat, val_id("cpuTimeEnd"), alloc_float((double)bgfxStats->encoderStats[i].cpuTimeEnd));
				val_array_set_i(encoderStats, i, encoderStat);
			}

			alloc_field(stats, val_id("encoderStats"), encoderStats);

			return stats;
		}

		return alloc_null();
	}

	void lime_bgfx_dbg_text_clear(int attr, bool _small)
	{
		bgfx::dbgTextClear((uint8_t)attr, _small);
	}

	void lime_bgfx_dbg_text_printf(int x, int y, int attr, HxString text)
	{
		bgfx::dbgTextPrintf((uint16_t)x, (uint16_t)y, (uint8_t)attr, "%s", hxs_utf8(text, nullptr));
	}

	void lime_bgfx_dbg_text_image(int x, int y, int width, int height, double data, int pitch)
	{
		bgfx::dbgTextImage((uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height, (const void *)(uintptr_t)data, (uint16_t)pitch);
	}

	value lime_bgfx_register_object(value object)
	{
		value handle = CFFIPointer(object, gc_bgfx_object);
		bgfxObjectPtrs[object] = handle;
		return handle;
	}

	value lime_bgfx_create_vertex_layout()
	{
		return CFFIPointer(new bgfx::VertexLayout(), gc_bgfx_val);
	}

	void lime_bgfx_vertex_layout_begin(value handle, int backend)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		v_layout->begin((bgfx::RendererType::Enum)backend);
	}

	void lime_bgfx_vertex_layout_add(value handle, int attrib, int num, int type, bool normalized, bool asInt)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		v_layout->add((bgfx::Attrib::Enum)attrib, num, (bgfx::AttribType::Enum)type, normalized, asInt);
	}

	value lime_bgfx_vertex_layout_decode(value handle, int attrib)
	{
		uint8_t num;
		bgfx::AttribType::Enum type;
		bool normalized;
		bool asInt;

		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);

		v_layout->decode((bgfx::Attrib::Enum)attrib, num, type, normalized, asInt);

		value obj = alloc_empty_object();
		alloc_field(obj, val_id("num"), alloc_int((int)num));
		alloc_field(obj, val_id("type"), alloc_int((int)type));
		alloc_field(obj, val_id("normalized"), alloc_bool(normalized));
		alloc_field(obj, val_id("asInt"), alloc_bool(asInt));
		return obj;
	}

	bool lime_bgfx_vertex_layout_has(value handle, int attrib)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		return v_layout->has((bgfx::Attrib::Enum)attrib);
	}

	void lime_bgfx_vertex_layout_skip(value handle, int num)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		v_layout->skip(num);
	}

	void lime_bgfx_vertex_layout_end(value handle)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		v_layout->end();
	}

	int lime_bgfx_vertex_layout_get_offset(value handle, int attrib)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		return v_layout->getOffset((bgfx::Attrib::Enum)attrib);
	}

	int lime_bgfx_vertex_layout_get_stride(value handle)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		return v_layout->getStride();
	}

	int lime_bgfx_vertex_layout_get_size(value handle, int num)
	{
		bgfx::VertexLayout *v_layout = (bgfx::VertexLayout *)val_data(handle);
		return v_layout->getSize(num);
	}

	value lime_bgfx_make_ref(double data, int size)
	{
		const bgfx::Memory *ref = bgfx::makeRef((const void *)(uintptr_t)data, (uint32_t)size);
		return CFFIPointer(const_cast<bgfx::Memory *>(ref));
	}

	value lime_bgfx_create_vertex_buffer(value _mem, value _layout, int flags)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(_layout);
		bgfx::VertexBufferHandle *vbh = new bgfx::VertexBufferHandle(bgfx::createVertexBuffer(mem, *layout, (uint16_t)flags));
		return CFFIPointer(vbh, gc_bgfx_vertex_buffer);
	}

	value lime_bgfx_create_index_buffer(value _mem, int flags)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::IndexBufferHandle *ibh = new bgfx::IndexBufferHandle(bgfx::createIndexBuffer(mem, (uint16_t)flags));
		return CFFIPointer(ibh, gc_bgfx_index_buffer);
	}

	value lime_bgfx_create_shader(value _mem)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::ShaderHandle *shader = new bgfx::ShaderHandle(bgfx::createShader(mem));
		return CFFIPointer(shader, gc_bgfx_shader);
	}

	value lime_bgfx_create_program(value _vsh, value _fsh, bool destroyShaders)
	{
		bgfx::ShaderHandle *vsh = (bgfx::ShaderHandle *)val_data(_vsh);

		bgfx::ShaderHandle *fsh = (bgfx::ShaderHandle *)val_data(_fsh);

		bgfx::ProgramHandle *program = new bgfx::ProgramHandle(bgfx::createProgram(*vsh, *fsh, destroyShaders));

		if (destroyShaders)
		{
			vsh->idx = bgfx::kInvalidHandle;

			fsh->idx = bgfx::kInvalidHandle;
		}

		return CFFIPointer(program, gc_bgfx_program);
	}

	value lime_bgfx_create_compute_program(value _vsh, bool destroyShaders)
	{
		bgfx::ShaderHandle *vsh = (bgfx::ShaderHandle *)val_data(_vsh);

		bgfx::ProgramHandle *program = new bgfx::ProgramHandle(bgfx::createProgram(*vsh, destroyShaders));

		if (destroyShaders)
		{
			vsh->idx = bgfx::kInvalidHandle;
		}

		return CFFIPointer(program, gc_bgfx_program);
	}

	void lime_bgfx_set_vertex_buffer(int stream, value handle)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, *vbh);
	}

	void lime_bgfx_set_vertex_buffer_vertices(int stream, value handle, int startVertex, int numVertices)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, *vbh, (uint32_t)startVertex, (uint32_t)numVertices);
	}

	void lime_bgfx_set_vertex_buffer_layout(int stream, value handle, int startVertex, int numVertices, value _layout)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::VertexLayoutHandle *layout = (bgfx::VertexLayoutHandle *)val_data(_layout);
		bgfx::setVertexBuffer((uint8_t)stream, *vbh, (uint32_t)startVertex, (uint32_t)numVertices, *layout);
	}

	void lime_bgfx_set_dynamic_vertex_buffer(int stream, value handle)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, *dvbh);
	}

	void lime_bgfx_set_dynamic_vertex_buffer_vertices(int stream, value handle, int startVertex, int numVertices)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, *dvbh, (uint32_t)startVertex, (uint32_t)numVertices);
	}

	void lime_bgfx_set_dynamic_vertex_buffer_layout(int stream, value handle, int startVertex, int numVertices, value _layout)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		bgfx::VertexLayoutHandle *layout = (bgfx::VertexLayoutHandle *)val_data(_layout);
		bgfx::setVertexBuffer((uint8_t)stream, *dvbh, (uint32_t)startVertex, (uint32_t)numVertices, *layout);
	}

	void lime_bgfx_set_transient_vertex_buffer(int stream, value handle)
	{
		bgfx::TransientVertexBuffer *tvb = (bgfx::TransientVertexBuffer *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, tvb);
	}

	void lime_bgfx_set_transient_vertex_buffer_vertices(int stream, value handle, int startVertex, int numVertices)
	{
		bgfx::TransientVertexBuffer *tvb = (bgfx::TransientVertexBuffer *)val_data(handle);
		bgfx::setVertexBuffer((uint8_t)stream, tvb, (uint32_t)startVertex, (uint32_t)numVertices);
	}

	void lime_bgfx_set_transient_vertex_buffer_layout(int stream, value handle, int startVertex, int numVertices, value _layout)
	{
		bgfx::TransientVertexBuffer *tvb = (bgfx::TransientVertexBuffer *)val_data(handle);
		bgfx::VertexLayoutHandle *layout = (bgfx::VertexLayoutHandle *)val_data(_layout);
		bgfx::setVertexBuffer((uint8_t)stream, tvb, (uint32_t)startVertex, (uint32_t)numVertices, *layout);
	}

	void lime_bgfx_set_index_buffer(value handle)
	{
		bgfx::IndexBufferHandle *ibh = (bgfx::IndexBufferHandle *)val_data(handle);
		bgfx::setIndexBuffer(*ibh);
	}

	void lime_bgfx_set_index_buffer_indices(value handle, int firstIndex, int numIndices)
	{
		bgfx::IndexBufferHandle *ibh = (bgfx::IndexBufferHandle *)val_data(handle);
		bgfx::setIndexBuffer(*ibh, (uint32_t)firstIndex, (uint32_t)numIndices);
	}

	void lime_bgfx_set_dynamic_index_buffer(value handle)
	{
		bgfx::DynamicIndexBufferHandle *dibh = (bgfx::DynamicIndexBufferHandle *)val_data(handle);
		bgfx::setIndexBuffer(*dibh);
	}

	void lime_bgfx_set_dynamic_index_buffer_indices(value handle, int firstIndex, int numIndices)
	{
		bgfx::DynamicIndexBufferHandle *dibh = (bgfx::DynamicIndexBufferHandle *)val_data(handle);
		bgfx::setIndexBuffer(*dibh, (uint32_t)firstIndex, (uint32_t)numIndices);
	}

	void lime_bgfx_set_transient_index_buffer(value handle)
	{
		bgfx::TransientIndexBuffer *tib = (bgfx::TransientIndexBuffer *)val_data(handle);
		bgfx::setIndexBuffer(tib);
	}

	void lime_bgfx_set_transient_index_buffer_indices(value handle, int firstIndex, int numIndices)
	{
		bgfx::TransientIndexBuffer *tib = (bgfx::TransientIndexBuffer *)val_data(handle);
		bgfx::setIndexBuffer(tib, (uint32_t)firstIndex, (uint32_t)numIndices);
	}

	static uint64_t mergeUInt64(int high, int low)
	{
		return (uint64_t)(uint32_t)high << 32 | (uint32_t)low;
	}

	void lime_bgfx_set_state(int stateA, int stateB, int rgba)
	{
		uint64_t state = mergeUInt64(stateA, stateB);
		bgfx::setState(state, (uint32_t)rgba);
	}

	void lime_bgfx_set_view_transform(int id, double view, double proj)
	{
		bgfx::setViewTransform((bgfx::ViewId)id, (const void *)(uintptr_t)view, (const void *)(uintptr_t)proj);
	}

	int lime_bgfx_set_transform(double mtx, int num)
	{
		return (int)bgfx::setTransform((const void *)(uintptr_t)mtx, (uint16_t)num);
	}

	void lime_bgfx_submit(int id, value handle, int depth, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(handle);
		bgfx::submit((bgfx::ViewId)id, *program, (uint32_t)depth, (uint8_t)flags);
	}

	void lime_bgfx_submit_occlusion_query(int id, value program_handle, value oqh_handle, int depth, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(program_handle);
		bgfx::OcclusionQueryHandle *oqh = (bgfx::OcclusionQueryHandle *)val_data(oqh_handle);
		bgfx::submit((bgfx::ViewId)id, *program, *oqh, (uint32_t)depth, (uint8_t)flags);
	}

	void lime_bgfx_submit_indirect_buffer(int id, value program_handle, value ixbh_handle, int start, int num, int depth, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(program_handle);
		bgfx::IndirectBufferHandle *ixbh = (bgfx::IndirectBufferHandle *)val_data(ixbh_handle);
		bgfx::submit((bgfx::ViewId)id, *program, *ixbh, (uint32_t)start, (uint32_t)num, (uint32_t)depth, (uint8_t)flags);
	}

	void lime_bgfx_submit_indirect_index_buffer(int id, value program_handle, value ixbh_handle, int start, value ibh_handle, int numMax, int depth, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(program_handle);
		bgfx::IndirectBufferHandle *ixbh = (bgfx::IndirectBufferHandle *)val_data(ixbh_handle);
		bgfx::IndexBufferHandle *ibh = (bgfx::IndexBufferHandle *)val_data(ibh_handle);
		bgfx::submit((bgfx::ViewId)id, *program, *ixbh, (uint32_t)start, *ibh, (uint32_t)numMax, (uint32_t)depth, (uint8_t)flags);
	}

	value lime_bgfx_create_occlusion_query()
	{
		bgfx::OcclusionQueryHandle *oqh = new bgfx::OcclusionQueryHandle(bgfx::createOcclusionQuery());
		return CFFIPointer(oqh, gc_bgfx_occlusion_query);
	}

	value lime_bgfx_get_occlusion_query_result(value handle)
	{
		bgfx::OcclusionQueryHandle *oqh = (bgfx::OcclusionQueryHandle *)val_data(handle);
		int32_t num = 0;
		bgfx::OcclusionQueryResult::Enum result = bgfx::getResult(*oqh, &num);

		value obj = alloc_empty_object();
		alloc_field(obj, val_id("result"), alloc_int((int)result));
		alloc_field(obj, val_id("num"), alloc_int((int)num));
		return obj;
	}

	value lime_bgfx_create_indirect_buffer(int num)
	{
		bgfx::IndirectBufferHandle *ixbh = new bgfx::IndirectBufferHandle(bgfx::createIndirectBuffer((uint32_t)num));
		return CFFIPointer(ixbh, gc_bgfx_indirect_buffer);
	}

	value lime_bgfx_create_dynamic_vertex_buffer(int num, value handle, int flags)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(handle);
		bgfx::DynamicVertexBufferHandle *dvbh = new bgfx::DynamicVertexBufferHandle(bgfx::createDynamicVertexBuffer((uint32_t)num, *layout, (uint16_t)flags));
		return CFFIPointer(dvbh, gc_bgfx_dynamic_vertex_buffer);
	}

	value lime_bgfx_create_dynamic_vertex_buffer_mem(value mem_handle, value layout_handle, int flags)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(mem_handle);
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(layout_handle);
		bgfx::DynamicVertexBufferHandle *dvbh = new bgfx::DynamicVertexBufferHandle(bgfx::createDynamicVertexBuffer(mem, *layout, (uint16_t)flags));
		return CFFIPointer(dvbh, gc_bgfx_dynamic_vertex_buffer);
	}

	void lime_bgfx_update_dynamic_vertex_buffer(value handle, int startVertex, value _mem)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::update(*dvbh, (uint32_t)startVertex, mem);
	}

	value lime_bgfx_create_dynamic_index_buffer(int num, int flags)
	{
		bgfx::DynamicIndexBufferHandle *dibh = new bgfx::DynamicIndexBufferHandle(bgfx::createDynamicIndexBuffer((uint32_t)num, (uint16_t)flags));
		return CFFIPointer(dibh, gc_bgfx_dynamic_index_buffer);
	}

	value lime_bgfx_create_dynamic_index_buffer_mem(value handle, int flags)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(handle);
		bgfx::DynamicIndexBufferHandle *dibh = new bgfx::DynamicIndexBufferHandle(bgfx::createDynamicIndexBuffer(mem, (uint16_t)flags));
		return CFFIPointer(dibh, gc_bgfx_dynamic_index_buffer);
	}

	void lime_bgfx_update_dynamic_index_buffer(value handle, int firstIndex, value _mem)
	{
		bgfx::DynamicIndexBufferHandle *dibh = (bgfx::DynamicIndexBufferHandle *)val_data(handle);
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::update(*dibh, (uint32_t)firstIndex, mem);
	}

	value lime_bgfx_alloc_transient_vertex_buffer(int num, value handle)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(handle);
		bgfx::TransientVertexBuffer *tvb = new bgfx::TransientVertexBuffer();
		bgfx::allocTransientVertexBuffer(tvb, (uint32_t)num, *layout);
		return CFFIPointer(tvb, gc_bgfx_val);
	}

	value lime_bgfx_alloc_transient_index_buffer(int num, bool index32)
	{
		bgfx::TransientIndexBuffer *tib = new bgfx::TransientIndexBuffer();
		bgfx::allocTransientIndexBuffer(tib, (uint32_t)num, index32);
		return CFFIPointer(tib, gc_bgfx_val);
	}

	bool lime_bgfx_get_transient_vertex_buffer_data(value handle, value buffer)
	{
		bgfx::TransientVertexBuffer *tvb = (bgfx::TransientVertexBuffer *)val_data(handle);

		if (!tvb || !tvb->data || tvb->size == 0)
		{
			return false;
		}

		ArrayBufferView abv(buffer);

		abv.buffer->Resize(tvb->size);

		memcpy(abv.buffer->b, tvb->data, tvb->size);

		abv.byteLength = (int)tvb->size;

		abv.length = (int)tvb->size;

		return true;
	}

	void lime_bgfx_set_transient_vertex_buffer_data(value handle, double data, int size)
	{
		bgfx::TransientVertexBuffer *tvb = (bgfx::TransientVertexBuffer *)val_data(handle);

		if (!tvb || !tvb->data || !data || size <= 0)
		{
			return;
		}

		uint32_t copySize = (uint32_t)size < tvb->size ? (uint32_t)size : tvb->size;

		memcpy(tvb->data, (const void *)(uintptr_t)data, copySize);
	}

	bool lime_bgfx_get_transient_index_buffer_data(value handle, value buffer)
	{
		bgfx::TransientIndexBuffer *tib = (bgfx::TransientIndexBuffer *)val_data(handle);

		if (!tib || !tib->data || tib->size == 0)
		{
			return false;
		}

		ArrayBufferView abv(buffer);

		abv.buffer->Resize(tib->size);

		memcpy(abv.buffer->b, tib->data, tib->size);

		abv.byteLength = (int)tib->size;

		abv.length = (int)tib->size;

		return true;
	}

	void lime_bgfx_set_transient_index_buffer_data(value handle, double data, int size)
	{
		bgfx::TransientIndexBuffer *tib = (bgfx::TransientIndexBuffer *)val_data(handle);

		if (!tib || !tib->data || !data || size <= 0)
		{
			return;
		}

		uint32_t copySize = (uint32_t)size < tib->size ? (uint32_t)size : tib->size;

		memcpy(tib->data, (const void *)(uintptr_t)data, copySize);
	}

	int lime_bgfx_get_avail_transient_vertex_buffer(int num, value handle)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(handle);
		return bgfx::getAvailTransientVertexBuffer((uint32_t)num, *layout);
	}

	int lime_bgfx_get_avail_transient_index_buffer(int num, bool index32)
	{
		return bgfx::getAvailTransientIndexBuffer((uint32_t)num, index32);
	}

	value lime_bgfx_register_vertex_layout(value handle)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(handle);
		bgfx::VertexLayoutHandle *vlh = new bgfx::VertexLayoutHandle(bgfx::createVertexLayout(*layout));
		return CFFIPointer(vlh, gc_bgfx_vertex_layout_handle);
	}

	value lime_bgfx_get_caps()
	{
		const bgfx::Caps *caps = bgfx::getCaps();

		if (caps)
		{
			value obj = alloc_empty_object();

			alloc_field(obj, val_id("rendererType"), alloc_int((int)caps->rendererType));
			alloc_field(obj, val_id("__supportedHigh"), alloc_int((int)(caps->supported >> 32)));
			alloc_field(obj, val_id("__supportedLow"), alloc_int((int)(caps->supported & 0xFFFFFFFF)));
			alloc_field(obj, val_id("vendorId"), alloc_int((int)caps->vendorId));
			alloc_field(obj, val_id("deviceId"), alloc_int((int)caps->deviceId));
			alloc_field(obj, val_id("homogeneousDepth"), alloc_bool(caps->homogeneousDepth));
			alloc_field(obj, val_id("originBottomLeft"), alloc_bool(caps->originBottomLeft));
			alloc_field(obj, val_id("numGPUs"), alloc_int((int)caps->numGPUs));

			value gpus = alloc_array(caps->numGPUs);

			for (int i = 0; i < caps->numGPUs; i++)
			{
				value gpu = alloc_empty_object();
				alloc_field(gpu, val_id("vendorId"), alloc_int((int)caps->gpu[i].vendorId));
				alloc_field(gpu, val_id("deviceId"), alloc_int((int)caps->gpu[i].deviceId));
				val_array_set_i(gpus, i, gpu);
			}

			alloc_field(obj, val_id("gpus"), gpus);

			value limits = alloc_empty_object();

			alloc_field(limits, val_id("maxDrawCalls"), alloc_int((int)caps->limits.maxDrawCalls));
			alloc_field(limits, val_id("maxBlits"), alloc_int((int)caps->limits.maxBlits));
			alloc_field(limits, val_id("maxTextureSize"), alloc_int((int)caps->limits.maxTextureSize));
			alloc_field(limits, val_id("maxTextureLayers"), alloc_int((int)caps->limits.maxTextureLayers));
			alloc_field(limits, val_id("maxViews"), alloc_int((int)caps->limits.maxViews));
			alloc_field(limits, val_id("maxFrameBuffers"), alloc_int((int)caps->limits.maxFrameBuffers));
			alloc_field(limits, val_id("maxFBAttachments"), alloc_int((int)caps->limits.maxFBAttachments));
			alloc_field(limits, val_id("maxPrograms"), alloc_int((int)caps->limits.maxPrograms));
			alloc_field(limits, val_id("maxShaders"), alloc_int((int)caps->limits.maxShaders));
			alloc_field(limits, val_id("maxTextures"), alloc_int((int)caps->limits.maxTextures));
			alloc_field(limits, val_id("maxTextureSamplers"), alloc_int((int)caps->limits.maxTextureSamplers));
			alloc_field(limits, val_id("maxComputeBindings"), alloc_int((int)caps->limits.maxComputeBindings));
			alloc_field(limits, val_id("maxVertexLayouts"), alloc_int((int)caps->limits.maxVertexLayouts));
			alloc_field(limits, val_id("maxVertexStreams"), alloc_int((int)caps->limits.maxVertexStreams));
			alloc_field(limits, val_id("maxVertexAttributes"), alloc_int((int)caps->limits.maxVertexAttributes));
			alloc_field(limits, val_id("maxInstanceData"), alloc_int((int)caps->limits.maxInstanceData));
			alloc_field(limits, val_id("maxIndexBuffers"), alloc_int((int)caps->limits.maxIndexBuffers));
			alloc_field(limits, val_id("maxVertexBuffers"), alloc_int((int)caps->limits.maxVertexBuffers));
			alloc_field(limits, val_id("maxDynamicIndexBuffers"), alloc_int((int)caps->limits.maxDynamicIndexBuffers));
			alloc_field(limits, val_id("maxDynamicVertexBuffers"), alloc_int((int)caps->limits.maxDynamicVertexBuffers));
			alloc_field(limits, val_id("maxUniforms"), alloc_int((int)caps->limits.maxUniforms));
			alloc_field(limits, val_id("maxOcclusionQueries"), alloc_int((int)caps->limits.maxOcclusionQueries));
			alloc_field(limits, val_id("maxEncoders"), alloc_int((int)caps->limits.maxEncoders));
			alloc_field(limits, val_id("minResourceCbSize"), alloc_int((int)caps->limits.minResourceCbSize));
			alloc_field(limits, val_id("maxTransientVbSize"), alloc_int((int)caps->limits.maxTransientVbSize));
			alloc_field(limits, val_id("maxTransientIbSize"), alloc_int((int)caps->limits.maxTransientIbSize));
			alloc_field(limits, val_id("minUniformBufferSize"), alloc_int((int)caps->limits.minUniformBufferSize));
			alloc_field(limits, val_id("minUniformCacheSize"), alloc_int((int)caps->limits.minUniformCacheSize));
			alloc_field(limits, val_id("blitRowPitchAlign"), alloc_int((int)caps->limits.blitRowPitchAlign));
			alloc_field(limits, val_id("blitOffsetAlign"), alloc_int((int)caps->limits.blitOffsetAlign));
			alloc_field(obj, val_id("limits"), limits);

			value formats = alloc_array((int)bgfx::TextureFormat::Count);

			for (int i = 0; i < (int)bgfx::TextureFormat::Count; i++)
			{
				val_array_set_i(formats, i, alloc_int((int)caps->formats[i]));
			}

			alloc_field(obj, val_id("formats"), formats);

			return obj;
		}

		return alloc_null();
	}

	static bool shaderReadFile(const char *path, std::string &out, void *)
	{
		size_t size = 0;

		void *data = SDL_LoadFile(path, &size);

		if (data)
		{
			out.append((const char *)data, size);
			SDL_free(data);

			return true;
		}

		std::vector<unsigned char> resource;

		if (HaxeResource::GetBytes(path, resource))
		{
			out.append((const char *)resource.data(), resource.size());

			return true;
		}

		return false;
	}

	static std::string __lastShaderMessage;

	static value compileShader(int type, const char *src, const char *varying, const char *defs, const char *prof, const char *includeDirs, const char *inputFilePath)
	{
		char shaderType;

		switch (type)
		{
			case 0:
				shaderType = 'v';
				break;
			case 1:
				shaderType = 'f';
				break;
			case 2:
				shaderType = 'c';
				break;
			default:
				return alloc_null();
		}

		if (!src || !*src)
		{
			return alloc_null();
		}

		bgfx::Options options;

		options.shaderType = shaderType;
		options.inputFilePath = inputFilePath;
		options.readFile = shaderReadFile;

		if (includeDirs && *includeDirs)
		{
			options.includeDirs.push_back(includeDirs);
		}

#if defined(ANDROID)
		options.platform = "android";
#elif defined(HX_LINUX)
		options.platform = "linux";
#elif defined(IPHONE)
		options.platform = "ios";
#elif defined(HX_MACOS)
		options.platform = "osx";
#elif defined(HX_WINDOWS)
		options.platform = "windows";
#endif

		if (prof && *prof)
		{
			options.profile = prof;
		}
		else
		{
			switch (bgfx::getRendererType())
			{
				case bgfx::RendererType::Direct3D11:
					options.profile = (shaderType == 'c') ? "cs_5_0" : "s_5_0";
					break;
				case bgfx::RendererType::Direct3D12:
					options.profile = "s_5_0";
					break;
				case bgfx::RendererType::OpenGL:
					options.profile = (shaderType == 'c') ? "430" : "330";
					break;
				case bgfx::RendererType::OpenGLES:
					options.profile = (shaderType == 'c') ? "310_es" : "300_es";
					break;
				case bgfx::RendererType::Metal:
					options.profile = "metal23-14";
					break;
				case bgfx::RendererType::Vulkan:
					options.profile = "spirv";
					break;
				default:
					options.profile = "";
					break;
			}
		}

		if (options.profile.empty())
		{
			return alloc_null();
		}

		if (defs)
		{
			const char *d = defs;

			while (*d)
			{
				while (*d == ' ' || *d == '\t')
					d++;
				const char *e = d;
				while (*e && *e != ';')
					e++;
				if (e > d)
					options.defines.emplace_back(d, e);
				d = (*e == ';') ? e + 1 : e;
			}
		}

		const size_t padding = 16384;
		uint32_t srcLen = src ? static_cast<uint32_t>(std::strlen(src)) : 0;
		char *buf = new char[srcLen + padding + 1]();
		if (src && srcLen)
			std::memcpy(buf, src, srcLen);
		buf[srcLen] = '\n';

		ShaderCWriter sOut, mOut;

		bool compiled = bgfx::compileShader(varying ? varying : "", "", buf, srcLen, options, &sOut, &mOut);

		__lastShaderMessage = mOut.str();

		if (compiled)
		{
			const bgfx::Memory *mem = sOut.finalize();

			if (mem)
			{
				return CFFIPointer(const_cast<bgfx::Memory *>(mem));
			}
		}

		return alloc_null();
	}

	value lime_bgfx_compile_shader_string(int type, HxString shaderSource, HxString varyingDef, HxString defines, HxString profile, HxString includeDirs)
	{
		return compileShader(type, hxs_utf8(shaderSource, nullptr), hxs_utf8(varyingDef, nullptr), hxs_utf8(defines, nullptr), hxs_utf8(profile, nullptr), hxs_utf8(includeDirs, nullptr), "<string>");
	}

	HxString lime_bgfx_get_last_shader_message()
	{
		return __lastShaderMessage.empty() ? HxString(0, 0) : HxString(__lastShaderMessage.c_str());
	}

	static char *loadShaderSource(const char *path)
	{
		size_t size = 0;
		char *data = (char *)SDL_LoadFile(path, &size);
		if (data)
			return data;

		std::vector<unsigned char> resource;

		if (HaxeResource::GetBytes(path, resource))
		{
			size_t size = resource.size();
			char *copy = (char *)SDL_malloc(size + 1);
			if (size > 0)
				memcpy(copy, resource.data(), size);
			copy[size] = '\0';

			return copy;
		}

		return NULL;
	}

	value lime_bgfx_compile_shader_file(int type, HxString filePath, HxString varyingPath, HxString defines, HxString profile, HxString includeDirs)
	{
		const char *path = hxs_utf8(filePath, nullptr);
		const char *varyingFile = hxs_utf8(varyingPath, nullptr);

		if (!path || !*path)
		{
			return alloc_null();
		}

		char *src = loadShaderSource(path);

		if (!src)
		{
			return alloc_null();
		}

		char *varying = NULL;

		if (varyingFile && *varyingFile)
		{
			varying = loadShaderSource(varyingFile);
		}

		value result = compileShader(type, src, varying ? varying : "", hxs_utf8(defines, nullptr), hxs_utf8(profile, nullptr), hxs_utf8(includeDirs, nullptr), path);

		SDL_free(src);

		if (varying)
		{
			SDL_free(varying);
		}

		return result;
	}

	static int valFieldToInt(value object, const char *name, int defaultValue)
	{
		value field = val_field(object, val_id(name));
		return val_is_null(field) ? defaultValue : val_int(field);
	}

	static bgfx::Attachment valToAttachment(value object)
	{
		bgfx::TextureHandle *handle = (bgfx::TextureHandle *)val_data(val_field(object, val_id("handle")));

		bgfx::Attachment attachment;
		attachment.init(*handle, (bgfx::Access::Enum)valFieldToInt(object, "access", bgfx::Access::Write), (uint16_t)valFieldToInt(object, "layer", 0), (uint16_t)valFieldToInt(object, "numLayers", 1), (uint16_t)valFieldToInt(object, "mip", 0), (uint8_t)valFieldToInt(object, "flags", BGFX_ATTACHMENT_AUTO_GEN_MIPS));
		return attachment;
	}

	static bgfx::TextureRegion valToTextureRegion(value object)
	{
		bgfx::TextureRegion region;
		region.handle = *(bgfx::TextureHandle *)val_data(val_field(object, val_id("handle")));
		region.mip = (uint8_t)valFieldToInt(object, "mip", 0);
		region.x = (uint16_t)valFieldToInt(object, "x", 0);
		region.y = (uint16_t)valFieldToInt(object, "y", 0);
		region.z = (uint16_t)valFieldToInt(object, "z", 0);
		region.width = (uint16_t)valFieldToInt(object, "width", 0);
		region.height = (uint16_t)valFieldToInt(object, "height", 0);
		region.depth = (uint16_t)valFieldToInt(object, "depth", 0);
		return region;
	}

#if defined(IPHONE) || defined(HX_MACOS)
	SDL_MetalView mtlView = NULL;

	static void configureMetalLayer(bool vsync)
	{
		if (mtlView)
		{
			CAMetalLayer *metalLayer = (__bridge CAMetalLayer *)SDL_Metal_GetLayer(mtlView);

			if (![metalLayer isKindOfClass:[CAMetalLayer class]])
			{
				return;
			}

			// Apple documents that when this variable is false, `nextDrawable()` would stall the main thread
			// if it doesn't have a frame until it gets one
			// But when true, if it doesn't get anything after one second then it returns null instead.
			// BGFX properly accounts for incase it returned a null drawable, and we don't want our main thread randomly getting stalled by that
			// Which seems to be mostly down to your display's refresh rate hence only enable it on V-Sync.
			metalLayer.allowsNextDrawableTimeout = !vsync;

			// This is meant to allow the backbuffer to be a readable GPU texture.
			// Apple states having the backbuffer readable would impacts performance but it doesn't seem to actually do that
			// Infact, it allows more FPS! On the default (YES) metal only presents a maximum of `refreshrate * 6` to the screen.
			// If we are in direct-to-display then the main loop is forced on that present cap.
			// On composited presentation mode, the main loop can run free but metal would still be presenting only by that cap, marking the rest of your frames as missed.
			// With it disabled, we are allowed to push upto 1050 FPS on the main loop and to the MacOS WindowServer.
			metalLayer.framebufferOnly = NO;
		}
	}

	void BGFXBindings::SetMetalLayerComposited(bool composit)
	{
		if (mtlView)
		{
			CAMetalLayer *metalLayer = (__bridge CAMetalLayer *)SDL_Metal_GetLayer(mtlView);

			if (![metalLayer isKindOfClass:[CAMetalLayer class]])
			{
				return;
			}

			metalLayer.opaque = !composit;
		}
	}
#endif

	static void *getNativeWindowHandle(SDL_Window *sdlWindow);

	static void *getNativeDisplayHandle(SDL_Window *sdlWindow);

	static bgfx::SwapChain valToSwapChain(value object, value window)
	{
		bgfx::SwapChain swapChain;

		// Don't bother with having NWHs and NDTs on lime
		// get it from the lime window instead
		if (!val_is_null(window))
		{
			SDL_Window *sdlWindow = ((Window *)val_data(window))->sdlWindow;
			swapChain.nwh = getNativeWindowHandle(sdlWindow);
			swapChain.ndt = getNativeDisplayHandle(sdlWindow);
		}

		swapChain.width = (uint32_t)valFieldToInt(object, "width", 0);
		swapChain.height = (uint32_t)valFieldToInt(object, "height", 0);
		swapChain.flags = (uint32_t)valFieldToInt(object, "flags", BGFX_SWAP_CHAIN_NONE);
		swapChain.formatColor = (bgfx::TextureFormat::Enum)valFieldToInt(object, "formatColor", bgfx::TextureFormat::Count);
		swapChain.formatDepthStencil = (bgfx::TextureFormat::Enum)valFieldToInt(object, "formatDepthStencil", bgfx::TextureFormat::Count);

		value depth = val_field(object, val_id("depth"));

		if (!val_is_null(depth))
		{
			swapChain.depth = *(bgfx::TextureHandle *)val_data(depth);
		}

		swapChain.numBackBuffers = (uint8_t)valFieldToInt(object, "numBackBuffers", 0);
		swapChain.maxFrameLatency = (uint8_t)valFieldToInt(object, "maxFrameLatency", 0);
		return swapChain;
	}

	static bool __initialized = false;

	static uint32_t __resetFlags = BGFX_RESET_NONE;

	static bgfx::SwapChain __swapChain;

	void lime_bgfx_reset(int flags, value swapChain, value window)
	{
		__resetFlags = (uint32_t)flags;

		if (val_is_null(swapChain))
		{
			bgfx::reset(__resetFlags);
		}
		else
		{
			__swapChain = valToSwapChain(swapChain, window);
			bgfx::reset(__resetFlags, &__swapChain);
		}

#if defined(IPHONE) || defined(HX_MACOS)
		configureMetalLayer((flags & BGFX_RESET_VSYNC));
#endif
	}

	value lime_bgfx_create_uniform(HxString name, int type, int num)
	{
		bgfx::UniformHandle *uniform = new bgfx::UniformHandle(bgfx::createUniform(hxs_utf8(name, nullptr), (bgfx::UniformType::Enum)type, (uint16_t)num));
		return CFFIPointer(uniform, gc_bgfx_uniform);
	}

	value lime_bgfx_create_uniform_freq(HxString name, int freq, int type, int num)
	{
		bgfx::UniformHandle *uniform = new bgfx::UniformHandle(bgfx::createUniform(hxs_utf8(name, nullptr), (bgfx::UniformFreq::Enum)freq, (bgfx::UniformType::Enum)type, (uint16_t)num));
		return CFFIPointer(uniform, gc_bgfx_uniform);
	}

	void lime_bgfx_set_uniform(value handle, double data, int num)
	{
		bgfx::UniformHandle *uniform = (bgfx::UniformHandle *)val_data(handle);
		bgfx::setUniform(*uniform, (const void *)(uintptr_t)data, (uint16_t)num);
	}

	void lime_bgfx_set_view_uniform(int id, value handle, double data, int num)
	{
		bgfx::UniformHandle *uniform = (bgfx::UniformHandle *)val_data(handle);
		bgfx::setViewUniform((bgfx::ViewId)id, *uniform, (const void *)(uintptr_t)data, num);
	}

	void lime_bgfx_set_frame_uniform(value handle, double data, int num)
	{
		bgfx::UniformHandle *uniform = (bgfx::UniformHandle *)val_data(handle);
		bgfx::setFrameUniform(*uniform, (const void *)(uintptr_t)data, num);
	}

	value lime_bgfx_get_uniform_info(value handle)
	{
		bgfx::UniformHandle *uniform = (bgfx::UniformHandle *)val_data(handle);
		bgfx::UniformInfo info;
		bgfx::getUniformInfo(*uniform, info);

		value obj = alloc_empty_object();
		alloc_field(obj, val_id("name"), alloc_string(info.name));
		alloc_field(obj, val_id("type"), alloc_int((int)info.type));
		alloc_field(obj, val_id("num"), alloc_int((int)info.num));
		return obj;
	}

	value lime_bgfx_get_shader_uniforms(value handle)
	{
		bgfx::ShaderHandle *shader = (bgfx::ShaderHandle *)val_data(handle);

		uint16_t num = bgfx::getShaderUniforms(*shader);

		std::vector<bgfx::UniformHandle> uniforms(num);

		if (num > 0)
		{
			bgfx::getShaderUniforms(*shader, uniforms.data(), num);
		}

		value result = alloc_array(num);

		for (int i = 0; i < num; i++)
		{
			val_array_set_i(result, i, CFFIPointer(new bgfx::UniformHandle(uniforms[i]), gc_bgfx_val));
		}

		return result;
	}

	value textureHandleToVal(bgfx::TextureHandle handle)
	{
		if (!bgfx::isValid(handle))
		{
			return alloc_null();
		}

		return CFFIPointer(new bgfx::TextureHandle(handle), gc_bgfx_texture);
	}

	value frameBufferHandleToVal(bgfx::FrameBufferHandle handle)
	{
		if (!bgfx::isValid(handle))
		{
			return alloc_null();
		}

		return CFFIPointer(new bgfx::FrameBufferHandle(handle), gc_bgfx_frame_buffer);
	}

	value lime_bgfx_create_texture(value _mem, int flagsHi, int flagsLo, int skip)
	{
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		return textureHandleToVal(bgfx::createTexture(mem, mergeUInt64(flagsHi, flagsLo), (uint8_t)skip));
	}

	value lime_bgfx_create_texture_2d(int width, int height, bool hasMips, int numLayers, int format, int flagsHi, int flagsLo, value _mem)
	{
		const bgfx::Memory *mem = val_is_null(_mem) ? NULL : (const bgfx::Memory *)val_data(_mem);
		return textureHandleToVal(bgfx::createTexture2D((uint16_t)width, (uint16_t)height, hasMips, (uint16_t)numLayers, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo), mem));
	}

	value lime_bgfx_create_texture_2d_scaled(int ratio, bool hasMips, int numLayers, int format, int flagsHi, int flagsLo)
	{
		return textureHandleToVal(bgfx::createTexture2D((bgfx::BackbufferRatio::Enum)ratio, hasMips, (uint16_t)numLayers, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo)));
	}

	value lime_bgfx_create_texture_3d(int width, int height, int depth, bool hasMips, int format, int flagsHi, int flagsLo, value _mem)
	{
		const bgfx::Memory *mem = val_is_null(_mem) ? NULL : (const bgfx::Memory *)val_data(_mem);
		return textureHandleToVal(bgfx::createTexture3D((uint16_t)width, (uint16_t)height, (uint16_t)depth, hasMips, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo), mem));
	}

	value lime_bgfx_create_texture_cube(int size, bool hasMips, int numLayers, int format, int flagsHi, int flagsLo, value _mem)
	{
		const bgfx::Memory *mem = val_is_null(_mem) ? NULL : (const bgfx::Memory *)val_data(_mem);
		return textureHandleToVal(bgfx::createTextureCube((uint16_t)size, hasMips, (uint16_t)numLayers, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo), mem));
	}

	void lime_bgfx_update_texture_2d(value handle, int layer, int mip, int x, int y, int width, int height, value _mem, int pitch)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(handle);
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::updateTexture2D(*th, (uint16_t)layer, (uint8_t)mip, (uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height, mem, (uint16_t)pitch);
	}

	void lime_bgfx_update_texture_3d(value handle, int mip, int x, int y, int z, int width, int height, int depth, value _mem)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(handle);
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::updateTexture3D(*th, (uint8_t)mip, (uint16_t)x, (uint16_t)y, (uint16_t)z, (uint16_t)width, (uint16_t)height, (uint16_t)depth, mem);
	}

	void lime_bgfx_update_texture_cube(value handle, int layer, int side, int mip, int x, int y, int width, int height, value _mem, int pitch)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(handle);
		const bgfx::Memory *mem = (const bgfx::Memory *)val_data(_mem);
		bgfx::updateTextureCube(*th, (uint16_t)layer, (uint8_t)side, (uint8_t)mip, (uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height, mem, (uint16_t)pitch);
	}

	int lime_bgfx_read_texture(value src, double data)
	{
		return (int)bgfx::read(valToTextureRegion(src), (void *)(uintptr_t)data);
	}

	bool lime_bgfx_is_texture_valid(int depth, bool cubeMap, int numLayers, int format, int flagsHi, int flagsLo)
	{
		return bgfx::isTextureValid((uint16_t)depth, cubeMap, (uint16_t)numLayers, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo));
	}

	value lime_bgfx_calc_texture_size(int width, int height, int depth, bool cubeMap, bool hasMips, int numLayers, int format)
	{
		bgfx::TextureInfo info;

		bgfx::calcTextureSize(info, (uint16_t)width, (uint16_t)height, (uint16_t)depth, cubeMap, hasMips, (uint16_t)numLayers, (bgfx::TextureFormat::Enum)format);

		value obj = alloc_empty_object();

		alloc_field(obj, val_id("format"), alloc_int((int)info.format));
		alloc_field(obj, val_id("storageSize"), alloc_int((int)info.storageSize));
		alloc_field(obj, val_id("width"), alloc_int((int)info.width));
		alloc_field(obj, val_id("height"), alloc_int((int)info.height));
		alloc_field(obj, val_id("depth"), alloc_int((int)info.depth));
		alloc_field(obj, val_id("numLayers"), alloc_int((int)info.numLayers));
		alloc_field(obj, val_id("numMips"), alloc_int((int)info.numMips));
		alloc_field(obj, val_id("bitsPerPixel"), alloc_int((int)info.bitsPerPixel));
		alloc_field(obj, val_id("cubeMap"), alloc_bool(info.cubeMap));

		return obj;
	}

	value lime_bgfx_create_frame_buffer(int width, int height, int format, int flagsHi, int flagsLo)
	{
		return frameBufferHandleToVal(bgfx::createFrameBuffer((uint16_t)width, (uint16_t)height, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo)));
	}

	value lime_bgfx_create_frame_buffer_scaled(int ratio, int format, int flagsHi, int flagsLo)
	{
		return frameBufferHandleToVal(bgfx::createFrameBuffer((bgfx::BackbufferRatio::Enum)ratio, (bgfx::TextureFormat::Enum)format, mergeUInt64(flagsHi, flagsLo)));
	}

	value lime_bgfx_create_frame_buffer_from_textures(value handles, bool destroyTextures)
	{
		int num = val_array_size(handles);

		std::vector<bgfx::TextureHandle> textures(num);

		for (int i = 0; i < num; i++)
		{
			textures[i] = *(bgfx::TextureHandle *)val_data(val_array_i(handles, i));
		}

		bgfx::FrameBufferHandle fbh = bgfx::createFrameBuffer((uint8_t)num, textures.data(), destroyTextures);

		if (destroyTextures && bgfx::isValid(fbh))
		{
			for (int i = 0; i < num; i++)
			{
				((bgfx::TextureHandle *)val_data(val_array_i(handles, i)))->idx = bgfx::kInvalidHandle;
			}
		}

		return frameBufferHandleToVal(fbh);
	}

	value lime_bgfx_create_frame_buffer_from_attachments(value attachments, bool destroyTextures)
	{
		int num = val_array_size(attachments);

		std::vector<bgfx::Attachment> attachmentList(num);

		for (int i = 0; i < num; i++)
		{
			attachmentList[i] = valToAttachment(val_array_i(attachments, i));
		}

		bgfx::FrameBufferHandle fbh = bgfx::createFrameBuffer((uint8_t)num, attachmentList.data(), destroyTextures);

		if (destroyTextures && bgfx::isValid(fbh))
		{
			for (int i = 0; i < num; i++)
			{
				((bgfx::TextureHandle *)val_data(val_field(val_array_i(attachments, i), val_id("handle"))))->idx = bgfx::kInvalidHandle;
			}
		}

		return frameBufferHandleToVal(fbh);
	}

	bool lime_bgfx_is_frame_buffer_valid(value attachments)
	{
		int num = val_array_size(attachments);

		std::vector<bgfx::Attachment> attachmentList(num);

		for (int i = 0; i < num; i++)
		{
			attachmentList[i] = valToAttachment(val_array_i(attachments, i));
		}

		return bgfx::isFrameBufferValid((uint8_t)num, attachmentList.data());
	}

	value lime_bgfx_get_texture(value handle, int attachment)
	{
		bgfx::FrameBufferHandle *fbh = (bgfx::FrameBufferHandle *)val_data(handle);

		return CFFIPointer(new bgfx::TextureHandle(bgfx::getTexture(*fbh, (uint8_t)attachment)), gc_bgfx_val);
	}

	void lime_bgfx_set_view_frame_buffer(int id, value handle)
	{
		bgfx::FrameBufferHandle fbh = BGFX_INVALID_HANDLE;

		if (!val_is_null(handle))
		{
			fbh = *(bgfx::FrameBufferHandle *)val_data(handle);
		}

		bgfx::setViewFrameBuffer((bgfx::ViewId)id, fbh);
	}

	void lime_bgfx_set_texture(int stage, value sampler, value texture, int flags)
	{
		bgfx::UniformHandle *uniform = (bgfx::UniformHandle *)val_data(sampler);
		bgfx::TextureHandle th = BGFX_INVALID_HANDLE;

		if (!val_is_null(texture))
		{
			th = *(bgfx::TextureHandle *)val_data(texture);
		}

		bgfx::setTexture((uint8_t)stage, *uniform, th, (uint32_t)flags);
	}

	void lime_bgfx_set_image(int stage, value texture, int mip, int access, int format)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(texture);
		bgfx::setImage((uint8_t)stage, *th, (uint8_t)mip, (bgfx::Access::Enum)access, format < 0 ? bgfx::TextureFormat::Count : (bgfx::TextureFormat::Enum)format);
	}

	void lime_bgfx_set_stencil(int fstencil, int bstencil)
	{
		bgfx::setStencil((uint32_t)fstencil, (uint32_t)bstencil);
	}

	int lime_bgfx_set_scissor(int x, int y, int width, int height)
	{
		return (int)bgfx::setScissor((uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height);
	}

	void lime_bgfx_set_scissor_cached(int cache)
	{
		bgfx::setScissor((uint16_t)cache);
	}

	void lime_bgfx_set_vertex_count(int numVertices)
	{
		bgfx::setVertexCount((uint32_t)numVertices);
	}

	void lime_bgfx_blit(int id, value dst, value src)
	{
		bgfx::blit((bgfx::ViewId)id, valToTextureRegion(dst), valToTextureRegion(src));
	}

	void lime_bgfx_set_compute_index_buffer(int stage, value handle, int access)
	{
		bgfx::IndexBufferHandle *ibh = (bgfx::IndexBufferHandle *)val_data(handle);
		bgfx::setBuffer((uint8_t)stage, *ibh, (bgfx::Access::Enum)access);
	}

	void lime_bgfx_set_compute_vertex_buffer(int stage, value handle, int access)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::setBuffer((uint8_t)stage, *vbh, (bgfx::Access::Enum)access);
	}

	void lime_bgfx_set_compute_dynamic_index_buffer(int stage, value handle, int access)
	{
		bgfx::DynamicIndexBufferHandle *dibh = (bgfx::DynamicIndexBufferHandle *)val_data(handle);
		bgfx::setBuffer((uint8_t)stage, *dibh, (bgfx::Access::Enum)access);
	}

	void lime_bgfx_set_compute_dynamic_vertex_buffer(int stage, value handle, int access)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		bgfx::setBuffer((uint8_t)stage, *dvbh, (bgfx::Access::Enum)access);
	}

	void lime_bgfx_set_compute_indirect_buffer(int stage, value handle, int access)
	{
		bgfx::IndirectBufferHandle *ixbh = (bgfx::IndirectBufferHandle *)val_data(handle);
		bgfx::setBuffer((uint8_t)stage, *ixbh, (bgfx::Access::Enum)access);
	}

	void lime_bgfx_dispatch(int id, value handle, int numX, int numY, int numZ, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(handle);
		bgfx::dispatch((bgfx::ViewId)id, *program, (uint32_t)numX, (uint32_t)numY, (uint32_t)numZ, (uint8_t)flags);
	}

	void lime_bgfx_dispatch_indirect(int id, value program_handle, value ixbh_handle, int start, int num, int flags)
	{
		bgfx::ProgramHandle *program = (bgfx::ProgramHandle *)val_data(program_handle);
		bgfx::IndirectBufferHandle *ixbh = (bgfx::IndirectBufferHandle *)val_data(ixbh_handle);
		bgfx::dispatch((bgfx::ViewId)id, *program, *ixbh, (uint32_t)start, (uint32_t)num, (uint8_t)flags);
	}

	void lime_bgfx_discard(int flags)
	{
		bgfx::discard((uint8_t)flags);
	}

	value lime_bgfx_alloc_instance_data_buffer(int num, int stride)
	{
		bgfx::InstanceDataBuffer *idb = new bgfx::InstanceDataBuffer();
		bgfx::allocInstanceDataBuffer(idb, (uint32_t)num, (uint16_t)stride);

		return CFFIPointer(idb, gc_bgfx_val);
	}

	int lime_bgfx_get_avail_instance_data_buffer(int num, int stride)
	{
		return (int)bgfx::getAvailInstanceDataBuffer((uint32_t)num, (uint16_t)stride);
	}

	bool lime_bgfx_get_instance_data_buffer_data(value handle, value buffer)
	{
		bgfx::InstanceDataBuffer *idb = (bgfx::InstanceDataBuffer *)val_data(handle);

		if (!idb || !idb->data || idb->size == 0)
		{
			return false;
		}

		ArrayBufferView abv(buffer);

		abv.buffer->Resize(idb->size);

		memcpy(abv.buffer->b, idb->data, idb->size);

		abv.byteLength = (int)idb->size;

		abv.length = (int)idb->size;

		return true;
	}

	void lime_bgfx_set_instance_data_buffer_data(value handle, double data, int size)
	{
		bgfx::InstanceDataBuffer *idb = (bgfx::InstanceDataBuffer *)val_data(handle);

		if (!idb || !idb->data || !data || size <= 0)
		{
			return;
		}

		uint32_t copySize = (uint32_t)size < idb->size ? (uint32_t)size : idb->size;

		memcpy(idb->data, (const void *)(uintptr_t)data, copySize);
	}

	void lime_bgfx_set_instance_data_buffer(value handle, int start, int num)
	{
		bgfx::InstanceDataBuffer *idb = (bgfx::InstanceDataBuffer *)val_data(handle);
		bgfx::setInstanceDataBuffer(idb, (uint32_t)start, (uint32_t)num);
	}

	void lime_bgfx_set_instance_data_from_vertex_buffer(value handle, int startVertex, int num)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::setInstanceDataBuffer(*vbh, (uint32_t)startVertex, (uint32_t)num);
	}

	void lime_bgfx_set_instance_data_from_dynamic_vertex_buffer(value handle, int startVertex, int num)
	{
		bgfx::DynamicVertexBufferHandle *dvbh = (bgfx::DynamicVertexBufferHandle *)val_data(handle);
		bgfx::setInstanceDataBuffer(*dvbh, (uint32_t)startVertex, (uint32_t)num);
	}

	void lime_bgfx_set_instance_count(int numInstances)
	{
		bgfx::setInstanceCount((uint32_t)numInstances);
	}

	void lime_bgfx_reset_view(int id)
	{
		bgfx::resetView((bgfx::ViewId)id);
	}

	void lime_bgfx_set_view_clear_mrt(int id, int flags, double depth, int stencil, int c0, int c1, int c2, int c3, int c4, int c5, int c6, int c7)
	{
		bgfx::setViewClear((bgfx::ViewId)id, (uint16_t)flags, (float)depth, (uint8_t)stencil, (uint8_t)c0, (uint8_t)c1, (uint8_t)c2, (uint8_t)c3, (uint8_t)c4, (uint8_t)c5, (uint8_t)c6, (uint8_t)c7);
	}

	void lime_bgfx_set_view_mode(int id, int mode)
	{
		bgfx::setViewMode((bgfx::ViewId)id, (bgfx::ViewMode::Enum)mode);
	}

	void lime_bgfx_set_view_name(int id, HxString name)
	{
		bgfx::setViewName((bgfx::ViewId)id, hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_view_order(int id, int num, value order)
	{
		if (val_is_null(order))
		{
			bgfx::setViewOrder((bgfx::ViewId)id, (uint16_t)num, NULL);
			return;
		}

		int count = val_array_size(order);

		std::vector<bgfx::ViewId> remap(count);

		for (int i = 0; i < count; i++)
		{
			remap[i] = (bgfx::ViewId)val_int(val_array_i(order, i));
		}

		bgfx::setViewOrder((bgfx::ViewId)id, (uint16_t)(num < 0 ? count : num), remap.data());
	}

	void lime_bgfx_set_view_scissor(int id, int x, int y, int width, int height)
	{
		bgfx::setViewScissor((bgfx::ViewId)id, (uint16_t)x, (uint16_t)y, (uint16_t)width, (uint16_t)height);
	}

	int lime_bgfx_alloc_transform(double data, int dataSize, int num)
	{
		bgfx::Transform transform;

		uint32_t index = bgfx::allocTransform(&transform, (uint16_t)num);

		uint32_t size = (uint32_t)num * 16 * sizeof(float);

		uint32_t copySize = (uint32_t)dataSize < size ? (uint32_t)dataSize : size;

		if (data && dataSize > 0)
		{
			memcpy(transform.data, (const void *)(uintptr_t)data, copySize);
		}

		return (int)index;
	}

	void lime_bgfx_set_transform_cached(int cache, int num)
	{
		bgfx::setTransform((uint32_t)cache, (uint16_t)num);
	}

	void lime_bgfx_set_condition(value handle, bool visible)
	{
		bgfx::OcclusionQueryHandle *oqh = (bgfx::OcclusionQueryHandle *)val_data(handle);

		bgfx::setCondition(*oqh, visible);
	}

	void lime_bgfx_set_marker(HxString name)
	{
		bgfx::setMarker(hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_palette_color(int index, double r, double g, double b, double a)
	{
		bgfx::setPaletteColor((uint8_t)index, (float)r, (float)g, (float)b, (float)a);
	}

	void lime_bgfx_set_palette_color_rgba8(int index, int rgba)
	{
		bgfx::setPaletteColor((uint8_t)index, (uint32_t)rgba);
	}

	void lime_bgfx_set_view_shading_rate(int id, int shadingRate)
	{
		bgfx::setViewShadingRate((bgfx::ViewId)id, (bgfx::ShadingRate::Enum)shadingRate);
	}

	void lime_bgfx_set_shader_name(value handle, HxString name)
	{
		bgfx::ShaderHandle *shader = (bgfx::ShaderHandle *)val_data(handle);
		bgfx::setName(*shader, hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_texture_name(value handle, HxString name)
	{
		bgfx::TextureHandle *th = (bgfx::TextureHandle *)val_data(handle);
		bgfx::setName(*th, hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_frame_buffer_name(value handle, HxString name)
	{
		bgfx::FrameBufferHandle *fbh = (bgfx::FrameBufferHandle *)val_data(handle);
		bgfx::setName(*fbh, hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_index_buffer_name(value handle, HxString name)
	{
		bgfx::IndexBufferHandle *ibh = (bgfx::IndexBufferHandle *)val_data(handle);
		bgfx::setName(*ibh, hxs_utf8(name, nullptr));
	}

	void lime_bgfx_set_vertex_buffer_name(value handle, HxString name)
	{
		bgfx::VertexBufferHandle *vbh = (bgfx::VertexBufferHandle *)val_data(handle);
		bgfx::setName(*vbh, hxs_utf8(name, nullptr));
	}

	int lime_bgfx_get_renderer_type()
	{
		return (int)bgfx::getRendererType();
	}

	value lime_bgfx_get_renderer_name(int type)
	{
		return alloc_string(bgfx::getRendererName((bgfx::RendererType::Enum)type));
	}

	value lime_bgfx_get_supported_renderers()
	{
		bgfx::RendererType::Enum types[bgfx::RendererType::Count];
		uint8_t num = bgfx::getSupportedRenderers(bgfx::RendererType::Count, types);

		value result = alloc_array(num);

		for (int i = 0; i < num; i++)
		{
			val_array_set_i(result, i, alloc_int((int)types[i]));
		}

		return result;
	}

	value lime_bgfx_alloc(int size)
	{
		const bgfx::Memory *mem = bgfx::alloc((uint32_t)size);
		return CFFIPointer(const_cast<bgfx::Memory *>(mem));
	}

	value lime_bgfx_copy(double data, int size)
	{
		const bgfx::Memory *mem = bgfx::copy((const void *)(uintptr_t)data, (uint32_t)size);

		return CFFIPointer(const_cast<bgfx::Memory *>(mem));
	}

	void lime_bgfx_vertex_pack(double input, bool inputNormalized, int attrib, value layout_handle, double data, int index)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(layout_handle);

		bgfx::vertexPack((const float *)(uintptr_t)input, inputNormalized, (bgfx::Attrib::Enum)attrib, *layout, (void *)(uintptr_t)data, (uint32_t)index);
	}

	void lime_bgfx_vertex_unpack(double output, int attrib, value layout_handle, double data, int index)
	{
		bgfx::VertexLayout *layout = (bgfx::VertexLayout *)val_data(layout_handle);

		bgfx::vertexUnpack((float *)(uintptr_t)output, (bgfx::Attrib::Enum)attrib, *layout, (const void *)(uintptr_t)data, (uint32_t)index);
	}

	void lime_bgfx_vertex_convert(value dstLayout_handle, double dstData, value srcLayout_handle, double srcData, int num)
	{
		bgfx::VertexLayout *dstLayout = (bgfx::VertexLayout *)val_data(dstLayout_handle);
		bgfx::VertexLayout *srcLayout = (bgfx::VertexLayout *)val_data(srcLayout_handle);

		bgfx::vertexConvert(*dstLayout, (void *)(uintptr_t)dstData, *srcLayout, (const void *)(uintptr_t)srcData, (uint32_t)num);
	}

	int lime_bgfx_topology_convert(int conversion, double dst, int dstSize, double indices, int numIndices, bool index32)
	{
		void *dstPtr = (void *)(uintptr_t)dst;

		return (int)bgfx::topologyConvert((bgfx::TopologyConvert::Enum)conversion, dstPtr, dstPtr ? (uint32_t)dstSize : 0, (const void *)(uintptr_t)indices, (uint32_t)numIndices, index32);
	}

	void lime_bgfx_topology_sort_tri_list(int sort, double dst, int dstSize, double dir, double pos, double vertices, int stride, double indices, int numIndices, bool index32)
	{
		bgfx::topologySortTriList((bgfx::TopologySort::Enum)sort, (void *)(uintptr_t)dst, (uint32_t)dstSize, (const float *)(uintptr_t)dir, (const float *)(uintptr_t)pos, (const void *)(uintptr_t)vertices, (uint32_t)stride, (const void *)(uintptr_t)indices, (uint32_t)numIndices, index32);
	}


	void lime_bgfx_request_screen_shot(value handle, HxString filePath, value data, value callback)
	{
		bgfx::FrameBufferHandle fbh = BGFX_INVALID_HANDLE;

		if (!val_is_null(handle))
		{
			fbh = *(bgfx::FrameBufferHandle *)val_data(handle);
		}

		const char *path = hxs_utf8(filePath, nullptr);

		if (!val_is_null(data) && !val_is_null(callback))
		{
			s_screenShotRequestsMutex.Lock();
			s_screenShotRequests.push_back({path, new AutoGCRoot(data), new AutoGCRoot(callback)});
			s_screenShotRequestsMutex.Unlock();
		}

		bgfx::requestScreenShot(fbh, path);
	}

	DEFINE_PRIME0(lime_bgfx_render_frame);
	DEFINE_PRIME3v(lime_bgfx_set_debug);
	DEFINE_PRIME5v(lime_bgfx_set_view_clear);
	DEFINE_PRIME4v(lime_bgfx_set_view_clear_depth);
	DEFINE_PRIME5v(lime_bgfx_set_view_rect);
	DEFINE_PRIME4v(lime_bgfx_set_view_rect_ratio);
	DEFINE_PRIME1v(lime_bgfx_touch);
	DEFINE_PRIME1(lime_bgfx_frame);
	DEFINE_PRIME0(lime_bgfx_get_stats);
	DEFINE_PRIME2v(lime_bgfx_dbg_text_clear);
	DEFINE_PRIME4v(lime_bgfx_dbg_text_printf);
	DEFINE_PRIME6v(lime_bgfx_dbg_text_image);
	DEFINE_PRIME0(lime_bgfx_create_vertex_layout);
	DEFINE_PRIME1(lime_bgfx_register_object);
	DEFINE_PRIME2v(lime_bgfx_vertex_layout_begin);
	DEFINE_PRIME6v(lime_bgfx_vertex_layout_add);
	DEFINE_PRIME2(lime_bgfx_vertex_layout_decode);
	DEFINE_PRIME2(lime_bgfx_vertex_layout_has);
	DEFINE_PRIME2v(lime_bgfx_vertex_layout_skip);
	DEFINE_PRIME2(lime_bgfx_vertex_layout_get_offset);
	DEFINE_PRIME1(lime_bgfx_vertex_layout_get_stride);
	DEFINE_PRIME2(lime_bgfx_vertex_layout_get_size);
	DEFINE_PRIME1v(lime_bgfx_vertex_layout_end);
	DEFINE_PRIME2(lime_bgfx_make_ref);
	DEFINE_PRIME3(lime_bgfx_create_vertex_buffer);
	DEFINE_PRIME2(lime_bgfx_create_index_buffer);
	DEFINE_PRIME1(lime_bgfx_create_shader);
	DEFINE_PRIME3(lime_bgfx_create_program);
	DEFINE_PRIME2(lime_bgfx_create_compute_program);
	DEFINE_PRIME2v(lime_bgfx_set_vertex_buffer);
	DEFINE_PRIME4v(lime_bgfx_set_vertex_buffer_vertices);
	DEFINE_PRIME5v(lime_bgfx_set_vertex_buffer_layout);
	DEFINE_PRIME2v(lime_bgfx_set_dynamic_vertex_buffer);
	DEFINE_PRIME4v(lime_bgfx_set_dynamic_vertex_buffer_vertices);
	DEFINE_PRIME5v(lime_bgfx_set_dynamic_vertex_buffer_layout);
	DEFINE_PRIME2v(lime_bgfx_set_transient_vertex_buffer);
	DEFINE_PRIME4v(lime_bgfx_set_transient_vertex_buffer_vertices);
	DEFINE_PRIME5v(lime_bgfx_set_transient_vertex_buffer_layout);
	DEFINE_PRIME1v(lime_bgfx_set_index_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_index_buffer_indices);
	DEFINE_PRIME1v(lime_bgfx_set_dynamic_index_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_dynamic_index_buffer_indices);
	DEFINE_PRIME1v(lime_bgfx_set_transient_index_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_transient_index_buffer_indices);
	DEFINE_PRIME3v(lime_bgfx_set_state);
	DEFINE_PRIME3v(lime_bgfx_set_view_transform);
	DEFINE_PRIME2(lime_bgfx_set_transform);
	DEFINE_PRIME4v(lime_bgfx_submit);
	DEFINE_PRIME5v(lime_bgfx_submit_occlusion_query);
	DEFINE_PRIME7v(lime_bgfx_submit_indirect_buffer);
	DEFINE_PRIME8v(lime_bgfx_submit_indirect_index_buffer);
	DEFINE_PRIME0(lime_bgfx_get_caps);
	DEFINE_PRIME0(lime_bgfx_create_occlusion_query);
	DEFINE_PRIME1(lime_bgfx_get_occlusion_query_result);
	DEFINE_PRIME1(lime_bgfx_create_indirect_buffer);
	DEFINE_PRIME3(lime_bgfx_create_dynamic_vertex_buffer);
	DEFINE_PRIME3(lime_bgfx_create_dynamic_vertex_buffer_mem);
	DEFINE_PRIME3v(lime_bgfx_update_dynamic_vertex_buffer);
	DEFINE_PRIME2(lime_bgfx_create_dynamic_index_buffer);
	DEFINE_PRIME2(lime_bgfx_create_dynamic_index_buffer_mem);
	DEFINE_PRIME3v(lime_bgfx_update_dynamic_index_buffer);
	DEFINE_PRIME2(lime_bgfx_alloc_transient_vertex_buffer);
	DEFINE_PRIME2(lime_bgfx_alloc_transient_index_buffer);
	DEFINE_PRIME2(lime_bgfx_get_transient_vertex_buffer_data);
	DEFINE_PRIME3v(lime_bgfx_set_transient_vertex_buffer_data);
	DEFINE_PRIME2(lime_bgfx_get_transient_index_buffer_data);
	DEFINE_PRIME3v(lime_bgfx_set_transient_index_buffer_data);
	DEFINE_PRIME2(lime_bgfx_get_avail_transient_vertex_buffer);
	DEFINE_PRIME2(lime_bgfx_get_avail_transient_index_buffer);
	DEFINE_PRIME1(lime_bgfx_register_vertex_layout);
	DEFINE_PRIME6(lime_bgfx_compile_shader_string);
	DEFINE_PRIME6(lime_bgfx_compile_shader_file);
	DEFINE_PRIME0(lime_bgfx_get_last_shader_message);
	DEFINE_PRIME3v(lime_bgfx_reset);
	DEFINE_PRIME3(lime_bgfx_create_uniform);
	DEFINE_PRIME4(lime_bgfx_create_uniform_freq);
	DEFINE_PRIME3v(lime_bgfx_set_uniform);
	DEFINE_PRIME4v(lime_bgfx_set_view_uniform);
	DEFINE_PRIME3v(lime_bgfx_set_frame_uniform);
	DEFINE_PRIME1(lime_bgfx_get_uniform_info);
	DEFINE_PRIME1(lime_bgfx_get_shader_uniforms);
	DEFINE_PRIME4(lime_bgfx_create_texture);
	DEFINE_PRIME8(lime_bgfx_create_texture_2d);
	DEFINE_PRIME6(lime_bgfx_create_texture_2d_scaled);
	DEFINE_PRIME8(lime_bgfx_create_texture_3d);
	DEFINE_PRIME7(lime_bgfx_create_texture_cube);
	DEFINE_PRIME9v(lime_bgfx_update_texture_2d);
	DEFINE_PRIME9v(lime_bgfx_update_texture_3d);
	DEFINE_PRIME10v(lime_bgfx_update_texture_cube);
	DEFINE_PRIME2(lime_bgfx_read_texture);
	DEFINE_PRIME6(lime_bgfx_is_texture_valid);
	DEFINE_PRIME7(lime_bgfx_calc_texture_size);
	DEFINE_PRIME5(lime_bgfx_create_frame_buffer);
	DEFINE_PRIME4(lime_bgfx_create_frame_buffer_scaled);
	DEFINE_PRIME2(lime_bgfx_create_frame_buffer_from_textures);
	DEFINE_PRIME2(lime_bgfx_create_frame_buffer_from_attachments);
	DEFINE_PRIME1(lime_bgfx_is_frame_buffer_valid);
	DEFINE_PRIME2(lime_bgfx_get_texture);
	DEFINE_PRIME2v(lime_bgfx_set_view_frame_buffer);
	DEFINE_PRIME4v(lime_bgfx_set_texture);
	DEFINE_PRIME5v(lime_bgfx_set_image);
	DEFINE_PRIME2v(lime_bgfx_set_stencil);
	DEFINE_PRIME4(lime_bgfx_set_scissor);
	DEFINE_PRIME1v(lime_bgfx_set_scissor_cached);
	DEFINE_PRIME1v(lime_bgfx_set_vertex_count);
	DEFINE_PRIME3v(lime_bgfx_blit);
	DEFINE_PRIME3v(lime_bgfx_set_compute_index_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_compute_vertex_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_compute_dynamic_index_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_compute_dynamic_vertex_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_compute_indirect_buffer);
	DEFINE_PRIME6v(lime_bgfx_dispatch);
	DEFINE_PRIME6v(lime_bgfx_dispatch_indirect);
	DEFINE_PRIME1v(lime_bgfx_discard);
	DEFINE_PRIME2(lime_bgfx_alloc_instance_data_buffer);
	DEFINE_PRIME2(lime_bgfx_get_avail_instance_data_buffer);
	DEFINE_PRIME2(lime_bgfx_get_instance_data_buffer_data);
	DEFINE_PRIME3v(lime_bgfx_set_instance_data_buffer_data);
	DEFINE_PRIME3v(lime_bgfx_set_instance_data_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_instance_data_from_vertex_buffer);
	DEFINE_PRIME3v(lime_bgfx_set_instance_data_from_dynamic_vertex_buffer);
	DEFINE_PRIME1v(lime_bgfx_set_instance_count);
	DEFINE_PRIME1v(lime_bgfx_reset_view);
	DEFINE_PRIME12v(lime_bgfx_set_view_clear_mrt);
	DEFINE_PRIME2v(lime_bgfx_set_view_mode);
	DEFINE_PRIME2v(lime_bgfx_set_view_name);
	DEFINE_PRIME3v(lime_bgfx_set_view_order);
	DEFINE_PRIME5v(lime_bgfx_set_view_scissor);
	DEFINE_PRIME3(lime_bgfx_alloc_transform);
	DEFINE_PRIME2v(lime_bgfx_set_transform_cached);
	DEFINE_PRIME2v(lime_bgfx_set_condition);
	DEFINE_PRIME1v(lime_bgfx_set_marker);
	DEFINE_PRIME5v(lime_bgfx_set_palette_color);
	DEFINE_PRIME2v(lime_bgfx_set_palette_color_rgba8);
	DEFINE_PRIME2v(lime_bgfx_set_view_shading_rate);
	DEFINE_PRIME2v(lime_bgfx_set_shader_name);
	DEFINE_PRIME2v(lime_bgfx_set_texture_name);
	DEFINE_PRIME2v(lime_bgfx_set_frame_buffer_name);
	DEFINE_PRIME2v(lime_bgfx_set_index_buffer_name);
	DEFINE_PRIME2v(lime_bgfx_set_vertex_buffer_name);
	DEFINE_PRIME0(lime_bgfx_get_renderer_type);
	DEFINE_PRIME1(lime_bgfx_get_renderer_name);
	DEFINE_PRIME0(lime_bgfx_get_supported_renderers);
	DEFINE_PRIME1(lime_bgfx_alloc);
	DEFINE_PRIME2(lime_bgfx_copy);
	DEFINE_PRIME6v(lime_bgfx_vertex_pack);
	DEFINE_PRIME5v(lime_bgfx_vertex_unpack);
	DEFINE_PRIME5v(lime_bgfx_vertex_convert);
	DEFINE_PRIME6(lime_bgfx_topology_convert);
	DEFINE_PRIME10v(lime_bgfx_topology_sort_tri_list);
	DEFINE_PRIME4v(lime_bgfx_request_screen_shot);

#define DEFINE_BGFX_DESTROY(name, HandleType)                                                                                                                                                                                                                                                                                                                                                                                                                                                                      \
	void lime_bgfx_destroy_##name(value handle)                                                                                                                                                                                                                                                                                                                                                                                                                                                                    \
	{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              \
		bgfx::HandleType *val = (bgfx::HandleType *)val_data(handle);                                                                                                                                                                                                                                                                                                                                                                                                                                              \
		if (bgfx::isValid(*val))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   \
		{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          \
			bgfx::destroy(*val);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   \
			val->idx = bgfx::kInvalidHandle;                                                                                                                                                                                                                                                                                                                                                                                                                                                                       \
		}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          \
	}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              \
	DEFINE_PRIME1v(lime_bgfx_destroy_##name);

	DEFINE_BGFX_DESTROY(vertex_buffer, VertexBufferHandle)
	DEFINE_BGFX_DESTROY(index_buffer, IndexBufferHandle)
	DEFINE_BGFX_DESTROY(dynamic_vertex_buffer, DynamicVertexBufferHandle)
	DEFINE_BGFX_DESTROY(dynamic_index_buffer, DynamicIndexBufferHandle)
	DEFINE_BGFX_DESTROY(shader, ShaderHandle)
	DEFINE_BGFX_DESTROY(program, ProgramHandle)
	DEFINE_BGFX_DESTROY(texture, TextureHandle)
	DEFINE_BGFX_DESTROY(frame_buffer, FrameBufferHandle)
	DEFINE_BGFX_DESTROY(uniform, UniformHandle)
	DEFINE_BGFX_DESTROY(vertex_layout, VertexLayoutHandle)
	DEFINE_BGFX_DESTROY(occlusion_query, OcclusionQueryHandle)
	DEFINE_BGFX_DESTROY(indirect_buffer, IndirectBufferHandle)

#undef DEFINE_BGFX_DESTROY

	static bgfx::RendererType::Enum getRequestedRendererType()
	{
		bgfx::RendererType::Enum selectedRenderer = bgfx::RendererType::Count;
		const char* rendererName = SDL_GetHint("SDL_LIME_BGFX_RENDERER");

		if (rendererName == NULL) return selectedRenderer;

		if (SDL_strcmp(rendererName, "d3d12") == 0) selectedRenderer = bgfx::RendererType::Direct3D12;
		else if (SDL_strcmp(rendererName, "d3d11") == 0) selectedRenderer = bgfx::RendererType::Direct3D11;
		else if (SDL_strcmp(rendererName, "vulkan") == 0) selectedRenderer = bgfx::RendererType::Vulkan;
		else if (SDL_strcmp(rendererName, "metal") == 0) selectedRenderer = bgfx::RendererType::Metal;
		else if (SDL_strcmp(rendererName, "opengl") == 0) selectedRenderer = bgfx::RendererType::OpenGL;
		else if (SDL_strcmp(rendererName, "opengles") == 0) selectedRenderer = bgfx::RendererType::OpenGLES;
		else if (SDL_strcmp(rendererName, "noop") == 0) selectedRenderer = bgfx::RendererType::Noop;
		else return selectedRenderer;

		bgfx::RendererType::Enum supportedRenderers[bgfx::RendererType::Count];
		uint8_t len = bgfx::getSupportedRenderers(bgfx::RendererType::Count, supportedRenderers);

		for (uint8_t i = 0; i < len; i++)
		{
			if (supportedRenderers[i] == selectedRenderer) return selectedRenderer;
		}

		return bgfx::RendererType::Count;
	}

	static bgfx::RendererType::Enum getRendererType()
	{
		bgfx::RendererType::Enum requested = getRequestedRendererType();

		if (requested != bgfx::RendererType::Count) return requested;

#if defined(ANDROID)
		return bgfx::RendererType::Vulkan;
#elif defined(HX_LINUX)
		return bgfx::RendererType::Vulkan;
#elif defined(IPHONE) || defined(HX_MACOS)
		return bgfx::RendererType::Metal;
#elif defined(HX_WINDOWS)
		return bgfx::RendererType::Direct3D11;
#else
		return bgfx::RendererType::Noop;
#endif
	}

	static void *getNativeWindowHandle(SDL_Window *sdlWindow)
	{
		if (!sdlWindow)
		{
			return NULL;
		}

		SDL_PropertiesID props = SDL_GetWindowProperties(sdlWindow);

#if defined(ANDROID)

		return SDL_GetPointerProperty(props, SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER, NULL);

#elif defined(IPHONE) || defined(HX_MACOS)

		if (!mtlView)
		{
			mtlView = SDL_Metal_CreateView(sdlWindow);
		}

		return SDL_Metal_GetLayer(mtlView);

#elif defined(HX_LINUX)

		const char *driver = SDL_GetCurrentVideoDriver();

		if (SDL_strcmp(driver, "wayland") == 0)
		{
			return SDL_GetPointerProperty(props, SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER, NULL);
		}
		else if (SDL_strcmp(driver, "x11") == 0)
		{
			return (void *)(uintptr_t)SDL_GetNumberProperty(props, SDL_PROP_WINDOW_X11_WINDOW_NUMBER, 0);
		}

#elif defined(HX_WINDOWS)

		return SDL_GetPointerProperty(props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, NULL);

#endif

		return NULL;
	}

	static void *getNativeDisplayHandle(SDL_Window *sdlWindow)
	{
		if (!sdlWindow)
		{
			return NULL;
		}

		SDL_PropertiesID props = SDL_GetWindowProperties(sdlWindow);

#if defined(HX_LINUX)
		const char *driver = SDL_GetCurrentVideoDriver();

		if (SDL_strcmp(driver, "wayland") == 0)
		{
			return SDL_GetPointerProperty(props, SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, NULL);
		}
		else if (SDL_strcmp(driver, "x11") == 0)
		{
			return SDL_GetPointerProperty(props, SDL_PROP_WINDOW_X11_DISPLAY_POINTER, NULL);
		}
#endif

		return NULL;
	}

	static bgfx::NativeWindowHandleType::Enum getNativeWindowHandleType(SDL_Window *sdlWindow)
	{
#if defined(HX_LINUX)
		const char *driver = SDL_GetCurrentVideoDriver();

		if (SDL_strcmp(driver, "wayland") == 0)
		{
			return bgfx::NativeWindowHandleType::Wayland;
		}
#endif

		return bgfx::NativeWindowHandleType::Default;
	}


	static bgfx::TextureFormat::Enum defaultBackbufferFormat = bgfx::TextureFormat::BGRA8;

	bool BGFXBindings::Init(SDL_Window *sdlWindow)
	{
		// Sets the renderer to run on the main thread
		if (SDL_GetHintBoolean("SDL_LIME_BGFX_NO_RENDER_THREAD", false))
			bgfx::renderFrame();

		// Setup bgfx init struct
		bgfx::Init init;

		// Set renderer type based on platform
		init.type = getRendererType();

		// Get native window/display handles from SDL
		init.swapChain.nwh = getNativeWindowHandle(sdlWindow);
		init.swapChain.ndt = getNativeDisplayHandle(sdlWindow);
		init.platformData.type = getNativeWindowHandleType(sdlWindow);

		init.callback = &s_bgfxCallback;

		// Set resolution
		SDL_GetWindowSizeInPixels(sdlWindow, (int *)&init.swapChain.width, (int *)&init.swapChain.height);

		init.swapChain.formatColor = defaultBackbufferFormat;
		// init.swapChain.maxFrameLatency = 3;

#if defined(IPHONE) || defined(HX_MACOS)
		configureMetalLayer(false);
		SetMetalLayerComposited(true);
#endif

		__swapChain = init.swapChain;

		// Init bgfx with the config
		__initialized = bgfx::init(init);
		return __initialized;
	}

	SDL_Window *BGFXBindings::defaultWindow = nullptr;

	void BGFXBindings::ResetWindow(int width, int height)
	{
		if (!__initialized)
			return;

		int w = width;
		int h = height;
		if (w == 0 || h == 0)
		{
			SDL_GetWindowSizeInPixels(defaultWindow, &w, &h);
		}

		__swapChain.width = (uint32_t)w;
		__swapChain.height = (uint32_t)h;

// Update the VK surface
#if defined(ANDROID)
		__swapChain.nwh = getNativeWindowHandle(defaultWindow);
#endif

		bgfx::reset(__resetFlags, &__swapChain);
	}

	// Clean up any required resources
	void BGFXBindings::Shutdown()
	{
		bgfx::shutdown();
		__initialized = false;

// Destroy the metal view
#if defined(IPHONE) || defined(HX_MACOS)
		if (mtlView)
		{
			SDL_Metal_DestroyView(mtlView);
			mtlView = NULL;
		}
#endif
	}

} // namespace lime

extern "C" int lime_bgfx_register_prims()
{
	return 0;
}
