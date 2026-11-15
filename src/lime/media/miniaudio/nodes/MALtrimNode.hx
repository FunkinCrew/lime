package lime.media.miniaudio.nodes;

#if (!lime_doc_gen || lime_miniaudio)
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
@:forward
abstract MALtrimNode(MANode) from MANode to MANode
{
	public static function init(pNodeGraph:MANodeGraph, pConfig:MALtrimNodeConfig):MALtrimNode
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		if (pConfig != null)
		{
			return NativeCFFI.lime_ma_ltrim_node_init(pNodeGraph, pConfig.toDynamicObject());
		}
		#end

		return null;
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_ltrim_node_uninit(this);
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MALtrimNode, b:MALtrimNode):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MALtrimNode, b:MALtrimNode):Bool
	{
		return a.get() != b.get();
	}
}
#end
