package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
enum abstract MALogLevel(Int) from Int to Int from UInt to UInt
{
	var DEBUG = 4;
	var INFO = 3;
	var WARNING = 2;
	var ERROR = 1;
}
#end
