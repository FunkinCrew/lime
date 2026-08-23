package lime.graphics;

import haxe.Int64;

import lime._internal.backend.native.NativeCFFI;
import lime.utils.Bytes;
import lime.utils.UInt8Array;

@:access(lime._internal.backend.native.NativeCFFI)
class AnimationDecoder
{
	public static function fromFile(path:String, ?codec:AnimationDecoderType = GIF):AnimationDecoder
	{
		#if (lime_cffi && !macro)
		if (codec != null)
		{
			var handle = NativeCFFI.lime_animation_decoder_open_file(path, cast codec);

			if (handle != null)
			{
				return new AnimationDecoder(handle);
			}
		}
		#end

		return null;
	}

	public static function fromBytes(bytes:Bytes, ?codec:AnimationDecoderType = GIF):AnimationDecoder
	{
		#if (lime_cffi && !macro)
		if (codec != null)
		{
			var handle = NativeCFFI.lime_animation_decoder_open_bytes(bytes, cast codec);

			if (handle != null)
			{
				return new AnimationDecoder(handle);
			}
		}
		#end

		return null;
	}

	@:noCompletion
	private var handle:Dynamic;

	@:noCompletion
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	public function getFrame():AnimationDecoderFrame
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			final imageBuffer:ImageBuffer = new ImageBuffer(new UInt8Array(Bytes.alloc(0)));

			final decodedFrame:Dynamic = NativeCFFI.lime_animation_decoder_get_frame(handle, imageBuffer);

			if (decodedFrame != null)
			{
				final frame:AnimationDecoderFrame = new AnimationDecoderFrame();
				frame.buffer = decodedFrame.buffer;
				frame.duration = Int64.make(decodedFrame.duration.high, decodedFrame.duration.low);
				return frame;
			}
		}
		#end

		return null;
	}

	public function getStatus():AnimationDecoderStatus
	{
		#if (lime_cffi && !macro)
		return handle != null ? cast NativeCFFI.lime_animation_decoder_get_status(handle) : INVALID;
		#else
		return INVALID;
		#end
	}

	public function reset():Bool
	{
		#if (lime_cffi && !macro)
		return handle != null ? NativeCFFI.lime_animation_decoder_reset(handle) : false;
		#else
		return false;
		#end
	}
}
