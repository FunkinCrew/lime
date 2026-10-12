package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
enum abstract MAPositioning(Int) from Int to Int from UInt to UInt
{
	var ABSOLUTE = 0;
	var RELATIVE = 1;
}
#end
