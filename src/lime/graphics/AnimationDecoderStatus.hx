package lime.graphics;

enum abstract AnimationDecoderStatus(Int)
{
	/** The decoder is invalid */
	var INVALID = -1;

	/** The decoder is ready to decode the next frame */
	var OK = 0;

	/** The decoder failed to decode a frame */
	var FAILED = 1;

	/** No more frames available */
	var COMPLETE = 2;
}
