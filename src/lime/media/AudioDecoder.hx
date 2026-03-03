package lime.media;

import haxe.Int64;
import haxe.io.Bytes;
import lime._internal.format.Base64;
import lime.utils.ArrayBuffer;
#if (lime_cffi && !macro)
#if lime_opus
import lime.media.decoders.OpusDecoder;
#end
#if lime_vorbis
import lime.media.decoders.VorbisDecoder;
#end
#if lime_drlibs
import lime.media.decoders.WaveDecoder;
import lime.media.decoders.MP3Decoder;
import lime.media.decoders.FLACDecoder;
#end
#end

@:access(lime.media.AudioBuffer)
#if hl
@:keep
#end
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

/**
	
**/
class AudioDecoder
{
	/**
		The number of bits per sample in the audio decoder.
	**/
	public var bitsPerSample:Int;

	/**
		The number of audio channels (e.g., 1 for mono, 2 for stereo).
	**/
	public var channels:Int;

	/**
		Read-only variable to check if the decoder has reached end of buffer/file.
	**/
	public var eof:Bool;

	/**
		The sample rate of the audio data, in Hz.
	**/
	public var sampleRate:Int;

	/**
		A variable if it declared it its disposed and not to use.
	**/
	public var disposed:Bool;

	@:noCompletion private var path:Null<String>;
	@:noCompletion private var bytes:Null<Bytes>;

	@:noCompletion private function new() {}

	/**
		Disposes of the resources used by this `AudioDecoder`, such as unloading any associated buffer or file.
	**/
	public function dispose():Void
	{
		eof = true;
		disposed = true;
		path = null;
		bytes = null;
	}

	/**
		Clones this 'AudioDecoder'.
	**/
	public function clone():AudioDecoder
	{
		return null;
	}

	/**
		Decodes to an audio data.

		@param buffer An 'ArrayBuffer' to pass the decoded data to.
		@param pos Offset in byte for the passed buffer.
		@param len Length in byte to read to the passed buffer.
		@param word What byte type to use to the passed buffer.
		@return The number of bytes filled/read into the buffer.
	**/
	public function decode(buffer:ArrayBuffer, pos:Int, len:Int, word:Int):Int
	{
		return 0;
	}

	/**
		Rewinds the decoder to the start of the buffer or file.
	**/
	public function rewind():Bool
	{
		return false;
	}

	/**
		Sets the sample (Hz) position for the decoder to read.
	**/
	public function seek(samples:Int64):Bool
	{
		return false;
	}

	/**
		Returns a boolean if this 'AudioDecoder' are able to use the 'seek' function.
	**/
	public function seekable():Bool
	{
		return false;
	}

	/**
		Returns the current sample (Hz) position.
	**/
	public function tell():Int64
	{
		return 0;
	}

	/**
		Returns the total of samples (Hz) for the decoder to read.
	**/
	public function total():Int64
	{
		return 0;
	}

	/**
		Creates an `AudioDecoder` from a Base64-encoded string.

		@param base64String The Base64-encoded audio data.
		@return An `AudioDecoder` instance.
	**/
	public static function fromBase64(base64String:String):AudioDecoder
	{
		if (base64String == null) return null;

		#if (lime_cffi && !macro)
		var idx = base64String.indexOf(",");
		var bytes:Bytes;
		if (idx == -1)
		{
			bytes = Base64.decode(base64String);
		}
		else
		{
			bytes = Base64.decode(base64String.substr(idx + 1));
		}

		return AudioDecoder.fromBytes(bytes);
		#else
		return null;
		#end
	}

	/**
		Creates an `AudioDecoder` from a `Bytes` object.

		@param bytes The `Bytes` object containing the encoded audio data.
		@return An `AudioDecoder` instance.
	**/
	public static function fromBytes(bytes:Bytes):AudioDecoder
	{
		if (bytes == null) return null;

		#if (lime_cffi && !macro)
		return switch (AudioBuffer.__getCodecFromBytes(bytes))
		{
			#if lime_opus
			case OPUS: OpusDecoder.fromBytes(bytes);
			#end
			#if lime_vorbis
			case VORBIS: VorbisDecoder.fromBytes(bytes);
			#end
			#if lime_drlibs
			case WAVE: WaveDecoder.fromBytes(bytes);
			case MPEG: MP3Decoder.fromBytes(bytes);
			case FLAC: FLACDecoder.fromBytes(bytes);
			#end
			default: null;
		}
		#else
		return null;
		#end
	}

	/**
		Creates an `AudioDecoder` from a file.

		@param path The file path to the audio asset file.
		@return An `AudioDecoder` instance.
	**/
	public static function fromFile(path:String):AudioDecoder
	{
		if (path == null) return null;

		#if (lime_cffi && !macro)
		var decoder:AudioDecoder;

		#if lime_opus
		decoder = OpusDecoder.fromFile(path);
		if (decoder != null) return decoder;
		#end

		#if lime_vorbis
		decoder = VorbisDecoder.fromFile(path);
		if (decoder != null) return decoder;
		#end

		#if lime_drlibs
		decoder = WaveDecoder.fromFile(path);
		if (decoder != null) return decoder;

		decoder = MP3Decoder.fromFile(path);
		if (decoder != null) return decoder;

		decoder = FLACDecoder.fromFile(path);
		if (decoder != null) return decoder;
		#end
		#end

		return null;
	}
}