package lime.media;

import lime.app.Event;
import lime.media.openal.AL;
import lime.media.openal.ALSource;
import lime.math.Vector4;
import lime.utils.UInt8Array;

#if miniaudio
import lime._internal.backend.native.NativeMiniaudioAudioSource.MiniaudioAudioSourceReadbackData;
#end

import haxe.io.Bytes;

/**
	The `AudioSource` class provides a way to control audio playback in a Lime application.
	It allows for playing, pausing, and stopping audio, as well as controlling various
	audio properties such as gain, pitch, and looping.

	Depending on the platform, the audio backend may vary, but the API remains consistent.

	@see lime.media.AudioBuffer
**/
class AudioSource
{
	/**
		An event that is dispatched when the audio playback is complete.
	**/
	public var onComplete = new Event<Void->Void>();

	#if miniaudio
	/**
		The audio data, if passed as bytes in the constructor.
	**/
	public var data:Bytes = null;
	#else
	/**
		The `AudioBuffer` associated with this `AudioSource`.
	**/
	public var buffer:AudioBuffer;
	#end

	/**
		The current playback position of the audio, in milliseconds.
	**/
	public var currentTime(get, set):Float;

	/**
		The gain (volume) of the audio. A value of `1.0` represents the default volume.
	**/
	public var gain(get, set):Float;

	/**
		The length of the audio, in milliseconds.
	**/
	public var length(get, set):Float;

	/**
		The number of times the audio will loop. A value of `0` means the audio will not loop.
	**/
	public var loops(get, set):Int;

	/**
		The pitch of the audio. A value of `1.0` represents the default pitch.
	**/
	public var pitch(get, set):Float;

	/**
		The offset within the audio buffer to start playback, in milliseconds.
	**/
	public var offset:Float;

	/**
		The 3D position of the audio source, represented as a `Vector4`.
	**/
	public var position(get, set):Vector4;

	/**
		The estimated output latency, in miliseconds, for this `AudioSource`. If not possible to retrieve will return `0`.
	**/
	public var latency(get, never):Float;

	@:noCompletion private var __backend:AudioSourceBackend;

	#if miniaudio
	/**
		Creates a new `AudioSource` instance.
		@param bytes the bytes of an audio file.
			NOTE: messing with Bytes object after it is passed here, like resizing, pushing etc., may cause undefined behaviour because of reallocation, unless `stream` is set to `false`
		@param path The path to an audio file.
		@param stream wheather audio data should be streamed. takes effect only if initializing from bytes. creating an `AudioSource` with this set to `false` is EXPENSIVE, use only if you need readback.
		@param offset The starting offset within the audio buffer, in milliseconds.
		@param length The length of the audio to play, in milliseconds. If `null`, the whole audio data is used.
		@param loops The number of times to loop the audio. `0` means no looping.
	**/
	public function new(?bytes:Bytes, ?path:String, stream:Bool = true, offset:Float = 0, length:Null<Int> = null, loops:Int = 0)
	{
		this.offset = offset;

		__backend = new AudioSourceBackend(this, stream);

		if (bytes != null) {
			data = bytes;
			initFromBytes();
			if (!stream) data = null; // drop the reference after storing the decoded pcm in cpp, so that the GC can free this
		} else if (path != null) {
			initFromFile(path);
		} else {
			lime.utils.Log.error("AudioSource's both *bytes* and *path* arguments were not provided, this will most likely result in a crash");
		}

		if (length != null && length != 0)
		{
			this.length = length;
		}

		this.loops = loops;
	}
	#else
	/**
		Creates a new `AudioSource` instance.
		@param buffer The `AudioBuffer` to associate with this `AudioSource`.
		@param offset The starting offset within the audio buffer, in milliseconds.
		@param length The length of the audio to play, in milliseconds. If `null`, the full buffer is used.
		@param loops The number of times to loop the audio. `0` means no looping.
	**/
	public function new(buffer:AudioBuffer = null, offset:Float = 0, length:Null<Int> = null, loops:Int = 0)
	{
		this.buffer = buffer;
		this.offset = offset;

		__backend = new AudioSourceBackend(this);

		if (length != null && length != 0)
		{
			this.length = length;
		}

		this.loops = loops;

		if (buffer != null)
		{
			init();
		}
	}
	#end

	/**
		Releases any resources used by this `AudioSource`.
	**/
	public function dispose():Void
	{
		__backend.dispose();
	}

	#if miniaudio
	@:noCompletion private function initFromBytes():Void
	{
		__backend.initFromBytes();
	}

	@:noCompletion private function initFromFile(path:String):Void
	{
		__backend.initFromFile(path);
	}
	#else
	@:noCompletion private function init():Void
	{
		__backend.init();
	}
	#end

	/**
		Starts or resumes audio playback.
	**/
	public function play():Void
	{
		__backend.play();
	}

	/**
		Pauses audio playback.
	**/
	public function pause():Void
	{
		__backend.pause();
	}

	/**
		Stops audio playback and resets the playback position to the beginning.
	**/
	public function stop():Void
	{
		__backend.stop();
	}

	#if miniaudio
	/**
		Reads back pcm frames from the source.
		note that streaming must have been turned off and the `AudioSource` must have been created from bytes in order for this to work.
	**/
	public function readbackPcm():MiniaudioAudioSourceReadbackData
	{
		return __backend.readbackPcm();
	}
	#end

	// Get & Set Methods
	@:noCompletion private function get_currentTime():Float
	{
		return __backend.getCurrentTime();
	}

	@:noCompletion private function set_currentTime(value:Float):Float
	{
		return __backend.setCurrentTime(value);
	}

	@:noCompletion private function get_gain():Float
	{
		return __backend.getGain();
	}

	@:noCompletion private function set_gain(value:Float):Float
	{
		return __backend.setGain(value);
	}

	@:noCompletion private function get_length():Float
	{
		return __backend.getLength();
	}

	@:noCompletion private function set_length(value:Float):Float
	{
		return __backend.setLength(value);
	}

	@:noCompletion private function get_loops():Int
	{
		return __backend.getLoops();
	}

	@:noCompletion private function set_loops(value:Int):Int
	{
		return __backend.setLoops(value);
	}

	@:noCompletion private function get_pitch():Float
	{
		return __backend.getPitch();
	}

	@:noCompletion private function set_pitch(value:Float):Float
	{
		return __backend.setPitch(value);
	}

	@:noCompletion private function get_position():Vector4
	{
		return __backend.getPosition();
	}

	@:noCompletion private function set_position(value:Vector4):Vector4
	{
		return __backend.setPosition(value);
	}

	@:noCompletion private function get_latency():Float
	{
		return __backend.getLatency();
	}
}

#if (js && html5)
@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.html5.HTML5AudioSource;
#elseif miniaudio
@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.native.NativeMiniaudioAudioSource;
#elseif lime_openal
@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.native.NativeOpenALAudioSource;
#end
