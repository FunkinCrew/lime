package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_texture4D
{
	public var PACK_SKIP_VOLUMES_SGIS = 0x8130;
	public var PACK_IMAGE_DEPTH_SGIS = 0x8131;
	public var UNPACK_SKIP_VOLUMES_SGIS = 0x8132;
	public var UNPACK_IMAGE_DEPTH_SGIS = 0x8133;
	public var TEXTURE_4D_SGIS = 0x8134;
	public var PROXY_TEXTURE_4D_SGIS = 0x8135;
	public var TEXTURE_4DSIZE_SGIS = 0x8136;
	public var TEXTURE_WRAP_Q_SGIS = 0x8137;
	public var MAX_4D_TEXTURE_SIZE_SGIS = 0x8138;
	public var TEXTURE_4D_BINDING_SGIS = 0x814F;

	@:noCompletion private function new() {}

	// void glTexImage4DSGIS (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLint border, GLenum format, GLenum type, const void *pixels)
	// void glTexSubImage4DSGIS (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint woffset, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLenum format, GLenum type, const void *pixels)
}
