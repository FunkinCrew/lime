package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime.system.CFFIPointer;

class MAEngineConfig
{
	public static inline function init():MAEngineConfig
	{
		return new MAEngineConfig();
	}

	public var pLog:MALog;
	public var listenerCount:Int;
	public var channels:Int;
	public var sampleRate:Int;
	public var periods:Int;
	public var periodSizeInFrames:Int;
	public var spatializationVolumeSmoothTimeInFrames:Int;
	public var spatializationVolumeSmoothTimeInMilliseconds:Int;
	public var defaultVolumeSmoothTimeInFrames:Int;
	public var preMixStackSizeInBytes:Int;
	public var noAutoStart:Bool;
	public var noDevice:Bool;
	public var noClip:Bool;
	public var onProcess:(pFramesOut:CFFIPointer, frameCount:Dynamic) -> Void;

	public function new():Void
	{
		pLog = null;
		listenerCount = 0;
		channels = 0;
		sampleRate = 0;
		periods = 0;
		periodSizeInFrames = 0;
		spatializationVolumeSmoothTimeInFrames = 0;
		spatializationVolumeSmoothTimeInMilliseconds = 0;
		defaultVolumeSmoothTimeInFrames = 0;
		preMixStackSizeInBytes = 0;
		noAutoStart = false;
		noDevice = false;
		noClip = false;
		onProcess = null;
	}

	public function toDynamicObject():Dynamic
	{
		return {
			pLog: pLog,
			listenerCount: listenerCount,
			channels: channels,
			sampleRate: sampleRate,
			periods: periods,
			periodSizeInFrames: periodSizeInFrames,
			spatializationVolumeSmoothTimeInFrames: spatializationVolumeSmoothTimeInFrames,
			spatializationVolumeSmoothTimeInMilliseconds: spatializationVolumeSmoothTimeInMilliseconds,
			defaultVolumeSmoothTimeInFrames: defaultVolumeSmoothTimeInFrames,
			preMixStackSizeInBytes: preMixStackSizeInBytes,
			noAutoStart: noAutoStart,
			noDevice: noDevice,
			noClip: noClip,
			onProcess: onProcess
		}
	}
}
#end
