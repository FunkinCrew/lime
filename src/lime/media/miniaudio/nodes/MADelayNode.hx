package lime.media.miniaudio.nodes;

#if (!lime_doc_gen || lime_miniaudio)
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
@:forward
abstract MADelayNode(MANode) from MANode to MANode
{
	public static function init(pNodeGraph:MANodeGraph, pConfig:MADelayNodeConfig):MADelayNode
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		if (pConfig != null)
		{
			return NativeCFFI.lime_ma_delay_node_init(pNodeGraph, pConfig.toDynamicObject());
		}
		#end

		return null;
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_delay_node_uninit(this);
		#end
	}

	public function set_decay(value:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_delay_node_set_decay(this, value);
		#end
	}

	public function get_decay():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_delay_node_get_decay(this);
		#else
		return 0.0;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MADelayNode, b:MADelayNode):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MADelayNode, b:MADelayNode):Bool
	{
		return a.get() != b.get();
	}
}
#end
