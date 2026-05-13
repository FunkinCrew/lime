package lime._internal.backend.native;

import haxe.ds.Map;
import haxe.io.Bytes;
import haxe.Int64;
import lime.system.CFFI;
import lime.graphics.ImageBuffer;
import lime.graphics.RenderContextType;
import lime.graphics.bgfx.*;
import lime.math.Matrix4;
import lime.utils.ArrayBufferView;
import lime.utils.DataPointer;
import lime.utils.Float32Array;
import lime.utils.Int32Array;
import lime.utils.UInt32Array;

using StringTools;

@:dox(hide)
@:allow(lime.ui.Window)
@:access(lime._internal.backend.native.NativeCFFI)
class NativeBGFXRenderContext
{
	public var CLEAR_NONE = 0x0000;
	public var CLEAR_COLOR = 0x0001;
	public var CLEAR_DEPTH = 0x0002;
	public var CLEAR_STENCIL = 0x0004;

	public var BGFX_DEBUG_IFH = 0x00000002;
	public var BGFX_DEBUG_STATS = 0x00000004;
	public var BGFX_DEBUG_TEXT = 0x00000008;
	public var BGFX_DEBUG_PROFILER = 0x00000010;

	public var type(default, null):RenderContextType;
	public var version:Float = 1;

	public function new()
	{
		type = BGFX;
	}

	public function renderFrame():BGFXRenderFrame
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_render_frame();
		#end

