package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_paletted_texture
{
	public var COLOR_INDEX1_EXT = 0x80E2;
	public var COLOR_INDEX2_EXT = 0x80E3;
	public var COLOR_INDEX4_EXT = 0x80E4;
	public var COLOR_INDEX8_EXT = 0x80E5;
	public var COLOR_INDEX12_EXT = 0x80E6;
	public var COLOR_INDEX16_EXT = 0x80E7;
	public var TEXTURE_INDEX_SIZE_EXT = 0x80ED;

	@:noCompletion private function new() {}

	// void glColorTableEXT (GLenum target, GLenum internalFormat, GLsizei width, GLenum format, GLenum type, const void *table)
	// void glGetColorTableEXT (GLenum target, GLenum format, GLenum type, void *data)
	// void glGetColorTableParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetColorTableParameterfvEXT (GLenum target, GLenum pname, GLfloat *params)
}
