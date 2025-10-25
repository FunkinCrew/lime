package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_parameter_buffer_object
{
	public var MAX_PROGRAM_PARAMETER_BUFFER_BINDINGS_NV = 0x8DA0;
	public var MAX_PROGRAM_PARAMETER_BUFFER_SIZE_NV = 0x8DA1;
	public var VERTEX_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA2;
	public var GEOMETRY_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA3;
	public var FRAGMENT_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA4;

	@:noCompletion private function new() {}

	// void glProgramBufferParametersfvNV (GLenum target, GLuint bindingIndex, GLuint wordIndex, GLsizei count, const GLfloat *params)
	// void glProgramBufferParametersIivNV (GLenum target, GLuint bindingIndex, GLuint wordIndex, GLsizei count, const GLint *params)
	// void glProgramBufferParametersIuivNV (GLenum target, GLuint bindingIndex, GLuint wordIndex, GLsizei count, const GLuint *params)
}
