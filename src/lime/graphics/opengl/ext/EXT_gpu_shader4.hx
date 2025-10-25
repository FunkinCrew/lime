package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_gpu_shader4
{
	public var SAMPLER_1D_ARRAY_EXT = 0x8DC0;
	public var SAMPLER_2D_ARRAY_EXT = 0x8DC1;
	public var SAMPLER_BUFFER_EXT = 0x8DC2;
	public var SAMPLER_1D_ARRAY_SHADOW_EXT = 0x8DC3;
	public var SAMPLER_2D_ARRAY_SHADOW_EXT = 0x8DC4;
	public var SAMPLER_CUBE_SHADOW_EXT = 0x8DC5;
	public var UNSIGNED_INT_VEC2_EXT = 0x8DC6;
	public var UNSIGNED_INT_VEC3_EXT = 0x8DC7;
	public var UNSIGNED_INT_VEC4_EXT = 0x8DC8;
	public var INT_SAMPLER_1D_EXT = 0x8DC9;
	public var INT_SAMPLER_2D_EXT = 0x8DCA;
	public var INT_SAMPLER_3D_EXT = 0x8DCB;
	public var INT_SAMPLER_CUBE_EXT = 0x8DCC;
	public var INT_SAMPLER_2D_RECT_EXT = 0x8DCD;
	public var INT_SAMPLER_1D_ARRAY_EXT = 0x8DCE;
	public var INT_SAMPLER_2D_ARRAY_EXT = 0x8DCF;
	public var INT_SAMPLER_BUFFER_EXT = 0x8DD0;
	public var UNSIGNED_INT_SAMPLER_1D_EXT = 0x8DD1;
	public var UNSIGNED_INT_SAMPLER_2D_EXT = 0x8DD2;
	public var UNSIGNED_INT_SAMPLER_3D_EXT = 0x8DD3;
	public var UNSIGNED_INT_SAMPLER_CUBE_EXT = 0x8DD4;
	public var UNSIGNED_INT_SAMPLER_2D_RECT_EXT = 0x8DD5;
	public var UNSIGNED_INT_SAMPLER_1D_ARRAY_EXT = 0x8DD6;
	public var UNSIGNED_INT_SAMPLER_2D_ARRAY_EXT = 0x8DD7;
	public var UNSIGNED_INT_SAMPLER_BUFFER_EXT = 0x8DD8;
	public var MIN_PROGRAM_TEXEL_OFFSET_EXT = 0x8904;
	public var MAX_PROGRAM_TEXEL_OFFSET_EXT = 0x8905;

	@:noCompletion private function new() {}

	// void glGetUniformuivEXT (GLuint program, GLint location, GLuint *params)
	// void glBindFragDataLocationEXT (GLuint program, GLuint color, const GLchar *name)
	// GLint glGetFragDataLocationEXT (GLuint program, const GLchar *name)
	// void glUniform1uiEXT (GLint location, GLuint v0)
	// void glUniform2uiEXT (GLint location, GLuint v0, GLuint v1)
	// void glUniform3uiEXT (GLint location, GLuint v0, GLuint v1, GLuint v2)
	// void glUniform4uiEXT (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3)
	// void glUniform1uivEXT (GLint location, GLsizei count, const GLuint *value)
	// void glUniform2uivEXT (GLint location, GLsizei count, const GLuint *value)
	// void glUniform3uivEXT (GLint location, GLsizei count, const GLuint *value)
	// void glUniform4uivEXT (GLint location, GLsizei count, const GLuint *value)
}
