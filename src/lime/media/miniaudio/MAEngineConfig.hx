package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.DynamicAccess;

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
	public var processingSizeInFrames:Int;
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
		processingSizeInFrames = 0;
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
		final obj:DynamicAccess<Dynamic> = {};
		obj.set('pLog', pLog);
		obj.set('listenerCount', listenerCount);
		obj.set('channels', channels);
		obj.set('sampleRate', sampleRate);
		obj.set('processingSizeInFrames', processingSizeInFrames);
		obj.set('spatializationVolumeSmoothTimeInFrames', spatializationVolumeSmoothTimeInFrames);
		obj.set('spatializationVolumeSmoothTimeInMilliseconds', spatializationVolumeSmoothTimeInMilliseconds);
		obj.set('defaultVolumeSmoothTimeInFrames', defaultVolumeSmoothTimeInFrames);
		obj.set('preMixStackSizeInBytes', preMixStackSizeInBytes);
		obj.set('noAutoStart', noAutoStart);
		obj.set('noDevice', noDevice);
		obj.set('noClip', noClip);
		obj.set('onProcess', onProcess);
		return obj;
	}
}
#end
