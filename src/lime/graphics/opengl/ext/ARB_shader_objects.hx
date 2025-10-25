package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_shader_objects
{
	public var PROGRAM_OBJECT_ARB = 0x8B40;
	public var SHADER_OBJECT_ARB = 0x8B48;
	public var OBJECT_TYPE_ARB = 0x8B4E;
	public var OBJECT_SUBTYPE_ARB = 0x8B4F;
	public var FLOAT_VEC2_ARB = 0x8B50;
	public var FLOAT_VEC3_ARB = 0x8B51;
	public var FLOAT_VEC4_ARB = 0x8B52;
	public var INT_VEC2_ARB = 0x8B53;
	public var INT_VEC3_ARB = 0x8B54;
	public var INT_VEC4_ARB = 0x8B55;
	public var BOOL_ARB = 0x8B56;
	public var BOOL_VEC2_ARB = 0x8B57;
	public var BOOL_VEC3_ARB = 0x8B58;
	public var BOOL_VEC4_ARB = 0x8B59;
	public var FLOAT_MAT2_ARB = 0x8B5A;
	public var FLOAT_MAT3_ARB = 0x8B5B;
	public var FLOAT_MAT4_ARB = 0x8B5C;
	public var SAMPLER_1D_ARB = 0x8B5D;
	public var SAMPLER_2D_ARB = 0x8B5E;
	public var SAMPLER_3D_ARB = 0x8B5F;
	public var SAMPLER_CUBE_ARB = 0x8B60;
	public var SAMPLER_1D_SHADOW_ARB = 0x8B61;
	public var SAMPLER_2D_SHADOW_ARB = 0x8B62;
	public var SAMPLER_2D_RECT_ARB = 0x8B63;
	public var SAMPLER_2D_RECT_SHADOW_ARB = 0x8B64;
	public var OBJECT_DELETE_STATUS_ARB = 0x8B80;
	public var OBJECT_COMPILE_STATUS_ARB = 0x8B81;
	public var OBJECT_LINK_STATUS_ARB = 0x8B82;
	public var OBJECT_VALIDATE_STATUS_ARB = 0x8B83;
	public var OBJECT_INFO_LOG_LENGTH_ARB = 0x8B84;
	public var OBJECT_ATTACHED_OBJECTS_ARB = 0x8B85;
	public var OBJECT_ACTIVE_UNIFORMS_ARB = 0x8B86;
	public var OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB = 0x8B87;
	public var OBJECT_SHADER_SOURCE_LENGTH_ARB = 0x8B88;

	@:noCompletion private function new() {}

	// void glDeleteObjectARB (GLhandleARB obj)
	// GLhandleARB glGetHandleARB (GLenum pname)
	// void glDetachObjectARB (GLhandleARB containerObj, GLhandleARB attachedObj)
	// GLhandleARB glCreateShaderObjectARB (GLenum shaderType)
	// void glShaderSourceARB (GLhandleARB shaderObj, GLsizei count, const GLcharARB **string, const GLint *length)
	// void glCompileShaderARB (GLhandleARB shaderObj)
	// GLhandleARB glCreateProgramObjectARB ()
	// void glAttachObjectARB (GLhandleARB containerObj, GLhandleARB obj)
	// void glLinkProgramARB (GLhandleARB programObj)
	// void glUseProgramObjectARB (GLhandleARB programObj)
	// void glValidateProgramARB (GLhandleARB programObj)
	// void glUniform1fARB (GLint location, GLfloat v0)
	// void glUniform2fARB (GLint location, GLfloat v0, GLfloat v1)
	// void glUniform3fARB (GLint location, GLfloat v0, GLfloat v1, GLfloat v2)
	// void glUniform4fARB (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3)
	// void glUniform1iARB (GLint location, GLint v0)
	// void glUniform2iARB (GLint location, GLint v0, GLint v1)
	// void glUniform3iARB (GLint location, GLint v0, GLint v1, GLint v2)
	// void glUniform4iARB (GLint location, GLint v0, GLint v1, GLint v2, GLint v3)
	// void glUniform1fvARB (GLint location, GLsizei count, const GLfloat *value)
	// void glUniform2fvARB (GLint location, GLsizei count, const GLfloat *value)
	// void glUniform3fvARB (GLint location, GLsizei count, const GLfloat *value)
	// void glUniform4fvARB (GLint location, GLsizei count, const GLfloat *value)
	// void glUniform1ivARB (GLint location, GLsizei count, const GLint *value)
	// void glUniform2ivARB (GLint location, GLsizei count, const GLint *value)
	// void glUniform3ivARB (GLint location, GLsizei count, const GLint *value)
	// void glUniform4ivARB (GLint location, GLsizei count, const GLint *value)
	// void glUniformMatrix2fvARB (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix3fvARB (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glUniformMatrix4fvARB (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
	// void glGetObjectParameterfvARB (GLhandleARB obj, GLenum pname, GLfloat *params)
	// void glGetObjectParameterivARB (GLhandleARB obj, GLenum pname, GLint *params)
	// void glGetInfoLogARB (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog)
	// void glGetAttachedObjectsARB (GLhandleARB containerObj, GLsizei maxCount, GLsizei *count, GLhandleARB *obj)
	// GLint glGetUniformLocationARB (GLhandleARB programObj, const GLcharARB *name)
	// void glGetActiveUniformARB (GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name)
	// void glGetUniformfvARB (GLhandleARB programObj, GLint location, GLfloat *params)
	// void glGetUniformivARB (GLhandleARB programObj, GLint location, GLint *params)
	// void glGetShaderSourceARB (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *source)
}
