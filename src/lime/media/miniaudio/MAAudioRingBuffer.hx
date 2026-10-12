package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime._internal.backend.native.NativeCFFI;
import lime.system.CFFIPointer;

@:access(lime._internal.backend.native.NativeCFFI)
@:forward
abstract MAAudioRingBuffer(MADataSource) from MADataSource to MADataSource
{
	public static function init(pConfig:MAAudioRingBufferConfig):MAAudioRingBuffer
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_init(pConfig.toDynamicObject());
		#else
		return null;
		#end
	}

	public function uninit():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_audio_ring_buffer_uninit(this);
		#end
	}

	public function map_produce(frameCount:Int, ppMappedBuffer:CFFIPointer):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_map_produce(this, frameCount, ppMappedBuffer);
		#else
		return 0;
		#end
	}

	public function unmap_produce(frameCount:Int):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_audio_ring_buffer_unmap_produce(this, frameCount);
		#end
	}

	public function map_consume(frameCount:Int, ppMappedBuffer:CFFIPointer):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_map_consume(this, frameCount, ppMappedBuffer);
		#else
		return 0;
		#end
	}

	public function unmap_consume(frameCount:Int):Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_ma_audio_ring_buffer_unmap_consume(this, frameCount);
		#end
	}

	public function write_pcm_frames(pFrames:CFFIPointer, frameCount:Int):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_write_pcm_frames(this, pFrames, frameCount);
		#else
		return 0;
		#end
	}

	public function read_pcm_frames(pFrames:CFFIPointer, frameCount:Int):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_read_pcm_frames(this, pFrames, frameCount);
		#else
		return 0;
		#end
	}

	public function get_length_in_pcm_frames():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_ma_audio_ring_buffer_get_length_in_pcm_frames(this);
		#else
		return 0;
		#end
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:MAAudioRingBuffer, b:MAAudioRingBuffer):Bool
	{
		return a.get() == b.get();
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:MAAudioRingBuffer, b:MAAudioRingBuffer):Bool
	{
		return a.get() != b.get();
	}
}
#end
