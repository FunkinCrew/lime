package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_shading_language_include
{
	public var SHADER_INCLUDE_ARB = 0x8DAE;
	public var NAMED_STRING_LENGTH_ARB = 0x8DE9;
	public var NAMED_STRING_TYPE_ARB = 0x8DEA;

	@:noCompletion private function new() {}

	// void glNamedStringARB (GLenum type, GLint namelen, const GLchar *name, GLint stringlen, const GLchar *string)
	// void glDeleteNamedStringARB (GLint namelen, const GLchar *name)
	// void glCompileShaderIncludeARB (GLuint shader, GLsizei count, const GLchar *const*path, const GLint *length)
	// GLboolean glIsNamedStringARB (GLint namelen, const GLchar *name)
	// void glGetNamedStringARB (GLint namelen, const GLchar *name, GLsizei bufSize, GLint *stringlen, GLchar *string)
	// void glGetNamedStringivARB (GLint namelen, const GLchar *name, GLenum pname, GLint *params)
}
