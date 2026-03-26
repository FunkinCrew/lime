package lime.media;

import haxe.Int64;
import haxe.io.Path;
import haxe.io.Input;
import lime._internal.backend.native.NativeCFFI;
import lime._internal.format.Base64;
import lime.app.Future;
import lime.app.Promise;
import lime.media.openal.AL;
import lime.media.openal.ALBuffer;
import lime.media.vorbis.VorbisFile;
import lime.media.AudioManager;
import lime.net.HTTPRequest;
import lime.utils.ArrayBuffer;
import lime.utils.Bytes;
import lime.utils.Log;
import lime.utils.UInt8Array;
#if lime_vorbis
import lime.media.decoders.VorbisDecoder;
#end
#if lime_howlerjs
import lime.media.howlerjs.Howl;
#end
#if (js && html5)
import js.lib.Promise as JSPromise;
import js.html.audio.AudioBuffer as JSAudioBuffer;
#elseif flash
import flash.media.Sound;
import flash.net.URLRequest;
#end
#if sys
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
#end

@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.media.AudioManager)
@:access(lime.utils.Assets)
#if hl
@:keep
#end
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

/**
	The `AudioBuffer` class represents a buffer of audio data that can be played back using an `AudioSource`.
	It supports a variety of audio formats and platforms, providing a consistent API for loading and managing audio data.

	Depending on the platform, the audio backend may differ, but the class provides a unified interface for accessing
	audio data, whether it's stored in memory, loaded from a file, or streamed.

	@see lime.media.AudioSource
**/
class AudioBuffer
{
	/**
		The number of bits per sample in the audio data.
		NOTE: In native target, when decoded, the bitsPerSample cannot be higher than 16 bits per sample,
			because openal can only play 16 or 8 bits per sample.
	**/
	public var bitsPerSample:Int;

	/**
		The number of audio channels (e.g., 1 for mono, 2 for stereo).
	**/
	public var channels:Int;

	/**
		Native target only.
		The uncompressed audio data stored as a `UInt8Array`.
	**/
	public var data:UInt8Array;

	/**
		Native target only.
		The decoder for this audio buffer.
	**/
	public var decoder:AudioDecoder;

	/**
		The sample rate of the audio data, in Hz.
	**/
	public var sampleRate:Int;

	/**
		The source of the audio data. This can be an `js.html.audio.AudioBuffer`, `Sound`, `Howl`, or other platform-specific object.
	**/
	public var src(get, set):Dynamic;

	@:noCompletion private var __srcAudioBuffer:#if (js && html5) JSAudioBuffer #else Dynamic #end;
	@:noCompletion private var __srcBuffer:#if lime_openal ALBuffer #else Dynamic #end;
	@:noCompletion private var __srcCustom:Dynamic;
	@:noCompletion private var __srcHowl:#if lime_howlerjs Howl #else Dynamic #end;
	@:noCompletion private var __srcSound:#if flash Sound #else Dynamic #end;
	@:noCompletion private var __srcVorbisFile:#if lime_vorbis VorbisFile #else Dynamic #end;

	#if commonjs
	private static function __init__()
	{
		var p = untyped AudioBuffer.prototype;
		untyped Object.defineProperties(p,
			{
				"src": {get: p.get_src, set: p.set_src}
			});
	}
	#end

	/**
		Creates a new, empty `AudioBuffer` instance.
	**/
	public function new() {}

	/**
		Disposes of the resources used by this `AudioBuffer`, such as unloading any associated audio data.
	**/
	public function dispose():Void
	{
		#if (lime_cffi && !macro)
		if (decoder != null) decoder.dispose();
		decoder = null;
		#end
		#if (js && html5 && lime_howlerjs)
		if (__srcHowl != null) __srcHowl.unload();
		__srcHowl = null;
		#end
		#if lime_openal
		if (__srcBuffer != null) AL.deleteBuffer(__srcBuffer);
		__srcBuffer = null;
		#end
	}

	/**
		Loads the audio buffer from the resource.
	**/
	public function load()
	{
		#if (js && html5 && lime_howlerjs)
		if (__srcHowl == null || bitsPerSample > 0) return;
		loadAsync();
		#elseif (lime_cffi && !macro)
		if (decoder == null) return;

		// OpenAL can only play 8 or 16 bits per sample audio.
		var word = decoder.bitsPerSample > 16 ? 2 : decoder.bitsPerSample >> 3;

		bitsPerSample = word << 3;
		channels = decoder.channels;
		sampleRate = decoder.sampleRate;

		data = new UInt8Array(Int64.toInt(decoder.total() * channels * word));
		decoder.decode(data.buffer, 0, data.byteLength, word);
		#end
	}

