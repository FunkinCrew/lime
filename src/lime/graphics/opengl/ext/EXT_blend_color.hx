package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_blend_color
{
	public var CONSTANT_COLOR_EXT = 0x8001;
	public var ONE_MINUS_CONSTANT_COLOR_EXT = 0x8002;
	public var CONSTANT_ALPHA_EXT = 0x8003;
	public var ONE_MINUS_CONSTANT_ALPHA_EXT = 0x8004;
	public var BLEND_COLOR_EXT = 0x8005;

	@:noCompletion private function new() {}

	// void glBlendColorEXT (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
}
