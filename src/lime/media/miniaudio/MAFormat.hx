package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
enum abstract MAFormat(Int) from Int to Int from UInt to UInt
{
	var UNKNOWN = 0;
	var U8 = 1;
	var S16 = 2;
	var S24 = 3;
	var S32 = 4;
	var F32 = 5;
}
#end