		return 0;
	}

	public function setDebug(flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_debug(flags);
		#end
	}

	public function setViewClear(id:Int, flags:Int, rgba:Int, depth:Float, stencil:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_clear(id, flags, rgba, depth, stencil);
		#end
	}

	public function setViewClearDepth(id:Int, flags:Int, depth:Float, stencil:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_clear_depth(id, flags, depth, stencil);
		#end
	}

	public function setViewRect(id:Int, x:Int, y:Int, width:Int, height:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_rect(id, x, y, width, height);
		#end
	}

	public function setViewRectRatio(id:Int, x:Int, y:Int, ratio:BGFXBackbufferRatio):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_rect_ratio(id, x, y, ratio);
		#end
	}

	public function touch(id:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_touch(id);
		#end
	}

	public function frame(flags:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_frame(flags);
		#end

		return -1;
	}

	public function getStats():BGFXStats
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_stats();
		#end

		return null;
	}

	public function dbgTextClear(attr:Int, small:Bool):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_dbg_text_clear(attr, small);
		#end
	}

	public function dbgTextPrintf(x:Int, y:Int, attr:Int, text:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_dbg_text_printf(x, y, attr, text);
		#end
	}

	public function dbgTextImage(x:Int, y:Int, width:Int, height:Int, data:ArrayBufferView, pitch:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_dbg_text_image(x, y, width, height, data, pitch);
		#end
	}

	public function createVertexLayout():BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_vertex_layout();
		#end

		return null;
	}

	public function registerVertexLayout(layout:BGFXVertexLayout):BGFXVertexLayoutHandle
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_register_vertex_layout(layout);
		#end

		return null;
	}

	public function makeRef(data:ArrayBufferView, ?size:Int):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_make_ref(data, size ?? data.byteLength);
		#end

		return null;
	}

	public function createVertexBuffer(mem:BGFXMemoryRef, layout:BGFXVertexLayout, flags:Int = 0):BGFXVertexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_vertex_buffer(mem, layout, flags);
		#end

		return null;
	}

	public function createIndexBuffer(mem:BGFXMemoryRef, flags:Int = 0):BGFXIndexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_index_buffer(mem, flags);
		#end

		return null;
	}

	public function createShader(mem:BGFXMemoryRef):BGFXShader
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_shader(mem);
		#end

		return null;
	}

	public function createProgram(vertex:BGFXShader, fragment:BGFXShader, destroyShaders:Bool = true):BGFXProgram
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_program(vertex, fragment, destroyShaders);
		#end

		return null;
	}

	public function createComputeProgram(compute:BGFXShader, destroyShaders:Bool = true):BGFXProgram
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_compute_program(compute, destroyShaders);
		#end

		return null;
	}

	public function createDynamicVertexBuffer(num:Int, layout:BGFXVertexLayout, flags:Int = 0):BGFXDynamicVertexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_dynamic_vertex_buffer(num, layout, flags);
		#end

		return null;
	}

	public function createDynamicVertexBufferMem(mem:BGFXMemoryRef, layout:BGFXVertexLayout, flags:Int = 0):BGFXDynamicVertexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_dynamic_vertex_buffer_mem(mem, layout, flags);
		#end

		return null;
	}

	public function updateDynamicVertexBuffer(handle:BGFXDynamicVertexBuffer, startVertex:Int, mem:BGFXMemoryRef):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_update_dynamic_vertex_buffer(handle, startVertex, mem);
		#end
	}

	public function createDynamicIndexBuffer(num:Int, flags:Int = 0):BGFXDynamicIndexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_dynamic_index_buffer(num, flags);
		#end

		return null;
	}

	public function createDynamicIndexBufferMem(mem:BGFXMemoryRef, flags:Int = 0):BGFXDynamicIndexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_dynamic_index_buffer_mem(mem, flags);
		#end

		return null;
	}

	public function updateDynamicIndexBuffer(handle:BGFXDynamicIndexBuffer, firstIndex:Int, mem:BGFXMemoryRef):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_update_dynamic_index_buffer(handle, firstIndex, mem);
		#end
	}

	public function allocTransientVertexBuffer(num:Int, layout:BGFXVertexLayout):BGFXTransientVertexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_alloc_transient_vertex_buffer(num, layout);
		#end

		return null;
	}

	public function allocTransientIndexBuffer(num:Int, index32:Bool):BGFXTransientIndexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_alloc_transient_index_buffer(num, index32);
		#end

		return null;
	}

	public function getAvailTransientVertexBuffer(num:Int, layout:BGFXVertexLayout):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_avail_transient_vertex_buffer(num, layout);
		#end

		return 0;
	}

	public function getAvailTransientIndexBuffer(num:Int, index32:Bool):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_avail_transient_index_buffer(num, index32);
		#end

		return 0;
	}

	public function createOcclusionQuery():BGFXOcclusionQuery
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_occlusion_query();
		#end

		return null;
	}

	public function getOcclusionQueryResult(handle:BGFXOcclusionQuery):BGFXOcclusionQueryInfo
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_occlusion_query_result(handle);
		#end

		return null;
	}

	public function createIndirectBuffer(num:Int):BGFXIndirectBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_indirect_buffer(num);
		#end

		return null;
	}

	public function setVertexBuffer(stream:Int, vertex:BGFXVertexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_buffer(stream, vertex);
		#end
	}

	public function setVertexBufferVertices(stream:Int, vertex:BGFXVertexBuffer, startVertex:Int, numVertices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_buffer_vertices(stream, vertex, startVertex, numVertices);
		#end
	}

	public function setVertexBufferLayout(stream:Int, vertex:BGFXVertexBuffer, startVertex:Int, numVertices:Int, layout:BGFXVertexLayoutHandle):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_buffer_layout(stream, vertex, startVertex, numVertices, layout);
		#end
	}

	public function setDynamicVertexBuffer(stream:Int, handle:BGFXDynamicVertexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_dynamic_vertex_buffer(stream, handle);
		#end
	}

	public function setDynamicVertexBufferVertices(stream:Int, handle:BGFXDynamicVertexBuffer, startVertex:Int, numVertices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_dynamic_vertex_buffer_vertices(stream, handle, startVertex, numVertices);
		#end
	}

	public function setDynamicVertexBufferLayout(stream:Int, handle:BGFXDynamicVertexBuffer, startVertex:Int, numVertices:Int, layout:BGFXVertexLayoutHandle):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_dynamic_vertex_buffer_layout(stream, handle, startVertex, numVertices, layout);
		#end
	}

	public function setTransientVertexBuffer(stream:Int, tvb:BGFXTransientVertexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_vertex_buffer(stream, tvb);
		#end
	}

	public function setTransientVertexBufferVertices(stream:Int, tvb:BGFXTransientVertexBuffer, startVertex:Int, numVertices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_vertex_buffer_vertices(stream, tvb, startVertex, numVertices);
		#end
	}

	public function setTransientVertexBufferLayout(stream:Int, tvb:BGFXTransientVertexBuffer, startVertex:Int, numVertices:Int, layout:BGFXVertexLayoutHandle):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_vertex_buffer_layout(stream, tvb, startVertex, numVertices, layout);
		#end
	}

	public function setIndexBuffer(index:BGFXIndexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_index_buffer(index);
		#end
	}

	public function setIndexBufferIndices(index:BGFXIndexBuffer, firstIndex:Int, numIndices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_index_buffer_indices(index, firstIndex, numIndices);
		#end
	}

	public function setDynamicIndexBuffer(handle:BGFXDynamicIndexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_dynamic_index_buffer(handle);
		#end
	}

	public function setDynamicIndexBufferIndices(handle:BGFXDynamicIndexBuffer, firstIndex:Int, numIndices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_dynamic_index_buffer_indices(handle, firstIndex, numIndices);
		#end
	}

	public function setTransientIndexBuffer(tib:BGFXTransientIndexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_index_buffer(tib);
		#end
	}

	public function setTransientIndexBufferIndices(tib:BGFXTransientIndexBuffer, firstIndex:Int, numIndices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_index_buffer_indices(tib, firstIndex, numIndices);
		#end
	}

	public function setState(state:Int64, rgba:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_state(state.high, state.low, rgba);
		#end
	}

	public function setViewTransform(id:Int, view:Matrix4, proj:Matrix4):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_transform(id, view, proj);
		#end
	}

	public function setTransform(mtx:Matrix4, num:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_set_transform(mtx, num);
		#end

		return 0;
	}

	public function submit(id:Int, program:BGFXProgram, depth:Int, flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_submit(id, program, depth, flags);
		#end
	}

	public function submitOcclusionQuery(id:Int, program:BGFXProgram, oqh:BGFXOcclusionQuery, depth:Int, flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_submit_occlusion_query(id, program, oqh, depth, flags);
		#end
	}

	public function submitIndirectBuffer(id:Int, program:BGFXProgram, ixbh:BGFXIndirectBuffer, start:Int, num:Int, depth:Int, flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_submit_indirect_buffer(id, program, ixbh, start, num, depth, flags);
		#end
	}

	public function submitIndirectIndexBuffer(id:Int, program:BGFXProgram, ixbh:BGFXIndirectBuffer, start:Int, ibh:BGFXIndexBuffer, numMax:Int, depth:Int, flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_submit_indirect_index_buffer(id, program, ixbh, start, ibh, numMax, depth, flags);
		#end
	}

	public function getCaps():BGFXCaps
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_caps();
		#end

		return null;
	}

	public function destroyVertexBuffer(handle:BGFXVertexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_vertex_buffer(handle);
		#end
	}

	public function destroyIndexBuffer(handle:BGFXIndexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_index_buffer(handle);
		#end
	}

	public function destroyDynamicVertexBuffer(handle:BGFXDynamicVertexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_dynamic_vertex_buffer(handle);
		#end
	}

	public function destroyDynamicIndexBuffer(handle:BGFXDynamicIndexBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_dynamic_index_buffer(handle);
		#end
	}

	public function destroyShader(handle:BGFXShader):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_shader(handle);
		#end
	}

	public function destroyProgram(handle:BGFXProgram):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_program(handle);
		#end
	}

	public function destroyTexture(handle:BGFXTexture):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_texture(handle);
		#end
	}

	public function destroyFrameBuffer(handle:BGFXFrameBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_frame_buffer(handle);
		#end
	}

	public function destroyUniform(handle:BGFXUniform):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_uniform(handle);
		#end
	}

	public function destroyVertexLayout(handle:BGFXVertexLayoutHandle):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_vertex_layout(handle);
		#end
	}

	public function destroyOcclusionQuery(handle:BGFXOcclusionQuery):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_occlusion_query(handle);
		#end
	}

	public function destroyIndirectBuffer(handle:BGFXIndirectBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_destroy_indirect_buffer(handle);
		#end
	}

	public function compileShader(type:Int, shaderSource:String, varyingDef:String, ?includes:Map<String, String>, ?defines:String = '', ?profile:String = ''):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		var sc:Array<String> = shaderSource.split('\n');
		if (includes != null)
		{
			for (i => line in sc.copy())
			{
				if (!line.startsWith('#include')) continue;

				for (key in includes.keys())
				{
					if (line.contains(key))
					{
						sc[i] = includes.get(key);
					}
				}
			}
		}

		return NativeCFFI.lime_bgfx_compile_shader_string(type, sc.join('\n'), varyingDef, defines, profile);
		#end

		return null;
	}
}
