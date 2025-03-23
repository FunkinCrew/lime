package lime.media.sdlsound;

#if (!lime_doc_gen || lime_sdlsound)
enum abstract SDLSoundFlags(Int) from Int to Int
{
	var NONE = 0;
	var CANSEEK = 1;
	var EOF = 1 << 29;
	var ERROR = 1 << 30;
	var EAGAIN = 1 << 31;
}
#end
