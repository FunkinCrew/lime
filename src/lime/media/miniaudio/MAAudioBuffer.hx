package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.Int64;

import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
@:forward
abstract MAAudioBuffer(MADataSource) from MADataSource to MADataSource
{
	public static function init(pConfig:MAAudioBufferConfig):MAAudioBuffer
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_buffer_init(pConfig.toDynamicObject());
		#else
		return null;
		#end
	}

	public static function init_and_copy_data(pConfig:MAAudioBufferConfig):MAAudioBuffer
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_buffer_init_and_copy_data(pConfig.toDynamicObject());
		#else
		return null;
		#end
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_audio_buffer_uninit(this);
		#end
	}

	public function read_pcm_frames(pFrames:CFFIPointer, frameCount:Int64):Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_audio_buffer_read_pcm_frames(this, pFrames, {high: frameCount.high, low: frameCount.low});

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function seek_to_pcm_frame(frameIndex:Int64):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_buffer_seek_to_pcm_frame(this, {high: frameIndex.high, low: frameIndex.low});
		#else
		return MAResult.ERROR;
		#end
	}

	public function at_end():Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_buffer_at_end(this);
		#else
		return false;
		#end
	}

	public function get_cursor_in_pcm_frames():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_audio_buffer_get_cursor_in_pcm_frames(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function get_length_in_pcm_frames():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_audio_buffer_get_length_in_pcm_frames(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	public function get_available_frames():Int64
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		final result:Dynamic = NativeCFFI.lime_ma_audio_buffer_get_available_frames(this);

		return Int64.make(result.high, result.low);
		#else
		return 0;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MAAudioBuffer, b:MAAudioBuffer):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MAAudioBuffer, b:MAAudioBuffer):Bool
	{
		return a.get() != b.get();
	}
}
#end
