package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_shader_buffer_load
{
	public var BUFFER_GPU_ADDRESS_NV = 0x8F1D;
	public var GPU_ADDRESS_NV = 0x8F34;
	public var MAX_SHADER_BUFFER_ADDRESS_NV = 0x8F35;

	@:noCompletion private function new() {}

	// void glMakeBufferResidentNV (GLenum target, GLenum access)
	// void glMakeBufferNonResidentNV (GLenum target)
	// GLboolean glIsBufferResidentNV (GLenum target)
	// void glMakeNamedBufferResidentNV (GLuint buffer, GLenum access)
	// void glMakeNamedBufferNonResidentNV (GLuint buffer)
	// GLboolean glIsNamedBufferResidentNV (GLuint buffer)
	// void glGetBufferParameterui64vNV (GLenum target, GLenum pname, GLuint64EXT *params)
	// void glGetNamedBufferParameterui64vNV (GLuint buffer, GLenum pname, GLuint64EXT *params)
	// void glGetIntegerui64vNV (GLenum value, GLuint64EXT *result)
	// void glUniformui64NV (GLint location, GLuint64EXT value)
	// void glUniformui64vNV (GLint location, GLsizei count, const GLuint64EXT *value)
	// void glGetUniformui64vNV (GLuint program, GLint location, GLuint64EXT *params)
	// void glProgramUniformui64NV (GLuint program, GLint location, GLuint64EXT value)
	// void glProgramUniformui64vNV (GLuint program, GLint location, GLsizei count, const GLuint64EXT *value)
}
