package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_blend_func_extended
{
	public var SRC1_COLOR = 0x88F9;
	public var SRC1_ALPHA = 0x8589;
	public var ONE_MINUS_SRC1_COLOR = 0x88FA;
	public var ONE_MINUS_SRC1_ALPHA = 0x88FB;
	public var MAX_DUAL_SOURCE_DRAW_BUFFERS = 0x88FC;

	@:noCompletion private function new() {}

	// void glBindFragDataLocationIndexed (GLuint program, GLuint colorNumber, GLuint index, const GLchar *name)
	// GLint glGetFragDataIndex (GLuint program, const GLchar *name)
}
