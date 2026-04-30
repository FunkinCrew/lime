package lime._internal.backend.native;

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

	public function renderFrame():Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_render_frame();
		#else
		return 0;
		#end
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

	public function setViewRect(id:Int, x:Int, y:Int, width:Int, height:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_rect(id, x, y, width, height);
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

	public function getStats():Dynamic
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_stats();
		#else
		return null;
		#end
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
	}

	public function makeRef(data:ArrayBufferView, ?size:Int):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_make_ref(data, size ?? data.byteLength);
		#end
	}

	public function createVertexBuffer(mem:BGFXMemoryRef, layout:BGFXVertexLayout, flags:Int = 0):BGFXVertexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_vertex_buffer(mem, layout, flags);
		#end
	}

	public function createIndexBuffer(mem:BGFXMemoryRef, flags:Int = 0):BGFXIndexBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_index_buffer(mem, flags);
		#end
	}

	public function createShader(mem:BGFXMemoryRef):BGFXShader
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_shader(mem);
		#end
	}

	public function createProgram(vertex:BGFXShader, fragment:BGFXShader, destroyShaders:Bool = true):BGFXProgram
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_program(vertex, fragment, destroyShaders);
		#end
	}

	public function setVertexBuffer(stream:Int, vertex:BGFXVertexBuffer, startVertex:Int, numVertices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_buffer(stream, vertex, startVertex, numVertices);
		#end
	}

	public function setIndexBuffer(index:BGFXIndexBuffer,  firstIndex:Int, numIndices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_index_buffer(index, firstIndex, numIndices);
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
	}

	public function submit(id:Int, program:BGFXProgram, depth:Int, flags:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_submit(id, program, depth, flags);
		#end
	}

	public function getCaps():Dynamic
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_caps();
		#else
		return null;
		#end
	}
}
