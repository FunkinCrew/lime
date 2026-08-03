package lime._internal.backend.native;

import lime.app.Application;
import lime.math.Vector4;
import lime.media.MiniaudioFormat;
import lime.media.AudioSource;
import lime.media.AudioManager;
import lime._internal.backend.native.NativeCFFI;

import haxe.io.Bytes;
import haxe.io.BytesData;

typedef MiniaudioAudioSourceReadbackData = {
	var format:MiniaudioFormat;
	var channels:Int;
	var sampleRate:Int;
	var pcmFrameCount:Int;
	final pcmFrames:BytesData;
}

#if (lime_cffi && lime_miniaudio && !macro)
@:include("hx/GC.h")
#end
@:access(lime._internal.backend.native.NativeCFFI)
class NativeMiniaudioAudioSource
{
    private var parent:AudioSource;
	private var soundIndex:Int;
	private var stream:Bool;
	private var completed:Bool;
	private var paused:Bool;

    public function new(parent:AudioSource, stream:Bool)
    {
        this.parent = parent;
		soundIndex = -1;
		this.stream = stream;
		completed = false;
		paused = true;
    }

	private function checkCallback(_):Void
	{
		if (!isPlaying() && !paused && !completed) {
			parent.onComplete.dispatch();
			completed = true;
		}
	}

    public function dispose():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_uninit(soundIndex);
		if (stream && parent.data != null) {
			untyped __cpp__("hx::GCRemoveRoot((hx::Object**)(&{0}.mPtr))", parent.data.getData());
			untyped __cpp__("hx::GCRemoveRoot((hx::Object**)(&{0}.mPtr))", parent.data);
		}
		#end
		if (Application.current.onUpdate.has(checkCallback)) {
			Application.current.onUpdate.remove(checkCallback);
		}
	}

	public function initFromFile(path:String)
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		soundIndex = NativeCFFI.lime_miniaudio_backend_sound_init_from_file(AudioManager.context.maEngine, parent.offset, cpp.ConstCharStar.fromString(path));
		#end
		if (soundIndex != -1 && !Application.current.onUpdate.has(checkCallback)) {
			Application.current.onUpdate.add(checkCallback);
		}
	}

	public function initFromBytes():Void
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		if (stream) {
			untyped __cpp__("hx::GCAddRoot((hx::Object**)(&{0}.mPtr))", parent.data); // not sure whether this one is required
			untyped __cpp__("hx::GCAddRoot((hx::Object**)(&{0}.mPtr))", parent.data.getData()); // since we only reference and not copy the memory to play from (unless we dont stream, in that case we only do for copying time), we need to tell GC not to mess up addresses
		}
        soundIndex = NativeCFFI.lime_miniaudio_backend_sound_init_from_bytes(AudioManager.context.maEngine, parent.offset, stream, parent.data.getData());
		#end
		if (soundIndex != -1 && !Application.current.onUpdate.has(checkCallback)) {
			Application.current.onUpdate.add(checkCallback);
		}
	}

	public function play():Void
	{
		completed = false; // restarting if completed
		paused = false;
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_start(soundIndex);
		#end
	}

	public function pause():Void
	{
		paused = true;
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_stop(soundIndex);
		#end
	}

	public function stop():Void
	{
		paused = true;
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_reset(soundIndex, parent.offset);
		#end
	}

	public function getCurrentTime():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_get_time(soundIndex, parent.offset);
		#else
		return 0;
		#end
	}

	public function setCurrentTime(value:Float):Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_time(soundIndex, parent.offset, value);
		#end
		return value;
	}

	public function getGain():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_get_volume(soundIndex);
		#else
		return 0;
		#end
	}

	public function setGain(value:Float):Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_volume(soundIndex, value);
		#end
		return value;
	}

	public function getLength():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_get_length(soundIndex, parent.offset);
		#else
		return 0;
		#end
	}

	public function setLength(value:Float):Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_length(soundIndex, parent.offset, value);
		#end
		return value;
	}

	public function getLoops():Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_get_loops(soundIndex);
		#else
		return 0;
		#end
	}

	public function setLoops(value:Int):Int
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_loops(soundIndex, value);
		#end
		return value;
	}

	public function getPitch():Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_get_pitch(soundIndex);
		#else
		return 0;
		#end
	}

	public function setPitch(value:Float):Float
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_pitch(soundIndex, value);
		#end
		return value;
	}

	public function getPosition():Vector4
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		var pos:Array<Float> = NativeCFFI.lime_miniaudio_backend_sound_get_position(soundIndex);
		return new Vector4(pos[0], pos[1], pos[2], 0.0);
		#else
		return new Vector4();
		#end
	}

	public function setPosition(value:Vector4):Vector4
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		NativeCFFI.lime_miniaudio_backend_sound_set_position(soundIndex, value.x, value.y, value.z);
		#end
		return value;
	}

	public function isPlaying():Bool
	{
		#if (lime_cffi && lime_miniaudio && !macro)
		return NativeCFFI.lime_miniaudio_backend_sound_is_playing(soundIndex);
		#else
		return 0;
		#end
	}

	public function readbackPcm():MiniaudioAudioSourceReadbackData
	{
		if (stream) {
			lime.utils.Log.error("ma_sound with index " + soundIndex + " is streamed and does not support readback");
			return null;
		}

		var cppReadbackData = {
			format: 0,
			channels: 0,
			sampleRate: 0,
			pcmFrameCount: 0,
			pcmFrames: null
		};
		#if (lime_cffi && lime_miniaudio && !macro)
		cppReadbackData = NativeCFFI.lime_miniaudio_backend_sound_readback_pcm(soundIndex);
		#end

		var readbackData:MiniaudioAudioSourceReadbackData = {
			format: cppReadbackData.format,
			channels: cppReadbackData.channels,
			sampleRate: cppReadbackData.sampleRate,
			pcmFrameCount: cppReadbackData.pcmFrameCount,
			pcmFrames: new BytesData()
		};

		var pcmFrameCountMultiplier = readbackData.format.getBytesPerFrame();

		#if (lime_cffi && lime_miniaudio && !macro)
		cpp.NativeArray.setUnmanagedData(readbackData.pcmFrames, cppReadbackData.pcmFrames, readbackData.pcmFrameCount * pcmFrameCountMultiplier);
		#end

		return readbackData;
	}

	public function getLatency():Float
	{
		return 0;
	}
}