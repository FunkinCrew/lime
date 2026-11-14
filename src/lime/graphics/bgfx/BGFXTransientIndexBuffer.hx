package lime.graphics.bgfx;

#if (!lime_doc_gen || lime_bgfx)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;
import lime.utils.UInt8Array;
import lime.utils.ArrayBufferView;
import lime.utils.DataPointer;

@:access(lime._internal.backend.native.NativeCFFI)
abstract BGFXTransientIndexBuffer(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public var data(get, set):ArrayBufferView;

	public function new(handle)
	{
		this = handle;
	}

	private function get_data():ArrayBufferView
	{
		#if (lime_cffi && lime_bgfx && !macro)
		var bufferView:UInt8Array = new UInt8Array(0);

		if (NativeCFFI.lime_bgfx_get_transient_index_buffer_data(this, bufferView))
		{
			return bufferView;
		}
		#end

		return null;
	}

	private function set_data(value:ArrayBufferView):ArrayBufferView
	{
		#if (lime_cffi && lime_bgfx && !macro)
		NativeCFFI.lime_bgfx_set_transient_index_buffer_data(this, DataPointer.fromArrayBufferView(value), value != null ? value.byteLength : 0);
		#end
		return value;
	}
}
#end
