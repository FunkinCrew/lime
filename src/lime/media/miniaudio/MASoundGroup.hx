package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.Int64;

import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.system.CFFIPointer)
@:forward
abstract MASoundGroup(CFFIPointer) from CFFIPointer to CFFIPointer
{
	public static function init(pEngine:MAEngine, flags:Int, pParentGroup:MASoundGroup, pNotifications:MASoundNotifications):MASoundGroup
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_init(pEngine, flags, pParentGroup, pNotifications);
		#else
		return null;
		#end
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_uninit(this);
		#end
	}

	public function get_engine():MAEngine
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_engine(this);
		#else
		return null;
		#end
	}

	public function start():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_start(this);
		#else
		return MAResult.ERROR;
		#end
	}

	public function stop():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_stop(this);
		#else
		return MAResult.ERROR;
		#end
	}

	public function set_volume(volume:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_volume(this, volume);
		#end
	}

	public function get_volume():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_volume(this);
		#else
		return 0;
		#end
	}

	public function set_pan(pan:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_pan(this, pan);
		#end
	}

	public function get_pan():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_pan(this);
		#else
		return 0;
		#end
	}

	public function set_pan_mode(panMode:Int):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_pan_mode(this, panMode);
		#end
	}

	public function get_pan_mode():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_pan_mode(this);
		#else
		return 0;
		#end
	}

	public function set_pitch(pitch:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_pitch(this, pitch);
		#end
	}

	public function get_pitch():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_pitch(this);
		#else
		return 0;
		#end
	}

	public function set_spatialization_enabled(enabled:Bool):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_spatialization_enabled(this, enabled);
		#end
	}

	public function is_spatialization_enabled():Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_is_spatialization_enabled(this);
		#else
		return false;
		#end
	}

	public function set_pinned_listener_index(listenerIndex:Int):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_pinned_listener_index(this, listenerIndex);
		#end
	}

	public function get_pinned_listener_index():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_pinned_listener_index(this);
		#else
		return 0;
		#end
	}

	public function get_listener_index():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_listener_index(this);
		#else
		return 0;
		#end
	}

	public function get_direction_to_listener():Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_sound_group_get_direction_to_listener(this);
		#else
		return [];
		#end
	}

	public function set_position(x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_position(this, x, y, z);
		#end
	}

	public function get_position():Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_sound_group_get_position(this);
		#else
		return [];
		#end
	}

	public function set_direction(x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_direction(this, x, y, z);
		#end
	}

	public function get_direction():Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_sound_group_get_direction(this);
		#else
		return [];
		#end
	}

	public function set_velocity(x:Float, y:Float, z:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_velocity(this, x, y, z);
		#end
	}

	public function get_velocity():Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_sound_group_get_velocity(this);
		#else
		return [];
		#end
	}

	public function set_attenuation_model(attenuationModel:MAAttenuationModel):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_attenuation_model(this, attenuationModel);
		#end
	}

	public function get_attenuation_model():MAAttenuationModel
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_attenuation_model(this);
		#else
		return MAAttenuationModel.NONE;
		#end
	}

	public function set_positioning(positioning:MAPositioning):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_positioning(this, positioning);
		#end
	}

	public function get_positioning():MAPositioning
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_positioning(this);
		#else
		return 0;
		#end
	}

	public function set_rolloff(rolloff:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_rolloff(this, rolloff);
		#end
	}

	public function get_rolloff():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_rolloff(this);
		#else
		return 0;
		#end
	}

	public function set_min_gain(minGain:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_min_gain(this, minGain);
		#end
	}

	public function get_min_gain():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_min_gain(this);
		#else
		return 0;
		#end
	}

	public function set_max_gain(maxGain:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_max_gain(this, maxGain);
		#end
	}

	public function get_max_gain():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_max_gain(this);
		#else
		return 0;
		#end
	}

	public function set_min_distance(minDistance:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_min_distance(this, minDistance);
		#end
	}

	public function get_min_distance():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_min_distance(this);
		#else
		return 0;
		#end
	}

	public function set_max_distance(maxDistance:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_max_distance(this, maxDistance);
		#end
	}

	public function get_max_distance():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_max_distance(this);
		#else
		return 0;
		#end
	}

	public function set_cone(innerAngleInRadians:Float, outerAngleInRadians:Float, outerGain:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_cone(this, innerAngleInRadians, outerAngleInRadians, outerGain);
		#end
	}

	public function get_cone():Array<Float>
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return cast NativeCFFI.lime_ma_sound_group_get_cone(this);
		#else
		return [];
		#end
	}

	public function set_doppler_factor(dopplerFactor:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_doppler_factor(this, dopplerFactor);
		#end
	}

	public function get_doppler_factor():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_doppler_factor(this);
		#else
		return 0;
		#end
	}

	public function set_directional_attenuation_factor(directionalAttenuationFactor:Float):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_directional_attenuation_factor(this, directionalAttenuationFactor);
		#end
	}

	public function get_directional_attenuation_factor():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_directional_attenuation_factor(this);
		#else
		return 0;
		#end
	}

	public function set_fade_in_pcm_frames(volumeBeg:Float, volumeEnd:Float, fadeLengthInFrames:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_fade_in_pcm_frames(this, volumeBeg, volumeEnd, {high: fadeLengthInFrames.high, low: fadeLengthInFrames.low});
		#end
	}

	public function set_fade_in_milliseconds(volumeBeg:Float, volumeEnd:Float, fadeLengthInMilliseconds:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_fade_in_milliseconds(this, volumeBeg, volumeEnd,
			{high: fadeLengthInMilliseconds.high, low: fadeLengthInMilliseconds.low});
		#end
	}

	public function get_current_fade_volume():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_get_current_fade_volume(this);
		#else
		return 0;
		#end
	}

	public function set_start_time_in_pcm_frames(absoluteGlobalTimeInFrames:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_start_time_in_pcm_frames(this, {high: absoluteGlobalTimeInFrames.high, low: absoluteGlobalTimeInFrames.low});
		#end
	}

	public function set_start_time_in_milliseconds(absoluteGlobalTimeInmilliseconds:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_start_time_in_milliseconds(this,
			{high: absoluteGlobalTimeInmilliseconds.high, low: absoluteGlobalTimeInmilliseconds.low});
		#end
	}

	public function set_stop_time_in_pcm_frames(absoluteGlobalTimeInFrames:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_stop_time_in_pcm_frames(this, {high: absoluteGlobalTimeInFrames.high, low: absoluteGlobalTimeInFrames.low});
		#end
	}

	public function set_stop_time_in_milliseconds(absoluteGlobalTimeInmilliseconds:Int64):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_sound_group_set_stop_time_in_milliseconds(this,
			{high: absoluteGlobalTimeInmilliseconds.high, low: absoluteGlobalTimeInmilliseconds.low});
		#end
	}

	public function is_playing():Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_sound_group_is_playing(this);
		#else
		return false;
		#end
	}

	public function get_time_in_pcm_frames():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_sound_group_get_time_in_pcm_frames(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MASoundGroup, b:MASoundGroup):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MASoundGroup, b:MASoundGroup):Bool
	{
		return a.get() != b.get();
	}
}
#end
