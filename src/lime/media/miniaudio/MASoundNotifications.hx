package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import lime.system.CFFIPointer;

typedef MASoundNotifications =
{
	?onAtEnd:(pSound:MASound) -> Void,
	?onProcess:(pSound:MASound, pFrames:CFFIPointer, frameCount:Dynamic) -> Void
}
#end
