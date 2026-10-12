package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
typedef MADataFormat =
{
	format:MAFormat,
	channels:Int,
	sampleRate:Int,
	channelMap:Array<MAChannel>
}
#end
