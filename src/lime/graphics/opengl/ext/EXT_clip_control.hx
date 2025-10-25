package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_clip_control
{
	public var LOWER_LEFT_EXT = 0x8CA1;
	public var UPPER_LEFT_EXT = 0x8CA2;
	public var NEGATIVE_ONE_TO_ONE_EXT = 0x935E;
	public var ZERO_TO_ONE_EXT = 0x935F;
	public var CLIP_ORIGIN_EXT = 0x935C;
	public var CLIP_DEPTH_MODE_EXT = 0x935D;

	@:noCompletion private function new() {}

	// void glClipControlEXT (GLenum origin, GLenum depth)
}
