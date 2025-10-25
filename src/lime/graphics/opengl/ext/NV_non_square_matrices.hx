package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_non_square_matrices
{
	public var FLOAT_MAT2x3_NV = 0x8B65;
	public var FLOAT_MAT2x4_NV = 0x8B66;
	public var FLOAT_MAT3x2_NV = 0x8B67;
	public var FLOAT_MAT3x4_NV = 0x8B68;
	public var FLOAT_MAT4x2_NV = 0x8B69;
	public var FLOAT_MAT4x3_NV = 0x8B6A;

	@:noCompletion private function new() {}

	// void glUniformMatrix2x3fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix3x2fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix2x4fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix4x2fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix3x4fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix4x3fvNV (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
}
