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
@:access(lime.graphics.bgfx)
class NativeBGFXRenderContext
{
	public var CLEAR_NONE = 0x0000;
	public var CLEAR_COLOR = 0x0001;
	public var CLEAR_DEPTH = 0x0002;
	public var CLEAR_STENCIL = 0x0004;
	public var CLEAR_DISCARD_COLOR_0 = 0x0008;
	public var CLEAR_DISCARD_COLOR_1 = 0x0010;
	public var CLEAR_DISCARD_COLOR_2 = 0x0020;
	public var CLEAR_DISCARD_COLOR_3 = 0x0040;
	public var CLEAR_DISCARD_COLOR_4 = 0x0080;
	public var CLEAR_DISCARD_COLOR_5 = 0x0100;
	public var CLEAR_DISCARD_COLOR_6 = 0x0200;
	public var CLEAR_DISCARD_COLOR_7 = 0x0400;
	public var CLEAR_DISCARD_DEPTH = 0x0800;
	public var CLEAR_DISCARD_STENCIL = 0x1000;

	public var DEBUG_NONE = 0x00000000;
	public var DEBUG_WIREFRAME = 0x00000001;
	public var DEBUG_IFH = 0x00000002;
	public var DEBUG_STATS = 0x00000004;
	public var DEBUG_TEXT = 0x00000008;
	public var DEBUG_PROFILER = 0x00000010;