	/**
		Loads asynchronously the audio buffer from the resource.

		@param onLoad The callback when its loaded.
	**/
	public function loadAsync(?onLoad:AudioBuffer->Void, ?onError:String->Void)
	{
		#if (js && html5 && lime_howlerjs)
		if (__srcHowl == null)
		{
			if (onError != null) onError("No Howl to load");
			else if (onLoad != null) onLoad(this);
			return;
		}
		else if (bitsPerSample > 0)
		{
			if (onLoad != null) onLoad(this);
			return;
		}

		inline function triggerOnLoad()
		{
			if (untyped __srcHowl._buffer) __srcAudioBuffer = untyped __srcHowl._buffer;
			if (__srcAudioBuffer != null)
			{
				channels = __srcAudioBuffer.numberOfChannels;
				sampleRate = Std.int(__srcAudioBuffer.sampleRate);
			}
			bitsPerSample = 32;

			if (onLoad != null) onLoad(this);
		}

		if (untyped __srcHowl._state == 'loaded')
		{
			triggerOnLoad();
		}
		else
		{
			__srcHowl.on("load", function() triggerOnLoad());
			__srcHowl.on("loaderror", function(id, msg)
			{
				if (onError != null) onError(msg);
				else if (onLoad != null) onLoad(this);
			});
			__srcHowl.load();
		}

		#elseif (lime_cffi && !macro)
		if (decoder == null) return;

		// OpenAL can only play 8 or 16 bits per sample audio.
		var word = decoder.bitsPerSample > 16 ? 2 : decoder.bitsPerSample >> 3;

		bitsPerSample = word << 3;
		channels = decoder.channels;
		sampleRate = decoder.sampleRate;

		data = new UInt8Array(Int64.toInt(decoder.total() * channels * word));
		new Future<AudioBuffer>(() -> {
			decoder.decode(data.buffer, 0, data.byteLength, word);
			return this;
		}, true).onComplete(onLoad);
		#end
	}

