package lime.media;

import haxe.Int64;
import haxe.crypto.Base64;
import haxe.io.Bytes;

import lime.app.Future;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.utils.Int32Array;
import lime.utils.Log;
import lime.utils.UInt8Array;
#if lime_howlerjs
import lime.media.howlerjs.Howl;
#elseif lime_miniaudio
import lime.media.miniaudio.MADataFormat;
import lime.media.miniaudio.MADecoder;
import lime.media.miniaudio.MADecoderConfig;
import lime.media.miniaudio.MAFormat;
import lime.media.miniaudio.MAHelpers;
import lime.system.ThreadPool;
import lime.system.WorkOutput;
#end

/**
	The `AudioBuffer` class represents a buffer of audio data that can be played back using an `AudioSource`.
	It supports a variety of audio formats and platforms, providing a consistent API for loading and managing audio data.

	Depending on the platform, the audio backend may differ, but the class provides a unified interface for accessing
	audio data, whether it's stored in memory, loaded from a file, or streamed.

	@see lime.media.AudioSource
**/
@:access(lime.utils.Assets)
class AudioBuffer
{
	/**
		The number of bits per sample in the audio data.
	**/
	#if lime_miniaudio
	public var bitsPerSample(get, never):Int;
	#else
	public var bitsPerSample:Int;
	#end

	/**
		The number of audio channels (e.g., 1 for mono, 2 for stereo).
	**/
	public var channels:Int;

	/**
		The sample rate of the audio data, in Hz.
	**/
	public var sampleRate:Int;

	#if lime_miniaudio
	/**
		The format of the audio data.
	**/
	public var format:MAFormat;
	#end

	/**
		The number of audio frames.
	**/
	public var frames:Int64;

	/**
		The raw audio data stored as a `ArrayBufferView`.
	**/
	public var data:ArrayBufferView;

	/**
		The source of the audio data. This can be an `Howl` or `MADecoder`.
	**/
	public var src(get, set):Dynamic;

	#if lime_miniaudio
	@:noCompletion private static var __localThreadPool:ThreadPool;
	#end

	@:noCompletion private var __srcCustom:Dynamic;
	@:noCompletion private var __srcHowl:#if lime_howlerjs Howl #else Dynamic #end;
	@:noCompletion private var __srcHowlerDefaultSprite:String;
	@:noCompletion private var __srcMADecoder:#if lime_miniaudio MADecoder #else Dynamic #end;

	/**
		Creates a new, empty `AudioBuffer` instance.
	**/
	public function new() {}

	/**
		Disposes of the resources used by this `AudioBuffer`, such as unloading any associated audio data.
	**/
	public function dispose():Void
	{
		#if (js && html5 && lime_howlerjs)
		if (__srcHowl != null)
		{
			__srcHowl.unload();
			__srcHowl = null;
		}
		#elseif (lime_cffi && lime_miniaudio && !macro)
		if (__srcMADecoder != null)
		{
			__srcMADecoder.uninit();
			__srcMADecoder = null;
		}
		#end
	}

	/**
		Creates an `AudioBuffer` from a Base64-encoded string.

		@param base64String The Base64-encoded audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	public static function fromBase64(base64String:String, ?stream:Bool = false):AudioBuffer
	{
		if (base64String == null)
		{
			return null;
		}

		#if (js && html5 && lime_howlerjs)
		// if base64String doesn't contain codec data, add it.
		if (base64String.indexOf(",") == -1)
		{
			base64String = "data:" + __getCodec(Base64.decode(base64String)) + ";base64," + base64String;
		}

		var audioBuffer = new AudioBuffer();
		audioBuffer.__srcHowl = new Howl({src: [base64String], preload: true});
		return audioBuffer;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		// if base64String contains codec data, strip it then decode it.
		var base64StringSplit = base64String.split(",");
		var base64StringNoEncoding = base64StringSplit[base64StringSplit.length - 1];
		return __createFromMADecoder(MADecoder.init_memory(Base64.decode(base64StringNoEncoding), MADecoderConfig.init(S16, 0, 0)), stream);
		#else
		return null;
		#end
	}

	/**
		Creates an `AudioBuffer` from a `Bytes` object.

		@param bytes The `Bytes` object containing the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	public static function fromBytes(bytes:Bytes, ?stream:Bool = false):AudioBuffer
	{
		if (bytes == null)
		{
			return null;
		}

		#if (js && html5 && lime_howlerjs)
		var audioBuffer = new AudioBuffer();
		audioBuffer.__srcHowl = new Howl({src: ["data:" + __getCodec(bytes) + ";base64," + Base64.encode(bytes)], preload: true});
		return audioBuffer;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		return __createFromMADecoder(MADecoder.init_memory(bytes, MADecoderConfig.init(S16, 0, 0)), stream);
		#else
		return null;
		#end
	}

	/**
		Creates an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return An `AudioBuffer` instance with the audio data loaded from the file.
	**/
	public static function fromFile(path:String, ?stream:Bool = false):AudioBuffer
	{
		if (path == null)
		{
			return null;
		}

		#if (js && html5 && lime_howlerjs)
		var audioBuffer = new AudioBuffer();
		audioBuffer.__srcHowl = new Howl({src: [path], preload: false});
		return audioBuffer;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		return __createFromMADecoder(MADecoder.init_file(path, MADecoderConfig.init(S16, 0, 0)), stream);
		#else
		return null;
		#end
	}

