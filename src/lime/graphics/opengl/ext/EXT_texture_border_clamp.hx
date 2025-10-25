package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture_border_clamp
{
	public var TEXTURE_BORDER_COLOR_EXT = 0x1004;
	public var CLAMP_TO_BORDER_EXT = 0x812D;

	@:noCompletion private function new() {}

	// void glTexParameterIivEXT (GLenum target, GLenum pname, const GLint *params)
	// void glTexParameterIuivEXT (GLenum target, GLenum pname, const GLuint *params)
	// void glGetTexParameterIivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetTexParameterIuivEXT (GLenum target, GLenum pname, GLuint *params)
	// void glSamplerParameterIivEXT (GLuint sampler, GLenum pname, const GLint *param)
	// void glSamplerParameterIuivEXT (GLuint sampler, GLenum pname, const GLuint *param)
	// void glGetSamplerParameterIivEXT (GLuint sampler, GLenum pname, GLint *params)
	// void glGetSamplerParameterIuivEXT (GLuint sampler, GLenum pname, GLuint *params)
}
