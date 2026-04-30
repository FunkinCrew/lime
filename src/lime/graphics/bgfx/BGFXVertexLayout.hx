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

	public function begin(backend:BGFXBackend):BGFXVertexLayout
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_vertex_layout_begin(this, backend);
		#end

		return this;
	}

	public function add(offset:Float, attrib:Int, num:Int, type:Int, normalized:Bool, asInt:Bool):BGFXVertexLayout
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
}
#end
