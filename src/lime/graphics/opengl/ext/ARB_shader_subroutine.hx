package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_shader_subroutine
{
	public var ACTIVE_SUBROUTINES = 0x8DE5;
	public var ACTIVE_SUBROUTINE_UNIFORMS = 0x8DE6;
	public var ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = 0x8E47;
	public var ACTIVE_SUBROUTINE_MAX_LENGTH = 0x8E48;
	public var ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = 0x8E49;
	public var MAX_SUBROUTINES = 0x8DE7;
	public var MAX_SUBROUTINE_UNIFORM_LOCATIONS = 0x8DE8;
	public var NUM_COMPATIBLE_SUBROUTINES = 0x8E4A;
	public var COMPATIBLE_SUBROUTINES = 0x8E4B;
	public var UNIFORM_SIZE = 0x8A38;
	public var UNIFORM_NAME_LENGTH = 0x8A39;

	@:noCompletion private function new() {}

	// GLint glGetSubroutineUniformLocation (GLuint program, GLenum shadertype, const GLchar *name)
	// GLuint glGetSubroutineIndex (GLuint program, GLenum shadertype, const GLchar *name)
	// void glGetActiveSubroutineUniformiv (GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint *values)
	// void glGetActiveSubroutineUniformName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufSize, GLsizei *length, GLchar *name)
	// void glGetActiveSubroutineName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufSize, GLsizei *length, GLchar *name)
	// void glUniformSubroutinesuiv (GLenum shadertype, GLsizei count, const GLuint *indices)
	// void glGetUniformSubroutineuiv (GLenum shadertype, GLint location, GLuint *params)
	// void glGetProgramStageiv (GLuint program, GLenum shadertype, GLenum pname, GLint *values)
}
