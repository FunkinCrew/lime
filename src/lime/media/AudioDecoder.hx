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

	/**
		The audio data source format.
		
		- `UNKNOWN` = Unknown data format, recognized/decoded as `S16` anyway if loaded
		- `U8` = Unsigned 8 bit data format (512 possible values)
		- `S16` = Signed 16 bit data format (65536 possible values)
		- `S24` = Signed 24 bit data format (16777216 possible values, not recommended)
		- `S32` = Signed 32 bit data format (4294967296 possible values)
		- `F32` = Float 32 bit data format (2130706434+ possible values, can be outside of -1.0..1.0 range)
	**/
	public var dataFormat:AudioDataFormat = UNKNOWN;

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
				this.dataFormat = cast info.dataFormat;
			}
		}
		#end
	}

	/**
		Decodes a number of audio frames into raw PCM data.

		@param output A `Bytes` output to pass the decoded PCM audio data to.
		@param offset The offset in byte for the output.
		@param frames The number of frames to decode.
		@param format The output data format (Will use `dataFormat` if blank).
		@return The number of bytes filled/read into the output, if unable to decode to output data format, will return `-1`.
	**/
	public function decode(output:Bytes, offset:Int, frames:Int, ?format:AudioDataFormat):Int
	{
		if (format == null) format = dataFormat == UNKNOWN ? S16 : dataFormat;

		#if (lime_cffi && !macro)
		if (handle != null)
		{
			return NativeCFFI.lime_audio_decoder_decode(handle, output, offset, frames, cast format);
		}
		#end

		return 0;
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
