package lime.graphics.bgfx;

#if (!lime_doc_gen || lime_bgfx)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
abstract BGFXVertexLayout(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public function new(handle)
	{
		this = handle;
	}

	public function begin(backend:BGFXRendererType):BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_layout_begin(this, backend);
		#end
		return this;
	}

	public function add(attrib:BGFXAttrib, num:Int, type:BGFXAttribType, normalized:Bool = false, asInt:Bool = false):BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_layout_add(this, attrib, num, type, normalized, asInt);
		#end
		return this;
	}

	public function end():BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_layout_end(this);
		#end
		return this;
	}

	public function decode(attrib:BGFXAttrib):BGFXAttribInfo
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_vertex_layout_decode(this, attrib);
		#else
		return null;
		#end
	}

	public function has(attrib:BGFXAttrib):Bool
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_vertex_layout_has(this, attrib);
		#else
		return false;
		#end
	}

	public function skip(num:Int):BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_layout_skip(this, num);
		#end
		return this;
	}

	public function getOffset(attrib:BGFXAttrib):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_vertex_layout_get_offset(this, attrib);
		#else
		return 0;
		#end
	}

	public function getStride():Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_vertex_layout_get_stride(this);
		#else
		return 0;
		#end
	}

	public function getSize(num:Int):Int
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_vertex_layout_get_size(this, num);
		#else
		return 0;
		#end
	}
}
#end