	public var STATE_NONE:Int64 = Int64.make(0x00000000, 0x00000000);
	public var STATE_WRITE_R:Int64 = Int64.make(0x00000000, 0x00000001);
	public var STATE_WRITE_G:Int64 = Int64.make(0x00000000, 0x00000002);
	public var STATE_WRITE_B:Int64 = Int64.make(0x00000000, 0x00000004);
	public var STATE_WRITE_A:Int64 = Int64.make(0x00000000, 0x00000008);
	public var STATE_WRITE_Z:Int64 = Int64.make(0x00000040, 0x00000000);
	public var STATE_WRITE_RGB:Int64 = Int64.make(0x00000000, 0x00000007);
	public var STATE_WRITE_MASK:Int64 = Int64.make(0x00000040, 0x0000000F);
	public var STATE_DEPTH_TEST_LESS:Int64 = Int64.make(0x00000000, 0x00000010);
	public var STATE_DEPTH_TEST_LEQUAL:Int64 = Int64.make(0x00000000, 0x00000020);
	public var STATE_DEPTH_TEST_EQUAL:Int64 = Int64.make(0x00000000, 0x00000030);
	public var STATE_DEPTH_TEST_GEQUAL:Int64 = Int64.make(0x00000000, 0x00000040);
	public var STATE_DEPTH_TEST_GREATER:Int64 = Int64.make(0x00000000, 0x00000050);
	public var STATE_DEPTH_TEST_NOTEQUAL:Int64 = Int64.make(0x00000000, 0x00000060);
	public var STATE_DEPTH_TEST_NEVER:Int64 = Int64.make(0x00000000, 0x00000070);
	public var STATE_DEPTH_TEST_ALWAYS:Int64 = Int64.make(0x00000000, 0x00000080);
	public var STATE_BLEND_ZERO:Int64 = Int64.make(0x00000000, 0x00001000);
	public var STATE_BLEND_ONE:Int64 = Int64.make(0x00000000, 0x00002000);
	public var STATE_BLEND_SRC_COLOR:Int64 = Int64.make(0x00000000, 0x00003000);
	public var STATE_BLEND_INV_SRC_COLOR:Int64 = Int64.make(0x00000000, 0x00004000);
	public var STATE_BLEND_SRC_ALPHA:Int64 = Int64.make(0x00000000, 0x00005000);
	public var STATE_BLEND_INV_SRC_ALPHA:Int64 = Int64.make(0x00000000, 0x00006000);
	public var STATE_BLEND_DST_ALPHA:Int64 = Int64.make(0x00000000, 0x00007000);
	public var STATE_BLEND_INV_DST_ALPHA:Int64 = Int64.make(0x00000000, 0x00008000);
	public var STATE_BLEND_DST_COLOR:Int64 = Int64.make(0x00000000, 0x00009000);
	public var STATE_BLEND_INV_DST_COLOR:Int64 = Int64.make(0x00000000, 0x0000A000);
	public var STATE_BLEND_SRC_ALPHA_SAT:Int64 = Int64.make(0x00000000, 0x0000B000);
	public var STATE_BLEND_FACTOR:Int64 = Int64.make(0x00000000, 0x0000C000);
	public var STATE_BLEND_INV_FACTOR:Int64 = Int64.make(0x00000000, 0x0000D000);
	public var STATE_BLEND_EQUATION_ADD:Int64 = Int64.make(0x00000000, 0x00000000);
	public var STATE_BLEND_EQUATION_SUB:Int64 = Int64.make(0x00000000, 0x10000000);
	public var STATE_BLEND_EQUATION_REVSUB:Int64 = Int64.make(0x00000000, 0x20000000);
	public var STATE_BLEND_EQUATION_MIN:Int64 = Int64.make(0x00000000, 0x30000000);
	public var STATE_BLEND_EQUATION_MAX:Int64 = Int64.make(0x00000000, 0x40000000);
	public var STATE_BLEND_ADD:Int64 = Int64.make(0x00000000, 0x02222000); // FUNC(ONE, ONE)
	public var STATE_BLEND_ALPHA:Int64 = Int64.make(0x00000000, 0x06565000); // FUNC(SRC_ALPHA, INV_SRC_ALPHA)
	public var STATE_BLEND_DARKEN:Int64 = Int64.make(0x00000000, 0x32222000); // FUNC(ONE, ONE) + EQUATION_MIN
	public var STATE_BLEND_LIGHTEN:Int64 = Int64.make(0x00000000, 0x42222000); // FUNC(ONE, ONE) + EQUATION_MAX
	public var STATE_BLEND_MULTIPLY:Int64 = Int64.make(0x00000000, 0x01919000); // FUNC(DST_COLOR, ZERO)
	public var STATE_BLEND_NORMAL:Int64 = Int64.make(0x00000000, 0x06262000); // FUNC(ONE, INV_SRC_ALPHA)
	public var STATE_BLEND_SCREEN:Int64 = Int64.make(0x00000000, 0x04242000); // FUNC(ONE, INV_SRC_COLOR)
	public var STATE_BLEND_LINEAR_BURN:Int64 = Int64.make(0x00000000, 0x1A9A9000); // FUNC(DST_COLOR, INV_DST_COLOR) + EQUATION_SUB
	public var STATE_BLEND_INDEPENDENT:Int64 = Int64.make(0x00000004, 0x00000000);
	public var STATE_BLEND_ALPHA_TO_COVERAGE:Int64 = Int64.make(0x00000008, 0x00000000);
	public var STATE_CULL_CW:Int64 = Int64.make(0x00000010, 0x00000000);
	public var STATE_CULL_CCW:Int64 = Int64.make(0x00000020, 0x00000000);
	public var STATE_FRONT_CCW:Int64 = Int64.make(0x00000080, 0x00000000);
	public var STATE_PT_TRISTRIP:Int64 = Int64.make(0x00010000, 0x00000000);
	public var STATE_PT_LINES:Int64 = Int64.make(0x00020000, 0x00000000);
	public var STATE_PT_LINESTRIP:Int64 = Int64.make(0x00030000, 0x00000000);
	public var STATE_PT_POINTS:Int64 = Int64.make(0x00040000, 0x00000000);
	public var STATE_MSAA:Int64 = Int64.make(0x01000000, 0x00000000);
	public var STATE_LINEAA:Int64 = Int64.make(0x02000000, 0x00000000);
	public var STATE_CONSERVATIVE_RASTER:Int64 = Int64.make(0x04000000, 0x00000000);
	public var STATE_DEFAULT:Int64 = Int64.make(0x01000050, 0x0000001F);

