package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
/** Stereo panner. */
enum abstract MAPanMode(Int) from Int to Int from UInt to UInt
{
	/** Does not blend one side with the other. Technically just a balance. Compatible with other popular audio engines and therefore the default. */
	var BALANCE = 0;

	/** A true pan. The sound from one side will "move" to the other side and blend with it. */
	var PAN = 1;
}
#end
