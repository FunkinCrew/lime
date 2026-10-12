package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.Int64;

import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.system.CFFIPointer)
@:forward
abstract MAEngine(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public static function init(pConfig:MAEngineConfig):MAEngine
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_init(pConfig.toDynamicObject());
		#else
		return null;
		#end
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_uninit(this);
		#end
	}

	public function read_pcm_frames(pFrames:CFFIPointer, frameCount:Int64):Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_engine_read_pcm_frames(this, pFrames, {high: frameCount.high, low: frameCount.low});

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function get_log():MALog
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_log(this);
		#else
		return null;
		#end
	}

	public function get_time_in_pcm_frames():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_engine_get_time_in_pcm_frames(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function get_time_in_milliseconds():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_engine_get_time_in_milliseconds(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function set_time_in_pcm_frames(globalTime:Int64):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_set_time_in_pcm_frames(this, {high: globalTime.high, low: globalTime.low});
		#else
		return MAResult.ERROR;
		#end
	}

	public function set_time_in_milliseconds(globalTime:Int64):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_set_time_in_milliseconds(this, {high: globalTime.high, low: globalTime.low});
		#else
		return MAResult.ERROR;
		#end
	}

	public function get_channels():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_channels(this);
		#else
		return 0;
		#end
	}

	public function get_sample_rate():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_sample_rate(this);
		#else
		return 0;
		#end
	}

	public function start():MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_start(this);
		#else
		return MAResult.ERROR;
		#end
	}

	public function stop():MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_stop(this);
		#else
		return MAResult.ERROR;
		#end
	}

	public function set_volume(volume:Float):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_set_volume(this, volume);
		#else
		return MAResult.ERROR;
		#end
	}

	public function get_volume():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_volume(this);
		#else
		return 0;
		#end
	}

	public function set_gain_db(gainDB:Float):MAResult
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_set_gain_db(this, gainDB);
		#else
		return MAResult.ERROR;
		#end
	}

	public function get_gain_db():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_gain_db(this);
		#else
		return 0;
		#end
	}

	public function get_listener_count():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_get_listener_count(this);
		#else
		return 0;
		#end
	}

	public function find_closest_listener(absolutePosX:Float, absolutePosY:Float, absolutePosZ:Float):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_find_closest_listener(this, absolutePosX, absolutePosY, absolutePosZ);
		#else
		return 0;
		#end
	}

	public function listener_set_position(listenerIndex:Int, x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_position(this, listenerIndex, x, y, z);
		#end
	}

	public function listener_get_position(listenerIndex:Int):Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_engine_listener_get_position(this, listenerIndex);
		#else
		return [];
		#end
	}

	public function listener_set_direction(listenerIndex:Int, x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_direction(this, listenerIndex, x, y, z);
		#end
	}

	public function listener_get_direction(listenerIndex:Int):Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_engine_listener_get_direction(this, listenerIndex);
		#else
		return [];
		#end
	}

	public function listener_set_velocity(listenerIndex:Int, x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_velocity(this, listenerIndex, x, y, z);
		#end
	}

	public function listener_get_velocity(listenerIndex:Int):Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_engine_listener_get_velocity(this, listenerIndex);
		#else
		return [];
		#end
	}

	public function listener_set_cone(listenerIndex:Int, innerAngleInRadians:Float, outerAngleInRadians:Float, outerGain:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_cone(this, listenerIndex, innerAngleInRadians, outerAngleInRadians, outerGain);
		#end
	}

	public function listener_get_cone(listenerIndex:Int):Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_engine_listener_get_cone(this, listenerIndex);
		#else
		return [];
		#end
	}

	public function listener_set_world_up(listenerIndex:Int, x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_world_up(this, listenerIndex, x, y, z);
		#end
	}

	public function listener_get_world_up(listenerIndex:Int):Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_engine_listener_get_world_up(this, listenerIndex);
		#else
		return [];
		#end
	}

	public function listener_set_enabled(listenerIndex:Int, isEnabled:Bool):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_engine_listener_set_enabled(this, listenerIndex, isEnabled);
		#end
	}

	public function listener_is_enabled(listenerIndex:Int):Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_engine_listener_is_enabled(this, listenerIndex);
		#else
		return false;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MAEngine, b:MAEngine):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MAEngine, b:MAEngine):Bool
	{
		return a.get() != b.get();
	}
}
#end
