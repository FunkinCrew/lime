package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
enum abstract MAAttenuationModel(Int) from Int to Int from UInt to UInt
{
	var NONE = 0;
	var INVERSE = 1;
	var LINEAR = 2;
	var EXPONENTIAL = 3;
}
#end
