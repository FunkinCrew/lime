package lime.media;

import lime.app.Event;
import lime.math.Vector4;

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

	/**
		The `AudioBuffer` associated with this `AudioSource`.
	**/
	public var buffer:AudioBuffer;

	/**
		The length of the audio, in milliseconds.
	**/
	public var length(get, never):Float;

	/**
		The current playback position of the audio, in milliseconds.
	**/
	public var currentTime(get, set):Float;

	/**
		The gain (volume) of the audio. A value of `1` represents the default volume.
	**/
	public var gain(get, set):Float;

	/**
		The pitch of the audio. A value of `1` represents the default pitch.
	**/
	public var pitch(get, set):Float;

	/**
		The pan of the audio. A value of `0` represents the default pan.
	**/
	public var pan(get, set):Float;

	/**
		The number of times the audio will loop. A value of `0` means the audio will not loop.
	**/
	public var loops(get, set):Int;

	/**
		Whether the audio source is currently playing or not.
	**/
	public var playing(get, never):Bool;

	@:noCompletion private var __backend:AudioSourceBackend;

	/**
		Creates a new `AudioSource` instance.

		@param buffer The `AudioBuffer` to associate with this `AudioSource`.
	**/
	public function new(buffer:AudioBuffer = null)
	{
		__backend = new AudioSourceBackend(this);

		this.buffer = buffer;

		if (buffer != null && (buffer.src != null || (buffer.data != null && buffer.data.length > 0)))
		{
			__backend.init();
		}
	}

	/**
		Releases any resources used by this `AudioSource`.
	**/
	public function dispose():Void
	{
		__backend.dispose();
	}

	/**
		Initializes the resources used by this `AudioSource`.
	**/
	public function init():Void
	{
		__backend.init();
	}

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

	// Get & Set Methods
	@:noCompletion private function get_length():Float
	{
		return __backend.getLength();
	}

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

	@:noCompletion private function get_pitch():Float
	{
		return __backend.getPitch();
	}

	@:noCompletion private function set_pitch(value:Float):Float
	{
		return __backend.setPitch(value);
	}

	@:noCompletion private function get_pan():Float
	{
		return __backend.getPan();
	}

	@:noCompletion private function set_pan(value:Float):Float
	{
		return __backend.setPan(value);
	}

	@:noCompletion private function get_loops():Int
	{
		return __backend.getLoops();
	}

	@:noCompletion private function set_loops(value:Int):Int
	{
		return __backend.setLoops(value);
	}

	@:noCompletion private function get_playing():Bool
	{
		return __backend.getPlaying();
	}
}

#if (js && html5)
@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.html5.HTML5AudioSource;
#else
@:noCompletion private typedef AudioSourceBackend = lime._internal.backend.native.NativeAudioSource;
#end
