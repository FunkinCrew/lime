package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_clip_control
{
	public var LOWER_LEFT = 0x8CA1;
	public var UPPER_LEFT = 0x8CA2;
	public var NEGATIVE_ONE_TO_ONE = 0x935E;
	public var ZERO_TO_ONE = 0x935F;
	public var CLIP_ORIGIN = 0x935C;
	public var CLIP_DEPTH_MODE = 0x935D;

	@:noCompletion private function new() {}

	// void glClipControl (GLenum origin, GLenum depth)
}
