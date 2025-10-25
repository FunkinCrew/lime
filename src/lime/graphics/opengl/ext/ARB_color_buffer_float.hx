package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_color_buffer_float
{
	public var RGBA_FLOAT_MODE_ARB = 0x8820;
	public var CLAMP_VERTEX_COLOR_ARB = 0x891A;
	public var CLAMP_FRAGMENT_COLOR_ARB = 0x891B;
	public var CLAMP_READ_COLOR_ARB = 0x891C;
	public var FIXED_ONLY_ARB = 0x891D;

	@:noCompletion private function new() {}

	// void glClampColorARB (GLenum target, GLenum clamp)
}