	public var STENCIL_NONE = 0x00000000;
	public var STENCIL_TEST_LESS = 0x00010000;
	public var STENCIL_TEST_LEQUAL = 0x00020000;
	public var STENCIL_TEST_EQUAL = 0x00030000;
	public var STENCIL_TEST_GEQUAL = 0x00040000;
	public var STENCIL_TEST_GREATER = 0x00050000;
	public var STENCIL_TEST_NOTEQUAL = 0x00060000;
	public var STENCIL_TEST_NEVER = 0x00070000;
	public var STENCIL_TEST_ALWAYS = 0x00080000;
	public var STENCIL_OP_FAIL_S_ZERO = 0x00000000;
	public var STENCIL_OP_FAIL_S_KEEP = 0x00100000;
	public var STENCIL_OP_FAIL_S_REPLACE = 0x00200000;
	public var STENCIL_OP_FAIL_S_INCR = 0x00300000;
	public var STENCIL_OP_FAIL_S_INCRSAT = 0x00400000;
	public var STENCIL_OP_FAIL_S_DECR = 0x00500000;
	public var STENCIL_OP_FAIL_S_DECRSAT = 0x00600000;
	public var STENCIL_OP_FAIL_S_INVERT = 0x00700000;
	public var STENCIL_OP_FAIL_Z_ZERO = 0x00000000;
	public var STENCIL_OP_FAIL_Z_KEEP = 0x01000000;
	public var STENCIL_OP_FAIL_Z_REPLACE = 0x02000000;
	public var STENCIL_OP_FAIL_Z_INCR = 0x03000000;
	public var STENCIL_OP_FAIL_Z_INCRSAT = 0x04000000;
	public var STENCIL_OP_FAIL_Z_DECR = 0x05000000;
	public var STENCIL_OP_FAIL_Z_DECRSAT = 0x06000000;
	public var STENCIL_OP_FAIL_Z_INVERT = 0x07000000;
	public var STENCIL_OP_PASS_Z_ZERO = 0x00000000;
	public var STENCIL_OP_PASS_Z_KEEP = 0x10000000;
	public var STENCIL_OP_PASS_Z_REPLACE = 0x20000000;
	public var STENCIL_OP_PASS_Z_INCR = 0x30000000;
	public var STENCIL_OP_PASS_Z_INCRSAT = 0x40000000;
	public var STENCIL_OP_PASS_Z_DECR = 0x50000000;
	public var STENCIL_OP_PASS_Z_DECRSAT = 0x60000000;
	public var STENCIL_OP_PASS_Z_INVERT = 0x70000000;

	public var DISCARD_NONE = 0x00;
	public var DISCARD_BINDINGS = 0x01;
	public var DISCARD_INDEX_BUFFER = 0x02;
	public var DISCARD_INSTANCE_DATA = 0x04;
	public var DISCARD_STATE = 0x08;
	public var DISCARD_TRANSFORM = 0x10;
	public var DISCARD_VERTEX_STREAMS = 0x20;
	public var DISCARD_ALL = 0xFF;

	public var BUFFER_NONE = 0x0000;
	public var BUFFER_COMPUTE_READ = 0x0100;
	public var BUFFER_COMPUTE_WRITE = 0x0200;
	public var BUFFER_COMPUTE_READ_WRITE = 0x0300;
	public var BUFFER_DRAW_INDIRECT = 0x0400;
	public var BUFFER_ALLOW_RESIZE = 0x0800;
	public var BUFFER_INDEX32 = 0x1000;

	public var TEXTURE_NONE:Int64 = Int64.make(0x00000000, 0x00000000);
	public var TEXTURE_MSAA_SAMPLE:Int64 = Int64.make(0x00000008, 0x00000000);
	public var TEXTURE_RT:Int64 = Int64.make(0x00000010, 0x00000000);
	public var TEXTURE_RT_MSAA_X2:Int64 = Int64.make(0x00000020, 0x00000000);
	public var TEXTURE_RT_MSAA_X4:Int64 = Int64.make(0x00000030, 0x00000000);
	public var TEXTURE_RT_MSAA_X8:Int64 = Int64.make(0x00000040, 0x00000000);
	public var TEXTURE_RT_MSAA_X16:Int64 = Int64.make(0x00000050, 0x00000000);
	public var TEXTURE_RT_WRITE_ONLY:Int64 = Int64.make(0x00000080, 0x00000000);
	public var TEXTURE_COMPUTE_WRITE:Int64 = Int64.make(0x00001000, 0x00000000);
	public var TEXTURE_SRGB:Int64 = Int64.make(0x00002000, 0x00000000);
	public var TEXTURE_BLIT_DST:Int64 = Int64.make(0x00004000, 0x00000000);
	public var TEXTURE_READ_BACK:Int64 = Int64.make(0x00008000, 0x00000000);
	public var TEXTURE_EXTERNAL_SHARED:Int64 = Int64.make(0x00010000, 0x00000000);

