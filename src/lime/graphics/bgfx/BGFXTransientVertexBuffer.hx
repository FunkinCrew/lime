package lime.graphics.bgfx;

#if (!lime_doc_gen || lime_bgfx)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;
import lime.utils.ArrayBufferView;

@:access(lime._internal.backend.native.NativeCFFI)
abstract BGFXTransientVertexBuffer(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public var data(get, set):ArrayBufferView;

	public function new(handle)
	{
		this = handle;
	}

	private function get_data():ArrayBufferView
	{
		#if (lime_cffi && lime_bgfx && !macro)
		return NativeCFFI.lime_bgfx_get_transient_vertex_buffer_data(this);
		#else
		return null;
		#end
	}

	private function set_data(value:ArrayBufferView):ArrayBufferView
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_vertex_buffer_data(this, value);
		#end
		return value;
	}
}
#end
