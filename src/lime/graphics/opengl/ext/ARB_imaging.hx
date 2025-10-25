package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_imaging
{
	public var BLEND_COLOR = 0x8005;
	public var BLEND_EQUATION = 0x8009;
	public var CONSTANT_COLOR = 0x8001;
	public var ONE_MINUS_CONSTANT_COLOR = 0x8002;
	public var CONSTANT_ALPHA = 0x8003;
	public var ONE_MINUS_CONSTANT_ALPHA = 0x8004;
	public var FUNC_ADD = 0x8006;
	public var FUNC_REVERSE_SUBTRACT = 0x800B;
	public var FUNC_SUBTRACT = 0x800A;
	public var MIN = 0x8007;
	public var MAX = 0x8008;

	@:noCompletion private function new() {}

	// void glBlendColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
	// void glBlendEquation (GLenum mode)
}