	public var SAMPLER_NONE = 0x00000000;
	public var SAMPLER_U_MIRROR = 0x00000001;
	public var SAMPLER_U_CLAMP = 0x00000002;
	public var SAMPLER_U_BORDER = 0x00000003;
	public var SAMPLER_V_MIRROR = 0x00000004;
	public var SAMPLER_V_CLAMP = 0x00000008;
	public var SAMPLER_V_BORDER = 0x0000000C;
	public var SAMPLER_W_MIRROR = 0x00000010;
	public var SAMPLER_W_CLAMP = 0x00000020;
	public var SAMPLER_W_BORDER = 0x00000030;
	public var SAMPLER_MIN_POINT = 0x00000040;
	public var SAMPLER_MIN_ANISOTROPIC = 0x00000080;
	public var SAMPLER_MAG_POINT = 0x00000100;
	public var SAMPLER_MAG_ANISOTROPIC = 0x00000200;
	public var SAMPLER_MIP_POINT = 0x00000400;
	public var SAMPLER_COMPARE_LESS = 0x00010000;
	public var SAMPLER_COMPARE_LEQUAL = 0x00020000;
	public var SAMPLER_COMPARE_EQUAL = 0x00030000;
	public var SAMPLER_COMPARE_GEQUAL = 0x00040000;
	public var SAMPLER_COMPARE_GREATER = 0x00050000;
	public var SAMPLER_COMPARE_NOTEQUAL = 0x00060000;
	public var SAMPLER_COMPARE_NEVER = 0x00070000;
	public var SAMPLER_COMPARE_ALWAYS = 0x00080000;
	public var SAMPLER_SAMPLE_STENCIL = 0x00100000;
	public var SAMPLER_POINT = 0x00000540;
	public var SAMPLER_UVW_MIRROR = 0x00000015;
	public var SAMPLER_UVW_CLAMP = 0x0000002A;
	public var SAMPLER_UVW_BORDER = 0x0000003F;

	public var RESET_NONE = 0x00000000;
	public var RESET_FULLSCREEN = 0x00000001;
	public var RESET_MSAA_X2 = 0x00000010;
	public var RESET_MSAA_X4 = 0x00000020;
	public var RESET_MSAA_X8 = 0x00000030;
	public var RESET_MSAA_X16 = 0x00000040;
	public var RESET_VSYNC = 0x00000080;
	public var RESET_MAXANISOTROPY = 0x00000100;
	public var RESET_CAPTURE = 0x00000200;
	public var RESET_FLUSH_AFTER_RENDER = 0x00002000;
	public var RESET_FLIP_AFTER_RENDER = 0x00004000;
	public var RESET_SRGB_BACKBUFFER = 0x00008000;
	public var RESET_HDR10 = 0x00010000;
	public var RESET_HIDPI = 0x00020000;
	public var RESET_DEPTH_CLAMP = 0x00040000;
	public var RESET_SUSPEND = 0x00080000;
	public var RESET_TRANSPARENT_BACKBUFFER = 0x00100000;

	public var CAPS_ALPHA_TO_COVERAGE:Int64 = Int64.make(0x00000000, 0x00000001);
	public var CAPS_BLEND_INDEPENDENT:Int64 = Int64.make(0x00000000, 0x00000002);
	public var CAPS_COMPUTE:Int64 = Int64.make(0x00000000, 0x00000004);
	public var CAPS_CONSERVATIVE_RASTER:Int64 = Int64.make(0x00000000, 0x00000008);
	public var CAPS_DRAW_INDIRECT:Int64 = Int64.make(0x00000000, 0x00000010);
	public var CAPS_DRAW_INDIRECT_COUNT:Int64 = Int64.make(0x00000000, 0x00000020);
	public var CAPS_FRAGMENT_DEPTH:Int64 = Int64.make(0x00000000, 0x00000040);
	public var CAPS_FRAGMENT_ORDERING:Int64 = Int64.make(0x00000000, 0x00000080);
	public var CAPS_GRAPHICS_DEBUGGER:Int64 = Int64.make(0x00000000, 0x00000100);
	public var CAPS_HDR10:Int64 = Int64.make(0x00000000, 0x00000200);
	public var CAPS_HIDPI:Int64 = Int64.make(0x00000000, 0x00000400);
	public var CAPS_IMAGE_RW:Int64 = Int64.make(0x00000000, 0x00000800);
	public var CAPS_INDEX32:Int64 = Int64.make(0x00000000, 0x00001000);
	public var CAPS_INSTANCING:Int64 = Int64.make(0x00000000, 0x00002000);
	public var CAPS_OCCLUSION_QUERY:Int64 = Int64.make(0x00000000, 0x00004000);
	public var CAPS_PRIMITIVE_ID:Int64 = Int64.make(0x00000000, 0x00008000);
	public var CAPS_RENDERER_MULTITHREADED:Int64 = Int64.make(0x00000000, 0x00010000);
	public var CAPS_SWAP_CHAIN:Int64 = Int64.make(0x00000000, 0x00020000);
	public var CAPS_TEXTURE_BLIT:Int64 = Int64.make(0x00000000, 0x00040000);
	public var CAPS_TEXTURE_COMPARE_LEQUAL:Int64 = Int64.make(0x00000000, 0x00080000);
	public var CAPS_TEXTURE_CUBE_ARRAY:Int64 = Int64.make(0x00000000, 0x00200000);
	public var CAPS_TEXTURE_DIRECT_ACCESS:Int64 = Int64.make(0x00000000, 0x00400000);
	public var CAPS_TEXTURE_EXTERNAL:Int64 = Int64.make(0x00000000, 0x00800000);
	public var CAPS_TEXTURE_EXTERNAL_SHARED:Int64 = Int64.make(0x00000000, 0x01000000);
	public var CAPS_TEXTURE_READ_BACK:Int64 = Int64.make(0x00000000, 0x02000000);
	public var CAPS_TEXTURE_2D_ARRAY:Int64 = Int64.make(0x00000000, 0x04000000);
	public var CAPS_TEXTURE_3D:Int64 = Int64.make(0x00000000, 0x08000000);
	public var CAPS_TRANSPARENT_BACKBUFFER:Int64 = Int64.make(0x00000000, 0x10000000);
	public var CAPS_VARIABLE_RATE_SHADING:Int64 = Int64.make(0x00000000, 0x20000000);
	public var CAPS_VERTEX_ATTRIB_HALF:Int64 = Int64.make(0x00000000, 0x40000000);
	public var CAPS_VERTEX_ATTRIB_UINT10:Int64 = Int64.make(0x00000000, 0x80000000);
	public var CAPS_VERTEX_ID:Int64 = Int64.make(0x00000001, 0x00000000);
	public var CAPS_VIEWPORT_LAYER_ARRAY:Int64 = Int64.make(0x00000002, 0x00000000);

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

