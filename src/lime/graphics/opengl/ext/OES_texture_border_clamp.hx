package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_texture_border_clamp
{
	public var TEXTURE_BORDER_COLOR_OES = 0x1004;
	public var CLAMP_TO_BORDER_OES = 0x812D;

	@:noCompletion private function new() {}

	// void glTexParameterIivOES (GLenum target, GLenum pname, const GLint *params)
	// void glTexParameterIuivOES (GLenum target, GLenum pname, const GLuint *params)
	// void glGetTexParameterIivOES (GLenum target, GLenum pname, GLint *params)
	// void glGetTexParameterIuivOES (GLenum target, GLenum pname, GLuint *params)
	// void glSamplerParameterIivOES (GLuint sampler, GLenum pname, const GLint *param)
	// void glSamplerParameterIuivOES (GLuint sampler, GLenum pname, const GLuint *param)
	// void glGetSamplerParameterIivOES (GLuint sampler, GLenum pname, GLint *params)
	// void glGetSamplerParameterIuivOES (GLuint sampler, GLenum pname, GLuint *params)
}
