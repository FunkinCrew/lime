package lime.media;

import lime.app.Event;
import lime.media.openal.AL;
import lime.media.openal.ALSource;
import lime.math.Vector4;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
/**
	The `AudioSource` class provides a way to control audio playback in a Lime application. 
	It allows for playing, pausing, and stopping audio, as well as controlling various 
	audio properties such as gain, pitch, and looping.

	Depending on the platform, the audio backend may vary, but the API remains consistent.

	@see lime.media.AudioBuffer
**/
@:allow(lime.media.AudioFilter)
class AudioSource
{
	/**
		An event that is dispatched when this audio playback have completed or looped.
	**/
	public var onComplete = new Event<Void->Void>();
	
	/**
		The `AudioBuffer` associated with this `AudioSource`.
	**/
	public var buffer:AudioBuffer;

	/**
		The current playback position of the audio, in milliseconds.
	**/
	public var currentTime(get, set):Float;

	/**
		The gain (volume) of the audio. A value of `1.0` represents the default volume.
		Property is in a linear scale.
	**/
	public var gain(get, set):Float;

	/**
		The current latency of this 'AudioSource'.
	**/
	public var latency(get, never):Float;

	/**
		The length of the audio, in milliseconds.
		Setting this to 0 will set back to the original length.
	**/
	public var length(get, set):Float;

	/**
		In which audio playback time the audio will loop.
	**/
	public var loopTime(get, set):Float;

	/**
		The number of times the audio will loop. A value of `0` means the audio will not loop.
	**/
	public var loops(get, set):Int;

	/**
		The offset within the audio buffer to start playback, in milliseconds.
		NOTE: The original documentation said it is in samples, but its actually in milliseconds.
	**/
	public var offset:Float;

	/**
		The stereo pan of the audio source.
		Setting this will set the position back to default.
	**/
	public var pan(get, set):Float;

	/**
		The current peak or amplitude (signal level) of the channels seperated to elements in array,
		from 0 (silent) to 1 (full).
	**/
	public var peaks(get, never):Array<Float>;

	/**
		The pitch of the audio. A value of `1.0` represents the default pitch.
	**/
	public var pitch(get, set):Float;

	/**
		An property if this 'AudioSource' is playing.
	**/
	public var playing(get, never):Bool;

	/**
		The 3D position of the audio source, represented as a `Vector4`.
		Setting this will set the pan back to default.
	**/
	public var position(get, set):Vector4;

	@:noCompletion private var __backend:AudioSourceBackend;
	@:noCompletion private var __effects:Array<AudioEffect>;

	/**
		Creates a new `AudioSource` instance.
		@param buffer The `AudioBuffer` to associate with this `AudioSource`.
		@param offset The starting offset within the audio buffer, in samples.
		@param length The length of the audio to play, in milliseconds. If `null`, the full buffer is used.
		@param loops The number of times to loop the audio. `0` means no looping.
	**/
	public function new(buffer:AudioBuffer = null, offset:Float = 0, length:Null<Int> = null, loops:Int = 0)
	{
		__backend = new AudioSourceBackend(this);

		this.buffer = buffer;
		this.offset = offset;
		if (length != null && length != 0) this.length = length;
		this.loops = loops;

		if (buffer != null) __backend.load();
	}

	/**
		Releases any resources used by this `AudioSource`.
	**/
	public function dispose():Void
	{
		__backend.stop();
		__backend.unload();
		__backend.dispose();
	}

	/**
		Adds an audio effect to this `AudioSource`.
		Maximum effects is 6 per source.

		@param effect An `AudioEffect`.
		@return Indicates if it's able to append the effect or not.
	**/
	public function addEffect(effect:AudioEffect):Bool
	{
		if (__effects == null) __effects = [];

		var index = __effects.indexOf(effect);
		if (index == -1)
		{
			if (__effects.length > 6) return false;

			index = __effects.indexOf(null);
			if (index == -1)
			{
				index = __effects.length;
				__effects.push(effect);
			}
			else
			{
				__effects[index] = effect;
			}

			effect.__appliedSources.push(this);
			if (!effect.bypass) __backend.addEffect(index);
		}
		else if (!effect.bypass)
		{
			__backend.updateEffect(index);
		}

		return true;
	}

	/**
		Removes an audio effect from this `AudioSource`.

		@param effect An `AudioEffect`.
	**/
	public function removeEffect(effect:AudioEffect):Void
	{
		if (__effects != null)
		{
			var index = __effects.indexOf(effect);
			if (index != -1)
			{
				if (!effect.bypass) __backend.removeEffect(index);
				__effects[index] = null;
				//while (__effects[__effects.length - 1] == null) __effects.pop();

				effect.__appliedSources.remove(this);
				if (effect.autoDispose) effect.dispose();
			}
		}
	}

	/**
		Clears any existing audio effects added in this `AudioSource`.
	**/
	public function clearEffects():Void
	{
		if (__effects != null)
		{
			var index = __effects.length, effect:AudioEffect;
			while (index-- > 0)
			{
				effect = __effects[index];
				if (effect == null) continue;

				if (!effect.bypass) __backend.removeEffect(index);
				if (effect.autoDispose) effect.dispose();
			}

			__effects = null;
		}
	}

	/**
		Returns the audio effect stored at the specified index.

		@param index An index to the `AudioEffect`.
		@return The specified `AudioEffect` from the index.
	**/
	public function getEffectAt(index:Int):AudioEffect
	{
		return __effects[index];
	}

