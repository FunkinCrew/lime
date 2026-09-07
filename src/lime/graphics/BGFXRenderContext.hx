package lime.graphics;

#if (!lime_doc_gen || lime_bgfx)
#if (lime_doc_gen || (sys && lime_cffi && !doc_gen))
import lime._internal.backend.native.NativeBGFXRenderContext;

@:access(lime.graphics.RenderContext)
@:forward()
@:transitive
abstract BGFXRenderContext(NativeBGFXRenderContext) from NativeBGFXRenderContext to NativeBGFXRenderContext
{
	@:from private static function fromRenderContext(context:RenderContext):BGFXRenderContext
	{
		return context.bgfx;
	}
}
#else
@:forward()
@:transitive
abstract BGFXRenderContext(Dynamic) from Dynamic to Dynamic
{
	@:from private static function fromRenderContext(context:RenderContext):BGFXRenderContext
	{
		return null;
	}
}
#end
#end
