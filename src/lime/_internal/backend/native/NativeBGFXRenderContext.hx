package lime._internal.backend.native;

import haxe.io.Bytes;
import haxe.Int64;
import lime.graphics.ImageBuffer;
import lime.utils.ArrayBufferView;
import lime.graphics.RenderContextType;
import lime.system.CFFI;
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

	public function stats():Dynamic
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
}