	/**
		Returns the index of an effect stored.

		@param effect An `AudioEffect`.
		@return The index stored for the desired audio effect in this `AudioSource`.
	**/
	public function getEffectIndex(effect:AudioEffect):Int
	{
		return __effects.indexOf(effect);
	}

	/**
		Gets the current waveform or time-domain data of values range from -1 to 1.
		`size` doesn't have to be power of 2, but still recommended to do.
		If `channel` are not passed or is -1, it will get down-mixed mono result.

		@param array A `Float32Array` to fill the signals with.
		@param size How much signals to copy to the array.
		@param channel The channel to copy from. If it's `-1` then it down-mixes stereo signals to mono.
		@param offset What offset in pcm frame should it start copying singals (In web this has no use).
		@return The number of pcm frames filled into the array.
	**/
	public function getFloatTimeDomainData(array:Float32Array, size:Int, channel:Int = -1, offset:Int = 0):Int
	{
		return __backend.getFloatTimeDomainData(array, size, channel, offset);
	}

	/**
		Gets the current waveform or time-domain data of values range from 0 to 127 and 128 to 256.
		The same purpose as `getTimeDomainData` but it's in UInt8 instead of Float32.
		Use this if you prefer performance but don't care about accuracy.

		@param array A `UInt8Array` to fill the signals with.
		@param size How much signals to copy to the array.
		@param channel The channel to copy from. If it's `-1` then it down-mixes stereo signals to mono.
		@param offset What offset in pcm frame should it start copying singals (In web this has no use).
		@return The number of pcm frames filled into the array.
	**/
	public function getByteTimeDomainData(array:UInt8Array, size:Int, channel:Int = -1, offset:Int = 0):Int
	{
		return __backend.getByteTimeDomainData(array, size, channel, offset);
	}

	/**
		Loads the buffer to this 'AudioSource'.
	**/
	public function load():Void
	{
		__backend.stop();
		__backend.unload();
		__backend.load();
	}

	/**
		Unloads the current loaded buffer from this 'AudioSource'.
	**/
	public function unload():Void
	{
		__backend.stop();
		__backend.unload();
	}

	/**
		Pauses audio playback.
	**/
	public function pause():Void
	{
		__backend.pause();
	}

	/**
		Starts or resumes audio playback.
	**/
	public function play():Void
	{
		__backend.play();
	}

	/**
		Prepare an audio playback on 'play()' to avoid stutters.
	**/
	public function prepare(time:Float):Void
	{
		__backend.prepare(time);
	}

	/**
		Stops audio playback and resets the playback position to the beginning.
	**/
	public function stop():Void
	{
		__backend.stop();
	}

	/**
		Pauses a list of audis at the same time.
	**/
	public static function pauseSources(sources:Array<AudioSource>):Void
	{
		AudioSourceBackend.pauseSources(sources);
	}

	/**
		Plays a list of audios at the same time.
	**/
	public static function playSources(sources:Array<AudioSource>):Void
	{
		AudioSourceBackend.playSources(sources);
	}

	/**
		Stops a list of audios at the same time.
	**/
	public static function stopSources(sources:Array<AudioSource>):Void
	{
		AudioSourceBackend.stopSources(sources);
	}

	@:noCompletion private inline function init():Void
	{
		__backend.load();
	}

	// Get & Set Methods
	@:noCompletion private inline function get_currentTime():Float
	{
		return __backend.getCurrentTime();
	}

	@:noCompletion private inline function set_currentTime(value:Float):Float
	{
		return __backend.setCurrentTime(value);
	}

	@:noCompletion private inline function get_gain():Float
	{
		return __backend.getGain();
	}

	@:noCompletion private inline function set_gain(value:Float):Float
	{
		return __backend.setGain(value);
	}

	@:noCompletion private inline function get_latency():Float
	{
		return __backend.getLatency();
	}

	@:noCompletion private inline function get_length():Float
	{
		return __backend.getLength();
	}

	@:noCompletion private inline function set_length(value:Float):Float
	{
		return __backend.setLength(value);
	}

	@:noCompletion private inline function get_loopTime():Float
	{
		return __backend.getLoopTime();
	}

	@:noCompletion private inline function set_loopTime(value:Float):Float
	{
		return __backend.setLoopTime(value);
	}

	@:noCompletion private inline function get_loops():Int
	{
		return __backend.getLoops();
	}

	@:noCompletion private inline function set_loops(value:Int):Int
	{
		return __backend.setLoops(value);
	}

	@:noCompletion private inline function get_pan():Float
	{
		return __backend.getPan();
	}

	@:noCompletion private inline function set_pan(value:Float):Float
	{
		return __backend.setPan(value);
	}

	@:noCompletion private inline function get_peaks():Array<Float>
	{
		return __backend.getPeaks(0);
	}

	@:noCompletion private inline function get_pitch():Float
	{
		return __backend.getPitch();
	}

	@:noCompletion private inline function set_pitch(value:Float):Float
	{
		return __backend.setPitch(value);
	}

	@:noCompletion private inline function get_playing():Bool
	{
		return __backend.getPlaying();
	}

	@:noCompletion private inline function get_position():Vector4
	{
		return __backend.getPosition();
	}

	@:noCompletion private inline function set_position(value:Vector4):Vector4
	{
		return __backend.setPosition(value);
	}
}

#if lime_openal
@:noCompletion typedef AudioSourceBackend = lime._internal.backend.native.NativeAudioSource;
#elseif (js && html5)
@:noCompletion typedef AudioSourceBackend = lime._internal.backend.html5.HTML5AudioSource;
#else
@:noCompletion typedef AudioSourceBackend = lime._internal.backend.flash.FlashAudioSource;
#end