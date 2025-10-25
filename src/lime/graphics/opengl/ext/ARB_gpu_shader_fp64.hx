package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_gpu_shader_fp64
{
	public var DOUBLE = 0x140A;
	public var DOUBLE_VEC2 = 0x8FFC;
	public var DOUBLE_VEC3 = 0x8FFD;
	public var DOUBLE_VEC4 = 0x8FFE;
	public var DOUBLE_MAT2 = 0x8F46;
	public var DOUBLE_MAT3 = 0x8F47;
	public var DOUBLE_MAT4 = 0x8F48;
	public var DOUBLE_MAT2x3 = 0x8F49;
	public var DOUBLE_MAT2x4 = 0x8F4A;
	public var DOUBLE_MAT3x2 = 0x8F4B;
	public var DOUBLE_MAT3x4 = 0x8F4C;
	public var DOUBLE_MAT4x2 = 0x8F4D;
	public var DOUBLE_MAT4x3 = 0x8F4E;

	@:noCompletion private function new() {}

	// void glUniform1d (GLint location, GLdouble x)
	// void glUniform2d (GLint location, GLdouble x, GLdouble y)
	// void glUniform3d (GLint location, GLdouble x, GLdouble y, GLdouble z)
	// void glUniform4d (GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glUniform1dv (GLint location, GLsizei count, const GLdouble *value)
	// void glUniform2dv (GLint location, GLsizei count, const GLdouble *value)
	// void glUniform3dv (GLint location, GLsizei count, const GLdouble *value)
	// void glUniform4dv (GLint location, GLsizei count, const GLdouble *value)
	// void glUniformMatrix2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix2x3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix2x4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix3x2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix3x4dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix4x2dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glUniformMatrix4x3dv (GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glGetUniformdv (GLuint program, GLint location, GLdouble *params)
}
