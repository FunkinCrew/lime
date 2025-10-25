package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_blend_func_extended
{
	public var SRC1_COLOR_EXT = 0x88F9;
	public var SRC1_ALPHA_EXT = 0x8589;
	public var ONE_MINUS_SRC1_COLOR_EXT = 0x88FA;
	public var ONE_MINUS_SRC1_ALPHA_EXT = 0x88FB;
	public var SRC_ALPHA_SATURATE_EXT = 0x0308;
	public var LOCATION_INDEX_EXT = 0x930F;
	public var MAX_DUAL_SOURCE_DRAW_BUFFERS_EXT = 0x88FC;

	@:noCompletion private function new() {}

	// void glBindFragDataLocationIndexedEXT (GLuint program, GLuint colorNumber, GLuint index, const GLchar *name)
	// void glBindFragDataLocationEXT (GLuint program, GLuint color, const GLchar *name)
	// GLint glGetProgramResourceLocationIndexEXT (GLuint program, GLenum programInterface, const GLchar *name)
	// GLint glGetFragDataIndexEXT (GLuint program, const GLchar *name)
}