	/**
		Creates an `AudioBuffer` from a Base64-encoded string.

		@param base64String The Base64-encoded audio data.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@param howlHtml5 html5 only. Optional, should it load in html5 audio instead of howler's.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	public static function fromBase64(base64String:String, ?stream:Bool #if (js && html5 && lime_howlerjs), ?howlHtml5 = false #end):AudioBuffer
	{
		if (base64String == null) return null;

		#if (js && html5 && lime_howlerjs)
		// if base64String doesn't contain codec data, add it.
		if (base64String.indexOf(",") == -1)
		{
			final bytes = Base64.decode(base64String);
			final codec = __getCodecFromBytes(bytes);
			if (codec != null) base64String = "data:" + codec.toHTML5() + ";base64," + base64String;
		}

		var audioBuffer = new AudioBuffer();

		if (howlHtml5) stream = true;
		else if (stream) howlHtml5 = true;
		else if (stream == null) stream = false;

		audioBuffer.__srcHowl = new Howl({src: [base64String], html5: #if force_html5_audio true #else howlHtml5 #end, preload: !stream});
		audioBuffer.load();

		return audioBuffer;
		#elseif (lime_cffi && !macro)
		var decoder = AudioDecoder.fromBase64(base64String);

		if (decoder != null)
		{
			return AudioBuffer.fromDecoder(decoder, stream, true);
		}
		#end

		return null;
	}

	/**
		Creates an `AudioBuffer` from a `Bytes` object.

		@param bytes The `Bytes` object containing the audio data.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@param howlHtml5 html5 only. Optional, should it load in html5 audio instead of howler's.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	public static function fromBytes(bytes:Bytes, ?stream:Bool #if (js && html5 && lime_howlerjs), ?howlHtml5 = false #end):AudioBuffer
	{
		if (bytes == null) return null;

		#if (js && html5 && lime_howlerjs)
		var audioBuffer = new AudioBuffer();

		if (howlHtml5) stream = true;
		else if (stream) howlHtml5 = true;
		else if (stream == null) stream = false;

		audioBuffer.__srcHowl = new Howl({src: [bytes.getData()], html5: #if force_html5_audio true #else howlHtml5 #end, preload: !stream});
		audioBuffer.load();

		return audioBuffer;
		#elseif (lime_cffi && !macro)
		var decoder = AudioDecoder.fromBytes(bytes);

		if (decoder != null)
		{
			return AudioBuffer.fromDecoder(decoder, stream, true);
		}
		#end

		return null;
	}

	/**
		Native target only.
		Creates an 'AudioBuffer' from a 'AudioDecoder' object.

		@param audioDecoder The 'AudioDecoder' object.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@param autoDisposeDecoder Optional, should it disposes the decoder after this function.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	#if (lime_cffi && !macro)
	public static function fromDecoder(audioDecoder:AudioDecoder, stream:Bool = false, autoDisposeDecoder:Bool = false):AudioBuffer
	{
		var audioBuffer = new AudioBuffer();
		audioBuffer.decoder = audioDecoder;

		if (!stream || !audioDecoder.seekable())
		{
			audioBuffer.load();
			if (autoDisposeDecoder)
			{
				audioBuffer.decoder = null;
				audioDecoder.dispose();
			}
		}
		else
		{
			// OpenAL can only play 8 or 16 bits per sample audio.
			var word = audioDecoder.bitsPerSample > 16 ? 2 : audioDecoder.bitsPerSample >> 3;

			audioBuffer.bitsPerSample = word << 3;
			audioBuffer.channels = audioDecoder.channels;
			audioBuffer.sampleRate = audioDecoder.sampleRate;
		}

		return audioBuffer;
	}
	#else
	public static function fromDecoder(audioDecoder:Dynamic, stream:Bool = false, autoDisposeDecoder:Bool = false):AudioBuffer
	{
		return null;
	}
	#end

	/**
		Creates an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@param howlHtml5 html5 only. Optional, should it load in html5 audio instead of howler's.
		@return An `AudioBuffer` instance with the audio data loaded from the file.
	**/
	public static function fromFile(path:String, ?stream:Bool #if (js && html5 && lime_howlerjs), ?howlHtml5 = false #end):AudioBuffer
	{
		if (path == null) return null;

		#if (js && html5 && lime_howlerjs)
		var audioBuffer = new AudioBuffer();

		if (howlHtml5) stream = true;
		else if (stream) howlHtml5 = true;
		else if (stream == null) stream = false;

		audioBuffer.__srcHowl = new Howl({src: [path], html5: #if force_html5_audio true #else howlHtml5 #end, preload: !stream});
		audioBuffer.load();

		return audioBuffer;
		#elseif flash
		var audioBuffer = new AudioBuffer();
		audioBuffer.__srcSound = new Sound(new URLRequest(path));
		return audioBuffer;
		#elseif (lime_cffi && !macro)
		var decoder = AudioDecoder.fromFile(path);

		if (decoder != null)
		{
			return AudioBuffer.fromDecoder(decoder, stream, true);
		}
		#end

		return null;
	}

	/**
		Creates an `AudioBuffer` from an array of file paths.

		@param paths An array of file paths to search for audio data.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@param howlHtml5 html5 only. Optional, should it load in html5 audio instead of howler's.
		@return An `AudioBuffer` instance with the audio data loaded from the first valid file found.
	**/
	public static function fromFiles(paths:Array<String>, ?stream:Bool #if (js && html5 && lime_howlerjs), ?howlHtml5 = false #end):AudioBuffer
	{
		#if (js && html5 && lime_howlerjs)
		var audioBuffer = new AudioBuffer();

		if (howlHtml5) stream = true;
		else if (stream) howlHtml5 = true;
		else if (stream == null) stream = false;

		audioBuffer.__srcHowl = new Howl({src: paths, html5: #if force_html5_audio true #else howlHtml5 #end, preload: !stream});
		audioBuffer.load();

		return audioBuffer;
		#else
		var buffer = null;

		for (path in paths)
		{
			buffer = AudioBuffer.fromFile(path, stream);
			if (buffer != null) break;
		}

		return buffer;
		#end
	}

	/**
		Native target only.
		Creates an `AudioBuffer` from a `VorbisFile`.

		@param vorbisFile The `VorbisFile` object containing the audio data.
		@param stream Optional, should it return a streamable 'AudioBuffer' instead.
		@return An `AudioBuffer` instance with the decoded audio data.
	**/
	#if lime_vorbis
	public static function fromVorbisFile(vorbisFile:VorbisFile, ?stream:Bool):AudioBuffer
	{
		if (vorbisFile == null) return null;

		var audioDecoder = VorbisDecoder.fromVorbisFile(vorbisFile);
		var audioBuffer = AudioBuffer.fromDecoder(audioDecoder, stream);
		audioBuffer.__srcVorbisFile = vorbisFile;
		return audioBuffer;
	}
	#else
	public static function fromVorbisFile(vorbisFile:Dynamic, ?stream:Bool):AudioBuffer
	{
		return null;
	}
	#end

	/**
		Asynchronously loads an `AudioBuffer` from a file.

		@param path The file path to the audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromFile(path:String):Future<AudioBuffer>
	{
		#if (flash || (js && html5))
		var promise = new Promise<AudioBuffer>();

		var audioBuffer = AudioBuffer.fromFile(path);

		if (audioBuffer != null)
		{
			#if flash
			audioBuffer.__srcSound.addEventListener(flash.events.Event.COMPLETE, function(event)
			{
				promise.complete(audioBuffer);
			});

			audioBuffer.__srcSound.addEventListener(flash.events.ProgressEvent.PROGRESS, function(event)
			{
				promise.progress(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
			});

			audioBuffer.__srcSound.addEventListener(flash.events.IOErrorEvent.IO_ERROR, promise.error);
			#elseif (js && html5 && lime_howlerjs)
			audioBuffer.loadAsync(function(_)
			{
				promise.complete(audioBuffer);
			}, function(msg)
			{
				promise.error(msg);
			});
			#else
			promise.complete(audioBuffer);
			#end
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
		#elseif (lime_cffi && !macro)
		var decoder = AudioDecoder.fromFile(path);

		if (decoder != null)
		{
			return AudioBuffer.loadFromDecoder(decoder, true);
		}

		return cast Future.withError(null);
		#else
		return cast Future.withError(null);
		#end
	}

	/**
		Asynchronously loads an `AudioBuffer` from multiple files.

		@param paths An array of file paths to search for audio data.
		@return A `Future` that resolves to the loaded `AudioBuffer`.
	**/
	public static function loadFromFiles(paths:Array<String>):Future<AudioBuffer>
	{
		#if (js && html5 && lime_howlerjs)
		var promise = new Promise<AudioBuffer>();

		var audioBuffer = AudioBuffer.fromFiles(paths);

		if (audioBuffer != null)
		{
			audioBuffer.loadAsync(function(_)
			{
				promise.complete(audioBuffer);
			}, function(msg)
			{
				promise.error(msg);
			});
		}
		else
		{
			promise.error(null);
		}

		return promise.future;
		#elseif (lime_cffi && !macro)
		for (path in paths)
		{
			var decoder = AudioDecoder.fromFile(path);
			if (decoder != null)
			{
				return AudioBuffer.loadFromDecoder(decoder, true);
			}
		}

		return cast Future.withError(null);
		#else
		return cast Future.withError(null);
		#end
	}

	/**
		Native target only.
		Asynchronously loads an 'AudioBuffer' from 'AudioDecoder'.

		@param audioDecoder The 'AudioDecoder' object.
		@param autoDisposeDecoder Optional, should it disposes the decoder after this function.
		@return A 'Future' that resolves to the loaded 'AudioBuffer'.
	**/
	#if (lime_cffi && !macro)
	public static function loadFromDecoder(audioDecoder:AudioDecoder, autoDisposeDecoder = false):Future<AudioBuffer>
	{
		var promise = new Promise<AudioBuffer>();
		var audioBuffer = new AudioBuffer();
		audioBuffer.decoder = audioDecoder;
		audioBuffer.loadAsync((audioBuffer) ->
		{
			audioBuffer.decoder.dispose();
			audioBuffer.decoder = null;
			promise.complete(audioBuffer);
		});
		return promise.future;
	}
	#else
	public static function loadFromDecoder(audioDecoder:Dynamic, autoDisposeDecoder = false):Future<AudioBuffer>
	{
		return cast Future.withError(null);
	}
	#end

	/**
		Get the codec that is in the audio resource.

		@param resource Any data to interpret as audio data.
		@return AudioCodec
	**/
	public static function getCodec(resource:Dynamic):AudioCodec
	{
		if (resource is haxe.io.Bytes)
		{
			return __getCodecFromBytes(cast resource);
		}
		#if sys
		#if android // aassets
		else if (resource is String)
		{
			return __getCodecFromBytes(Bytes.fromFile(cast resource));
		}
		#else
		else if (resource is String)
		{
			return __getCodecFromInput(File.read(cast resource, true));
		}
		#end
		else if (resource is FileInput)
		{
			cast(resource, FileInput).seek(0, SeekBegin);
			return __getCodecFromInput(cast resource);
		}
		#end
		else if (resource is Input)
		{
			return __getCodecFromInput(cast resource);
		}
		return null;
	}

	@:noCompletion private static function __getALFormat(bitsPerSample:Int, channels:Int):Int
	{
		// 32 bits per sample enums doesnt seem to work...
		#if (lime_openal && !macro)
		if (channels > 2 && AudioManager.__moreFormatsSupported) {
			if (channels == 3) return bitsPerSample == 32 ? AL.FORMAT_REAR32 : (bitsPerSample == 16 ? AL.FORMAT_REAR16 : AL.FORMAT_REAR8);
			else if (channels == 4) return bitsPerSample == 32 ? AL.FORMAT_QUAD32 : (bitsPerSample == 16 ? AL.FORMAT_QUAD16 : AL.FORMAT_QUAD8);
			else if (channels == 6) return bitsPerSample == 32 ? AL.FORMAT_51CHN32 : (bitsPerSample == 16 ? AL.FORMAT_51CHN16 : AL.FORMAT_51CHN8);
			else if (channels == 7) return bitsPerSample == 32 ? AL.FORMAT_61CHN32 : (bitsPerSample == 16 ? AL.FORMAT_61CHN16 : AL.FORMAT_61CHN8);
			else if (channels == 8) return bitsPerSample == 32 ? AL.FORMAT_71CHN32 : (bitsPerSample == 16 ? AL.FORMAT_71CHN16 : AL.FORMAT_71CHN8);
			else return 0;
		}
		else if (bitsPerSample == 32) return channels == 2 ? AL.FORMAT_STEREO32 : channels == 1 ? AL.FORMAT_MONO32 : 0;
		else if (channels == 2) return bitsPerSample == 16 ? AL.FORMAT_STEREO16 : bitsPerSample == 8 ? AL.FORMAT_STEREO8 : 0;
		else if (channels == 1) return bitsPerSample == 16 ? AL.FORMAT_MONO16 : bitsPerSample == 8 ? AL.FORMAT_MONO8 : 0;
		#end
		return 0;
	}

	@:noCompletion private static function __getCodecFromBytes(bytes:Bytes):AudioCodec
	{
		try
		{
			var signature = bytes.getString(0, 4);

			switch (signature.substr(0, 3)) {
				case "ID3": return MPEG;
			}

			switch (signature) {
				case "OggS":
					var fmt = bytes.getString(28, 4);
					if (fmt == "Opus") return OPUS;// OpusHead
					else return VORBIS;
				case "fLaC": return FLAC;
				case "RIFF":
					var fmt = bytes.getString(8, 4);
					if (fmt == "WAVE") return WAVE;
			}
		}
		catch (e:Dynamic)
		{
			// if the bytes don't represent a valid UTF-8 string, getString()
			// may throw an exception. in that case, we expect to end up in
			// the default switch case below where it tries to detect MPEG.
		}

		if (bytes.get(0) == 255) {
			var b = bytes.get(1);
			if (b == 251 || b == 250 || b == 243) return MPEG;
		}

		return null;
	}

	@:noCompletion private static function __getCodecFromInput(input:Input):AudioCodec
	{
		var bytes = Bytes.alloc(4);
		input.readBytes(bytes, 0, 4);

		try
		{
			var signature = bytes.getString(0, 4);

			switch (signature.substr(0, 3)) {
				case "ID3": return MPEG;
			}

			switch (signature) {
				case "OggS":
					#if sys
					if (input is FileInput) cast(input, FileInput).seek(24, SeekCur);
					else
					#end for (i in 0...24) input.readByte();

					var fmt = input.readString(4);
					if (fmt == "Opus") return OPUS;// OpusHead
					else return VORBIS;
				case "fLaC": return FLAC;
				case "RIFF":
					#if sys
					if (input is FileInput) cast(input, FileInput).seek(4, SeekCur);
					else
					#end for (i in 0...4) input.readByte();

					var fmt = input.readString(4);
					if (fmt == "WAVE") return WAVE;
			}
		}
		catch (e:Dynamic)
		{
			// if the bytes don't represent a valid UTF-8 string, getString()
			// may throw an exception. in that case, we expect to end up in
			// the default switch case below where it tries to detect MPEG.
		}

		if (bytes.get(0) == 255) {
			var b = bytes.get(1);
			if (b == 251 || b == 250 || b == 243) return MPEG;
		}

		return null;
	}

	// Get & Set Methods
	@:noCompletion private function get_src():Dynamic
	{
		#if (js && html5)
		#if lime_howlerjs
		return __srcHowl;
		#else
		return __srcAudioBuffer;
		#end
		#elseif flash
		return __srcSound;
		#else
		return __srcCustom;
		#end
	}

	@:noCompletion private function set_src(value:Dynamic):Dynamic
	{
		#if (js && html5)
		#if lime_howlerjs
		return __srcHowl = value;
		#else
		return __srcAudioBuffer = value;
		#end
		#elseif flash
		return __srcSound = value;
		#else
		return __srcCustom = value;
		#end
	}
}
