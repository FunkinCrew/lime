package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_clear_texture
{
	public var CLEAR_TEXTURE = 0x9365;

	@:noCompletion private function new() {}

	// void glClearTexImage (GLuint texture, GLint level, GLenum format, GLenum type, const void *data)
	// void glClearTexSubImage (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const void *data)
}
