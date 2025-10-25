package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_gpu_shader_int64
{
	public var INT64_NV = 0x140E;
	public var UNSIGNED_INT64_NV = 0x140F;
	public var INT8_NV = 0x8FE0;
	public var INT8_VEC2_NV = 0x8FE1;
	public var INT8_VEC3_NV = 0x8FE2;
	public var INT8_VEC4_NV = 0x8FE3;
	public var INT16_NV = 0x8FE4;
	public var INT16_VEC2_NV = 0x8FE5;
	public var INT16_VEC3_NV = 0x8FE6;
	public var INT16_VEC4_NV = 0x8FE7;
	public var INT64_VEC2_NV = 0x8FE9;
	public var INT64_VEC3_NV = 0x8FEA;
	public var INT64_VEC4_NV = 0x8FEB;
	public var UNSIGNED_INT8_NV = 0x8FEC;
	public var UNSIGNED_INT8_VEC2_NV = 0x8FED;
	public var UNSIGNED_INT8_VEC3_NV = 0x8FEE;
	public var UNSIGNED_INT8_VEC4_NV = 0x8FEF;
	public var UNSIGNED_INT16_NV = 0x8FF0;
	public var UNSIGNED_INT16_VEC2_NV = 0x8FF1;
	public var UNSIGNED_INT16_VEC3_NV = 0x8FF2;
	public var UNSIGNED_INT16_VEC4_NV = 0x8FF3;
	public var UNSIGNED_INT64_VEC2_NV = 0x8FF5;
	public var UNSIGNED_INT64_VEC3_NV = 0x8FF6;
	public var UNSIGNED_INT64_VEC4_NV = 0x8FF7;
	public var FLOAT16_NV = 0x8FF8;
	public var FLOAT16_VEC2_NV = 0x8FF9;
	public var FLOAT16_VEC3_NV = 0x8FFA;
	public var FLOAT16_VEC4_NV = 0x8FFB;

	@:noCompletion private function new() {}

	// void glUniform1i64NV (GLint location, GLint64EXT x)
	// void glUniform2i64NV (GLint location, GLint64EXT x, GLint64EXT y)
	// void glUniform3i64NV (GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z)
	// void glUniform4i64NV (GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z, GLint64EXT w)
	// void glUniform1i64vNV (GLint location, GLsizei count, const GLint64EXT *value)
	// void glUniform2i64vNV (GLint location, GLsizei count, const GLint64EXT *value)
	// void glUniform3i64vNV (GLint location, GLsizei count, const GLint64EXT *value)
	// void glUniform4i64vNV (GLint location, GLsizei count, const GLint64EXT *value)
	// void glUniform1ui64NV (GLint location, GLuint64EXT x)
	// void glUniform2ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y)
	// void glUniform3ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z)
	// void glUniform4ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z, GLuint64EXT w)
	// void glUniform1ui64vNV (GLint location, GLsizei count, const GLuint64EXT *value)
	// void glUniform2ui64vNV (GLint location, GLsizei count, const GLuint64EXT *value)
	// void glUniform3ui64vNV (GLint location, GLsizei count, const GLuint64EXT *value)
	// void glUniform4ui64vNV (GLint location, GLsizei count, const GLuint64EXT *value)
	// void glGetUniformi64vNV (GLuint program, GLint location, GLint64EXT *params)
	// void glGetUniformui64vNV (GLuint program, GLint location, GLuint64EXT *params)
}
