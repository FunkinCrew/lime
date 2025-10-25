package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_separate_shader_objects
{
	public var VERTEX_SHADER_BIT = 0x00000001;
	public var FRAGMENT_SHADER_BIT = 0x00000002;
	public var GEOMETRY_SHADER_BIT = 0x00000004;
	public var TESS_CONTROL_SHADER_BIT = 0x00000008;
	public var TESS_EVALUATION_SHADER_BIT = 0x00000010;
	public var ALL_SHADER_BITS = 0xFFFFFFFF;
	public var PROGRAM_SEPARABLE = 0x8258;
	public var ACTIVE_PROGRAM = 0x8259;
	public var PROGRAM_PIPELINE_BINDING = 0x825A;

	@:noCompletion private function new() {}

	// void glUseProgramStages (GLuint pipeline, GLbitfield stages, GLuint program)
	// void glActiveShaderProgram (GLuint pipeline, GLuint program)
	// GLuint glCreateShaderProgramv (GLenum type, GLsizei count, const GLchar *const*strings)
	// void glBindProgramPipeline (GLuint pipeline)
	// void glDeleteProgramPipelines (GLsizei n, const GLuint *pipelines)
	// void glGenProgramPipelines (GLsizei n, GLuint *pipelines)
	// GLboolean glIsProgramPipeline (GLuint pipeline)
	// void glGetProgramPipelineiv (GLuint pipeline, GLenum pname, GLint *params)
	// void glProgramParameteri (GLuint program, GLenum pname, GLint value)
	// void glProgramUniform1i (GLuint program, GLint location, GLint v0)
	// void glProgramUniform1iv (GLuint program, GLint location, GLsizei count, const GLint *value)
	// void glProgramUniform1f (GLuint program, GLint location, GLfloat v0)
	// void glProgramUniform1fv (GLuint program, GLint location, GLsizei count, const GLfloat *value)
	// void glProgramUniform1d (GLuint program, GLint location, GLdouble v0)
	// void glProgramUniform1dv (GLuint program, GLint location, GLsizei count, const GLdouble *value)
	// void glProgramUniform1ui (GLuint program, GLint location, GLuint v0)
	// void glProgramUniform1uiv (GLuint program, GLint location, GLsizei count, const GLuint *value)
	// void glProgramUniform2i (GLuint program, GLint location, GLint v0, GLint v1)
	// void glProgramUniform2iv (GLuint program, GLint location, GLsizei count, const GLint *value)
	// void glProgramUniform2f (GLuint program, GLint location, GLfloat v0, GLfloat v1)
	// void glProgramUniform2fv (GLuint program, GLint location, GLsizei count, const GLfloat *value)
	// void glProgramUniform2d (GLuint program, GLint location, GLdouble v0, GLdouble v1)
	// void glProgramUniform2dv (GLuint program, GLint location, GLsizei count, const GLdouble *value)
	// void glProgramUniform2ui (GLuint program, GLint location, GLuint v0, GLuint v1)
	// void glProgramUniform2uiv (GLuint program, GLint location, GLsizei count, const GLuint *value)
	// void glProgramUniform3i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2)
	// void glProgramUniform3iv (GLuint program, GLint location, GLsizei count, const GLint *value)
	// void glProgramUniform3f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2)
	// void glProgramUniform3fv (GLuint program, GLint location, GLsizei count, const GLfloat *value)
	// void glProgramUniform3d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2)
	// void glProgramUniform3dv (GLuint program, GLint location, GLsizei count, const GLdouble *value)
	// void glProgramUniform3ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2)
	// void glProgramUniform3uiv (GLuint program, GLint location, GLsizei count, const GLuint *value)
	// void glProgramUniform4i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3)
	// void glProgramUniform4iv (GLuint program, GLint location, GLsizei count, const GLint *value)
	// void glProgramUniform4f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3)
	// void glProgramUniform4fv (GLuint program, GLint location, GLsizei count, const GLfloat *value)
	// void glProgramUniform4d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2, GLdouble v3)
	// void glProgramUniform4dv (GLuint program, GLint location, GLsizei count, const GLdouble *value)
	// void glProgramUniform4ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3)
	// void glProgramUniform4uiv (GLuint program, GLint location, GLsizei count, const GLuint *value)
	// void glProgramUniformMatrix2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix2x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix3x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix2x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix4x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix3x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix4x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glProgramUniformMatrix2x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix3x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix2x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix4x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix3x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glProgramUniformMatrix4x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const GLdouble *value)
	// void glValidateProgramPipeline (GLuint pipeline)
	// void glGetProgramPipelineInfoLog (GLuint pipeline, GLsizei bufSize, GLsizei *length, GLchar *infoLog)
}