	/**
		Asynchronously loads an `AudioBuffer` from a `Bytes` object.

		@param bytes The `Bytes` object containing the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromBytes(bytes:Bytes, ?stream:Bool = false):Future<AudioBuffer>
	{
		if (bytes == null)
		{
			return Future.withValue(null);
		}

		#if (js && html5 && lime_howlerjs)
		var promise = new lime.app.Promise<AudioBuffer>();

		var audioBuffer = new AudioBuffer();

		audioBuffer.__srcHowl = new Howl({src: ["data:" + __getCodec(bytes) + ";base64," + Base64.encode(bytes)], preload: false});

		if (audioBuffer.__srcHowl != null)
		{
			audioBuffer.__srcHowl.on("load", function()
			{
				promise.complete(audioBuffer);
			});

			audioBuffer.__srcHowl.on("loaderror", function(id, msg)
			{
				promise.error(msg);
			});

			audioBuffer.__srcHowl.load();
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		if (__localThreadPool == null)
		{
			__localThreadPool = new ThreadPool(0, 2);
			__localThreadPool.onComplete.add(localThreadPool_onComplete);
			__localThreadPool.onError.add(localThreadPool_onError);
		}

		var promise = new lime.app.Promise<AudioBuffer>();

		__localThreadPool.run(localThreadPool_doWork, {promise: promise, bytes: bytes, stream: stream});

		return promise.future;
		#else
		return Future.withValue(null);
		#end
	}

	/**
		Asynchronously loads an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@param stream Whether to use streaming instead of directly decoding all the audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromFile(path:String, ?stream:Bool = false):Future<AudioBuffer>
	{
		if (path == null)
		{
			return Future.withValue(null);
		}

		#if (js && html5 && lime_howlerjs)
		var promise = new lime.app.Promise<AudioBuffer>();

		var audioBuffer = AudioBuffer.fromFile(path);

		if (audioBuffer != null)
		{
			audioBuffer.__srcHowl.on("load", function()
			{
				promise.complete(audioBuffer);
			});

			audioBuffer.__srcHowl.on("loaderror", function(id, msg)
			{
				promise.error(msg);
			});

			audioBuffer.__srcHowl.load();
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		if (__localThreadPool == null)
		{
			__localThreadPool = new ThreadPool(0, 2);
			__localThreadPool.onComplete.add(localThreadPool_onComplete);
			__localThreadPool.onError.add(localThreadPool_onError);
		}

		var promise = new lime.app.Promise<AudioBuffer>();

		__localThreadPool.run(localThreadPool_doWork, {promise: promise, path: path, stream: stream});

		return promise.future;
		#else
		return Future.withValue(null);
		#end
	}

	@:noCompletion private static function __getCodec(bytes:Bytes):String
	{
		var signature:String = null;

		try
		{
			signature = bytes.getString(0, 4);
		}
		catch (e:Dynamic)
		{
			// if the bytes don't represent a valid UTF-8 string, getString()
			// may throw an exception. in that case, we expect to end up in
			// the default switch case below where it tries to detect MP3.
		}

		switch (signature)
		{
			case "OggS":
				try
				{
					if (bytes.length >= 36 && bytes.getString(28, 8) == "OpusHead")
					{
						return "audio/opus";
					}
				}
				catch (e:Dynamic) {}

				return "audio/ogg";
			case "fLaC":
				return "audio/flac";
			case "RIFF" if (bytes.getString(8, 4) == "WAVE"):
				return "audio/wav";
			default:
				switch ([bytes.get(0), bytes.get(1), bytes.get(2)])
				{
					case [73, 68, 51] | [255, 251, _] | [255, 250, _] | [255, 243, _]: return "audio/mp3";
					default:
				}
		}

		Log.error("Unsupported sound format");

		return null;
	}

	#if (lime_cffi && lime_miniaudio && !macro)
	@:noCompletion private static function __createFromMADecoder(decoder:MADecoder, stream:Bool):AudioBuffer
	{
		if (decoder != null)
		{
			if (stream)
			{
				var audioBuffer = new AudioBuffer();
				audioBuffer.__srcMADecoder = decoder;
				return audioBuffer;
			}
			else
			{
				var totalFrames:Int = Int64.toInt(decoder.get_length_in_pcm_frames());

				if (totalFrames > 0)
				{
					// When we are not streaming and we are required to put these frames inside an buffer,
					// We cant use Int64 as the buffer's length as per Haxe's limitation,
					// And even if youd wanna go beyound the limit, at that point youd use streaming which doesnt have this issue anyway.
					var dataFormat:MADataFormat = decoder.get_data_format();

					var bytesPerSample:Int = MAHelpers.get_bytes_per_sample(dataFormat.format);

					var dataBuffer:ArrayBufferView = null;

					switch (dataFormat.format)
					{
						case U8:
							dataBuffer = new UInt8Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case S16:
							dataBuffer = new Int16Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case S32:
							dataBuffer = new Int32Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						case F32:
							dataBuffer = new Float32Array(Bytes.alloc(totalFrames * dataFormat.channels * bytesPerSample));
						default:
							Log.error('Unsupported audio buffer format: ${MAHelpers.get_format_name(dataFormat.format)}');
					}

					if (dataBuffer != null)
					{
						if (decoder.read_pcm_frames(#if cpp cpp.Pointer.ofArray(dataBuffer.buffer.getData()) #else null #end, totalFrames) > 0)
						{
							decoder.uninit();
							decoder = null;

							var buffer = new AudioBuffer();
							buffer.sampleRate = dataFormat.sampleRate;
							buffer.channels = dataFormat.channels;
							buffer.format = dataFormat.format;
							buffer.frames = totalFrames;
							buffer.data = dataBuffer;
							return buffer;
						}
					}
				}
			}

			decoder.uninit();
			decoder = null;
		}

		return null;
	}

	@:noCompletion private static function localThreadPool_doWork(state:Dynamic, output:WorkOutput):Void
	{
		var decoder:MADecoder = null;

		if (state.path != null)
		{
			decoder = MADecoder.init_file(state.path, MADecoderConfig.init(S16, 0, 0));
		}
		else if (state.bytes != null)
		{
			decoder = MADecoder.init_memory(state.bytes, MADecoderConfig.init(S16, 0, 0));
		}

		if (decoder != null)
		{
			var audioBuffer:AudioBuffer = __createFromMADecoder(decoder, state.stream);

			if (audioBuffer != null)
			{
				output.sendComplete({
					state: state,
					audioBuffer: audioBuffer
				});

				return;
			}
		}

		output.sendError({
			state: state,
			message: "Cannot load file: " + state.path
		});
	}

	@:noCompletion private static function localThreadPool_onComplete(data:Dynamic):Void
	{
		data.state.promise.complete(data.audioBuffer);
	}

	@:noCompletion private static function localThreadPool_onError(data:Dynamic):Void
	{
		data.state.promise.error(data.message);
	}
	#end

	// Get & Set Methods
	#if lime_miniaudio
	@:noCompletion private function get_bitsPerSample():Int
	{
		return switch (format)
		{
			case U8: 8;
			case S16: 16;
			case S24: 24;
			case S32: 32;
			case F32: 32;
			default: 0;
		}
	}
	#end

	@:noCompletion private function get_src():Dynamic
	{
		#if (js && html5 && lime_howlerjs)
		return __srcHowl;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		return __srcMADecoder;
		#else
		return __srcCustom;
		#end
	}

	@:noCompletion private function set_src(value:Dynamic):Dynamic
	{
		#if (js && html5 && lime_howlerjs)
		return __srcHowl = value;
		#elseif (lime_cffi && lime_miniaudio && !macro)
		return __srcMADecoder = value;
		#else
		return __srcCustom = value;
		#end
	}
}