	private static var __caps:BGFXCaps;

	public function getCaps():BGFXCaps
	{
		#if (lime_cffi && lime_bgfx && !macro)
		if (__caps != null) return __caps;

		return BGFXCaps.fromCFFI(NativeCFFI.lime_bgfx_get_caps());
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

	public function reset(width:Int, height:Int, flags:Int = 0, format:Int = -1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_reset(width, height, flags, format);
		#end
	}

	public function createUniform(name:String, type:BGFXUniformType, num:Int = 1):BGFXUniform
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_uniform(name, type, num);
		#end

		return null;
	}

	public function createUniformFreq(name:String, freq:BGFXUniformFreq, type:BGFXUniformType, num:Int = 1):BGFXUniform
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_uniform_freq(name, freq, type, num);
		#end

		return null;
	}

	public function setUniform(handle:BGFXUniform, value:ArrayBufferView, num:Int = 0xFFFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_uniform(handle, value, num);
		#end
	}

	public function setViewUniform(id:Int, handle:BGFXUniform, value:ArrayBufferView, num:Int = 1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_uniform(id, handle, value, num);
		#end
	}

	public function setFrameUniform(handle:BGFXUniform, value:ArrayBufferView, num:Int = 1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_frame_uniform(handle, value, num);
		#end
	}

	public function getUniformInfo(handle:BGFXUniform):BGFXUniformInfo
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_uniform_info(handle);
		#end

		return null;
	}

	public function getShaderUniforms(shader:BGFXShader):Array<BGFXUniform>
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_shader_uniforms(shader);
		#end

		return null;
	}

	public function createTexture(mem:BGFXMemoryRef, flags:Int64, skip:Int = 0):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_texture(mem, flags.high, flags.low, skip);
		#end

		return null;
	}

	public function createTexture2D(width:Int, height:Int, hasMips:Bool, numLayers:Int, format:BGFXTextureFormat, flags:Int64, ?mem:BGFXMemoryRef):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_texture_2d(width, height, hasMips, numLayers, format, flags.high, flags.low, mem);
		#end

		return null;
	}

	public function createTexture2DScaled(ratio:BGFXBackbufferRatio, hasMips:Bool, numLayers:Int, format:BGFXTextureFormat, flags:Int64):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_texture_2d_scaled(ratio, hasMips, numLayers, format, flags.high, flags.low);
		#end

		return null;
	}

	public function createTexture3D(width:Int, height:Int, depth:Int, hasMips:Bool, format:BGFXTextureFormat, flags:Int64, ?mem:BGFXMemoryRef):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_texture_3d(width, height, depth, hasMips, format, flags.high, flags.low, mem);
		#end

		return null;
	}

	public function createTextureCube(size:Int, hasMips:Bool, numLayers:Int, format:BGFXTextureFormat, flags:Int64, ?mem:BGFXMemoryRef):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_texture_cube(size, hasMips, numLayers, format, flags.high, flags.low, mem);
		#end

		return null;
	}

	public function updateTexture2D(handle:BGFXTexture, layer:Int, mip:Int, x:Int, y:Int, width:Int, height:Int, mem:BGFXMemoryRef, pitch:Int = 0xFFFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_update_texture_2d(handle, layer, mip, x, y, width, height, mem, pitch);
		#end
	}

	public function updateTexture3D(handle:BGFXTexture, mip:Int, x:Int, y:Int, z:Int, width:Int, height:Int, depth:Int, mem:BGFXMemoryRef):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_update_texture_3d(handle, mip, x, y, z, width, height, depth, mem);
		#end
	}

	public function updateTextureCube(handle:BGFXTexture, layer:Int, side:Int, mip:Int, x:Int, y:Int, width:Int, height:Int, mem:BGFXMemoryRef,
			pitch:Int = 0xFFFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_update_texture_cube(handle, layer, side, mip, x, y, width, height, mem, pitch);
		#end
	}

	public function readTexture(handle:BGFXTexture, data:ArrayBufferView, mip:Int = 0):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_read_texture(handle, data, mip);
		#end

		return 0;
	}

	public function isTextureValid(depth:Int, cubeMap:Bool, numLayers:Int, format:BGFXTextureFormat, flags:Int64):Bool
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_is_texture_valid(depth, cubeMap, numLayers, format, flags.high, flags.low);
		#end

		return false;
	}

	public function calcTextureSize(width:Int, height:Int, depth:Int, cubeMap:Bool, hasMips:Bool, numLayers:Int, format:BGFXTextureFormat):BGFXTextureInfo
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_calc_texture_size(width, height, depth, cubeMap, hasMips, numLayers, format);
		#end

		return null;
	}

	public function createFrameBuffer(width:Int, height:Int, format:BGFXTextureFormat, textureFlags:Int64):BGFXFrameBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_frame_buffer(width, height, format, textureFlags.high, textureFlags.low);
		#end

		return null;
	}

	public function createFrameBufferScaled(ratio:BGFXBackbufferRatio, format:BGFXTextureFormat, textureFlags:Int64):BGFXFrameBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_frame_buffer_scaled(ratio, format, textureFlags.high, textureFlags.low);
		#end

		return null;
	}

	public function createFrameBufferFromTextures(textures:Array<BGFXTexture>, destroyTextures:Bool = false):BGFXFrameBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_frame_buffer_from_textures(textures, destroyTextures);
		#end

		return null;
	}

	public function createFrameBufferFromAttachments(attachments:Array<BGFXAttachment>, destroyTextures:Bool = false):BGFXFrameBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_create_frame_buffer_from_attachments(attachments, destroyTextures);
		#end

		return null;
	}

	public function isFrameBufferValid(attachments:Array<BGFXAttachment>):Bool
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_is_frame_buffer_valid(attachments);
		#end

		return false;
	}

	public function getTexture(handle:BGFXFrameBuffer, attachment:Int = 0):BGFXTexture
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_texture(handle, attachment);
		#end

		return null;
	}

	public function setViewFrameBuffer(id:Int, handle:BGFXFrameBuffer):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_frame_buffer(id, handle);
		#end
	}

	public function setTexture(stage:Int, sampler:BGFXUniform, texture:BGFXTexture, flags:Int = -1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_texture(stage, sampler, texture, flags);
		#end
	}

	public function setImage(stage:Int, texture:BGFXTexture, mip:Int, access:BGFXAccess, format:Int = -1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_image(stage, texture, mip, access, format);
		#end
	}

	public function setStencil(fstencil:Int, bstencil:Int = 0):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_stencil(fstencil, bstencil);
		#end
	}

	public function setScissor(x:Int, y:Int, width:Int, height:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_set_scissor(x, y, width, height);
		#end

		return 0;
	}

	public function setScissorCached(cache:Int = 0xFFFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_scissor_cached(cache);
		#end
	}

	public function setVertexCount(numVertices:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_count(numVertices);
		#end
	}

	public function blit(id:Int, dst:BGFXTexture, dstMip:Int, dstX:Int, dstY:Int, dstZ:Int, src:BGFXTexture, srcMip:Int = 0, srcX:Int = 0, srcY:Int = 0,
			srcZ:Int = 0, width:Int = 0xFFFF, height:Int = 0xFFFF, depth:Int = 0xFFFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_blit(id, dst, dstMip, dstX, dstY, dstZ, src, srcMip, srcX, srcY, srcZ, width, height, depth);
		#end
	}

	public function setComputeIndexBuffer(stage:Int, handle:BGFXIndexBuffer, access:BGFXAccess):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_compute_index_buffer(stage, handle, access);
		#end
	}

	public function setComputeVertexBuffer(stage:Int, handle:BGFXVertexBuffer, access:BGFXAccess):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_compute_vertex_buffer(stage, handle, access);
		#end
	}

	public function setComputeDynamicIndexBuffer(stage:Int, handle:BGFXDynamicIndexBuffer, access:BGFXAccess):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_compute_dynamic_index_buffer(stage, handle, access);
		#end
	}

	public function setComputeDynamicVertexBuffer(stage:Int, handle:BGFXDynamicVertexBuffer, access:BGFXAccess):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_compute_dynamic_vertex_buffer(stage, handle, access);
		#end
	}

	public function setComputeIndirectBuffer(stage:Int, handle:BGFXIndirectBuffer, access:BGFXAccess):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_compute_indirect_buffer(stage, handle, access);
		#end
	}

	public function dispatch(id:Int, program:BGFXProgram, numX:Int = 1, numY:Int = 1, numZ:Int = 1, flags:Int = 0xFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_dispatch(id, program, numX, numY, numZ, flags);
		#end
	}

	public function dispatchIndirect(id:Int, program:BGFXProgram, ixbh:BGFXIndirectBuffer, start:Int = 0, num:Int = 1, flags:Int = 0xFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_dispatch_indirect(id, program, ixbh, start, num, flags);
		#end
	}

	public function discard(flags:Int = 0xFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_discard(flags);
		#end
	}

	public function allocInstanceDataBuffer(num:Int, stride:Int):BGFXInstanceDataBuffer
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_alloc_instance_data_buffer(num, stride);
		#end

		return null;
	}

	public function getAvailInstanceDataBuffer(num:Int, stride:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_avail_instance_data_buffer(num, stride);
		#end

		return 0;
	}

	public function getInstanceDataBufferData(idb:BGFXInstanceDataBuffer):ArrayBufferView
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_instance_data_buffer_data(idb);
		#end

		return null;
	}

	public function setInstanceDataBufferData(idb:BGFXInstanceDataBuffer, data:ArrayBufferView):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_instance_data_buffer_data(idb, data);
		#end
	}

	public function setInstanceDataBuffer(idb:BGFXInstanceDataBuffer, start:Int = 0, num:Int = -1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_instance_data_buffer(idb, start, num);
		#end
	}

	public function setInstanceDataFromVertexBuffer(handle:BGFXVertexBuffer, startVertex:Int, num:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_instance_data_from_vertex_buffer(handle, startVertex, num);
		#end
	}

	public function setInstanceDataFromDynamicVertexBuffer(handle:BGFXDynamicVertexBuffer, startVertex:Int, num:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_instance_data_from_dynamic_vertex_buffer(handle, startVertex, num);
		#end
	}

	public function setInstanceCount(numInstances:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_instance_count(numInstances);
		#end
	}

	public function resetView(id:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_reset_view(id);
		#end
	}

	public function setViewClearMRT(id:Int, flags:Int, depth:Float, stencil:Int, c0:Int = 0xFF, c1:Int = 0xFF, c2:Int = 0xFF, c3:Int = 0xFF, c4:Int = 0xFF,
			c5:Int = 0xFF, c6:Int = 0xFF, c7:Int = 0xFF):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_clear_mrt(id, flags, depth, stencil, c0, c1, c2, c3, c4, c5, c6, c7);
		#end
	}

	public function setViewMode(id:Int, mode:BGFXViewMode):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_mode(id, mode);
		#end
	}

	public function setViewName(id:Int, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_name(id, name);
		#end
	}

	public function setViewOrder(id:Int = 0, num:Int = -1, ?order:Array<Int>):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_order(id, num, order);
		#end
	}

	public function setViewScissor(id:Int, x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_scissor(id, x, y, width, height);
		#end
	}

	public function allocTransform(data:ArrayBufferView, num:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_alloc_transform(data, num);
		#end

		return 0;
	}

	public function setTransformCached(cache:Int, num:Int = 1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transform_cached(cache, num);
		#end
	}

	public function setCondition(handle:BGFXOcclusionQuery, visible:Bool):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_condition(handle, visible);
		#end
	}

	public function setMarker(name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_marker(name);
		#end
	}

	public function setPaletteColor(index:Int, r:Float, g:Float, b:Float, a:Float):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_palette_color(index, r, g, b, a);
		#end
	}

	public function setPaletteColorRGBA8(index:Int, rgba:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_palette_color_rgba8(index, rgba);
		#end
	}

	public function setViewShadingRate(id:Int, shadingRate:Int):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_view_shading_rate(id, shadingRate);
		#end
	}

	public function setShaderName(handle:BGFXShader, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_shader_name(handle, name);
		#end
	}

	public function setTextureName(handle:BGFXTexture, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_texture_name(handle, name);
		#end
	}

	public function setFrameBufferName(handle:BGFXFrameBuffer, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_frame_buffer_name(handle, name);
		#end
	}

	public function setIndexBufferName(handle:BGFXIndexBuffer, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_index_buffer_name(handle, name);
		#end
	}

	public function setVertexBufferName(handle:BGFXVertexBuffer, name:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_vertex_buffer_name(handle, name);
		#end
	}

	public function getRendererType():BGFXRendererType
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_renderer_type();
		#end

		return NOOP;
	}

	public function getRendererName(type:BGFXRendererType):String
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_renderer_name(type);
		#end

		return null;
	}

	public function getSupportedRenderers():Array<BGFXRendererType>
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_supported_renderers();
		#end

		return null;
	}

	public function alloc(size:Int):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_alloc(size);
		#end

		return null;
	}

	public function copy(data:ArrayBufferView, ?size:Int):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_copy(data, size ?? data.byteLength);
		#end

		return null;
	}

	public function vertexPack(input:ArrayBufferView, inputNormalized:Bool, attrib:BGFXAttrib, layout:BGFXVertexLayout, data:ArrayBufferView,
			index:Int = 0):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_pack(input, inputNormalized, attrib, layout, data, index);
		#end
	}

	public function vertexUnpack(output:ArrayBufferView, attrib:BGFXAttrib, layout:BGFXVertexLayout, data:ArrayBufferView, index:Int = 0):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_unpack(output, attrib, layout, data, index);
		#end
	}

	public function vertexConvert(dstLayout:BGFXVertexLayout, dstData:ArrayBufferView, srcLayout:BGFXVertexLayout, srcData:ArrayBufferView,
			num:Int = 1):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_convert(dstLayout, dstData, srcLayout, srcData, num);
		#end
	}

	public function topologyConvert(conversion:BGFXTopologyConvert, dst:ArrayBufferView, dstSize:Int, indices:ArrayBufferView, numIndices:Int,
			index32:Bool):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_topology_convert(conversion, dst, dstSize, indices, numIndices, index32);
		#end

		return 0;
	}

	public function topologySortTriList(sort:BGFXTopologySort, dst:ArrayBufferView, dstSize:Int, dir:ArrayBufferView, pos:ArrayBufferView,
			vertices:ArrayBufferView, stride:Int, indices:ArrayBufferView, numIndices:Int, index32:Bool):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_topology_sort_tri_list(sort, dst, dstSize, dir, pos, vertices, stride, indices, numIndices, index32);
		#end
	}

	public function overrideInternalTexture(handle:BGFXTexture, width:Int, height:Int, numMips:Int, format:BGFXTextureFormat, flags:Int64):Float
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_override_internal_texture(handle, width, height, numMips, format, flags.high, flags.low);
		#end

		return 0;
	}

	public function requestScreenShot(handle:BGFXFrameBuffer, filePath:String):Void
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_request_screen_shot(handle, filePath);
		#end
	}

	public function compileShaderString(type:BGFXShaderType, shaderSource:String, varyingDef:String, ?includes:Map<String, String>, ?defines:String = '',
			?profile:String = '', ?includeDirs:String = ''):BGFXMemoryRef
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

		return NativeCFFI.lime_bgfx_compile_shader_string(type, sc.join('\n'), varyingDef, defines, profile, includeDirs);
		#end

		return null;
	}

	public function compileShaderFile(type:BGFXShaderType, filePath:String, varyingPath:String, ?includeDirs:String = '', ?defines:String = '',
			?profile:String = ''):BGFXMemoryRef
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_compile_shader_file(type, filePath, varyingPath, defines, profile, includeDirs);
		#end

		return null;
	}

	// Bgfx builds it's blend funcs through a macro that kinda looks like this
	public inline function blendFunc(src:Int64, dst:Int64):Int64
	{
		return blendFuncSeparate(src, dst, src, dst);
	}

	public inline function blendFuncSeparate(srcRGB:Int64, dstRGB:Int64, srcA:Int64, dstA:Int64):Int64
	{
		return (srcRGB | (dstRGB << 4)) | ((srcA | (dstA << 4)) << 8);
	}
}
