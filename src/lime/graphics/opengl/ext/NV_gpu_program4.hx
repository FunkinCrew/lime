package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_gpu_program4
{
	public var MIN_PROGRAM_TEXEL_OFFSET_NV = 0x8904;
	public var MAX_PROGRAM_TEXEL_OFFSET_NV = 0x8905;
	public var PROGRAM_ATTRIB_COMPONENTS_NV = 0x8906;
	public var PROGRAM_RESULT_COMPONENTS_NV = 0x8907;
	public var MAX_PROGRAM_ATTRIB_COMPONENTS_NV = 0x8908;
	public var MAX_PROGRAM_RESULT_COMPONENTS_NV = 0x8909;
	public var MAX_PROGRAM_GENERIC_ATTRIBS_NV = 0x8DA5;
	public var MAX_PROGRAM_GENERIC_RESULTS_NV = 0x8DA6;

	@:noCompletion private function new() {}

	// void glProgramLocalParameterI4iNV (GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w)
	// void glProgramLocalParameterI4ivNV (GLenum target, GLuint index, const GLint *params)
	// void glProgramLocalParametersI4ivNV (GLenum target, GLuint index, GLsizei count, const GLint *params)
	// void glProgramLocalParameterI4uiNV (GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w)
	// void glProgramLocalParameterI4uivNV (GLenum target, GLuint index, const GLuint *params)
	// void glProgramLocalParametersI4uivNV (GLenum target, GLuint index, GLsizei count, const GLuint *params)
	// void glProgramEnvParameterI4iNV (GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w)
	// void glProgramEnvParameterI4ivNV (GLenum target, GLuint index, const GLint *params)
	// void glProgramEnvParametersI4ivNV (GLenum target, GLuint index, GLsizei count, const GLint *params)
	// void glProgramEnvParameterI4uiNV (GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w)
	// void glProgramEnvParameterI4uivNV (GLenum target, GLuint index, const GLuint *params)
	// void glProgramEnvParametersI4uivNV (GLenum target, GLuint index, GLsizei count, const GLuint *params)
	// void glGetProgramLocalParameterIivNV (GLenum target, GLuint index, GLint *params)
	// void glGetProgramLocalParameterIuivNV (GLenum target, GLuint index, GLuint *params)
	// void glGetProgramEnvParameterIivNV (GLenum target, GLuint index, GLint *params)
	// void glGetProgramEnvParameterIuivNV (GLenum target, GLuint index, GLuint *params)
}
