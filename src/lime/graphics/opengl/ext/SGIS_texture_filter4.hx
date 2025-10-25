package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_texture_filter4
{
	public var FILTER4_SGIS = 0x8146;
	public var TEXTURE_FILTER4_SIZE_SGIS = 0x8147;

	@:noCompletion private function new() {}

	// void glGetTexFilterFuncSGIS (GLenum target, GLenum filter, GLfloat *weights)
	// void glTexFilterFuncSGIS (GLenum target, GLenum filter, GLsizei n, const GLfloat *weights)
}
