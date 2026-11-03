package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime.system.CFFIPointer;

class MASoundNotifications
{
	public var onAtEnd:(pSound:MASound) -> Void;
	public var onPreProcess:(pSound:MASound, pFrames:CFFIPointer, frameCount:Dynamic) -> Void;
	public var onProcess:(pSound:MASound, pFrames:CFFIPointer, frameCount:Dynamic) -> Void;

	public function new():Void {}
}
#end
