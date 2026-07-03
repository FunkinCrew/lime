package lime.media;

import haxe.Int64;
import lime.media.AudioCodec;
import lime.utils.Bytes;
import lime._internal.backend.native.NativeCFFI;

/**
	The `AudioDecoder` class provides low-level access to decode audio streams.
**/
@:access(lime._internal.backend.native.NativeCFFI)
class AudioDecoder
{
	/**
		Creates an `AudioBuffer` from a file.

		@param path The path to the audio file.
		@param codec The expected audio codec format, or `null` to auto-detect.
		@return An `AudioDecoder` instance, or `null` if the file cannot be opened.
	**/
	public static function fromFile(path:String, ?codec:AudioCodec):AudioDecoder
	{
		#if (lime_cffi && !macro)
		if (codec != null)
		{
			var handle = NativeCFFI.lime_audio_decoder_open_file(path, cast codec);

			if (handle != null)
			{
				return new AudioDecoder(handle);
			}
		}
		else
		{
			var oggHandle = NativeCFFI.lime_audio_decoder_open_file(path, cast OGG);

			if (oggHandle != null)
			{
				return new AudioDecoder(oggHandle);
			}

			var opusHandle = NativeCFFI.lime_audio_decoder_open_file(path, cast OPUS);

			if (opusHandle != null)
			{
				return new AudioDecoder(opusHandle);
			}

			var flacHandle = NativeCFFI.lime_audio_decoder_open_file(path, cast FLAC);

			if (flacHandle != null)
			{
				return new AudioDecoder(flacHandle);
			}

			var mp3Handle = NativeCFFI.lime_audio_decoder_open_file(path, cast MP3);

			if (mp3Handle != null)
			{
				return new AudioDecoder(mp3Handle);
			}

			var wavHandle = NativeCFFI.lime_audio_decoder_open_file(path, cast WAV);

			if (wavHandle != null)
			{
				return new AudioDecoder(wavHandle);
			}
		}
		#end

		return null;
	}

	/**
		Creates an `AudioDecoder` from a `Bytes` object.

		@param bytes The encoded audio data.
		@param codec The expected audio codec format.
		@return An `AudioDecoder` instance, or `null` if decoding cannot be initialized.
	**/
	public static function fromBytes(bytes:Bytes, ?codec:AudioCodec):AudioDecoder
	{
		#if (lime_cffi && !macro)
		if (codec != null)
		{
			var handle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast codec);

			if (handle != null)
			{
				return new AudioDecoder(handle);
			}
		}
		else
		{
			var oggHandle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast OGG);

			if (oggHandle != null)
			{
				return new AudioDecoder(oggHandle);
			}

			var opusHandle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast OPUS);

			if (opusHandle != null)
			{
				return new AudioDecoder(opusHandle);
			}

			var flacHandle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast FLAC);

			if (flacHandle != null)
			{
				return new AudioDecoder(flacHandle);
			}

			var mp3Handle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast MP3);

			if (mp3Handle != null)
			{
				return new AudioDecoder(mp3Handle);
			}

			var wavHandle = NativeCFFI.lime_audio_decoder_open_bytes(bytes, cast WAV);

			if (wavHandle != null)
			{
				return new AudioDecoder(wavHandle);
			}
		}
		#end

		return null;
	}

	/**
		The number of audio channels in the stream.

		- `1` = Mono
		- `2` = Stereo
	**/
	public var channels(default, null):Int = 0;

	/**
		The sample rate of the audio stream in Hz.

		Typical values include:
		- `44100` (CD quality)
		- `48000` (standard modern audio)
	**/
	public var sampleRate(default, null):Int = 0;

	@:noCompletion
	private var handle:Dynamic;

	@:noCompletion
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;

		#if (lime_cffi && !macro)
		if (handle != null)
		{
			var info = NativeCFFI.lime_audio_decoder_info(handle);

			if (info != null)
			{
				this.channels = info.channels;
				this.sampleRate = info.sampleRate;
			}
		}
		#end
	}

	/**
		Decodes a number of audio frames into raw PCM data.

		@param frames The number of frames to decode.
		@param format The output format (`S16` or `F32`).
		@return A `Bytes` object containing decoded PCM audio data.
	**/
	public function decode(frames:Int, format:AudioFormat = S16):Bytes
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			switch (format)
			{
				case S16:
					var bytes = Bytes.alloc(frames * channels * 2);
					var decoded = NativeCFFI.lime_audio_decoder_decode(handle, bytes, frames, cast format);
					return decoded;
				case F32:
					var bytes = Bytes.alloc(frames * channels * 4);
					var decoded = NativeCFFI.lime_audio_decoder_decode(handle, bytes, frames, cast format);
					return decoded;
			}
		}
		#end

		return null;
	}

	/**
		Resets the decoder position to the beginning of the stream.

		@return `true` if the operation succeeded, otherwise `false`.
	**/
	public function rewind():Bool
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			return NativeCFFI.lime_audio_decoder_rewind(handle);
		}
		#end

		return false;
	}

	/**
		Seeks to a specific frame position in the audio stream.

		@param frame The target position in audio frames (64-bit safe).
		@return `true` if seeking is supported and successful, otherwise `false`.
	**/
	public function seek(frame:Int64):Bool
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			return NativeCFFI.lime_audio_decoder_seek(handle, frame.low, frame.high);
		}
		#end

		return false;
	}

	/**
		Checks whether the audio stream supports seeking.

		@return `true` if seeking is supported.
	**/
	public function canSeek():Bool
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			return NativeCFFI.lime_audio_decoder_can_seek(handle);
		}
		#end

		return false;
	}

	/**
		Returns the current decoding position in frames.

		@return The current frame position as an `Int64`.
	**/
	public function tell():Int64
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			var pos = NativeCFFI.lime_audio_decoder_tell(handle);

			return Int64.make(pos.high, pos.low);
		}
		#end

		return 0;
	}

	/**
		Returns the total number of frames in the audio stream.

		@return The total frame count as an `Int64`.
	**/
	public function total():Int64
	{
		#if (lime_cffi && !macro)
		if (handle != null)
		{
			var total = NativeCFFI.lime_audio_decoder_total(handle);

			return Int64.make(total.high, total.low);
		}
		#end

		return 0;
	}
}
