package lime.graphics.bgfx;

#if (!lime_doc_gen || lime_bgfx)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
abstract BGFXInstanceDataBuffer(CFFIPointer) from CFFIPointer to CFFIPointer {}
#end
