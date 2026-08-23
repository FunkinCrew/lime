package lime.graphics;

enum abstract AnimationDecoderStatus(Int)
{
	/* The decoder is invalid */
	var INVALID = -1;

	/* The decoder is ready to decode the next frame */
	var OK = 0;

	/* The decoder failed to decode a frame, call SDL_GetError() for more information. */
	var FAILED = 2;

	/* No more frames available */
	var COMPLETE = 3;
}
