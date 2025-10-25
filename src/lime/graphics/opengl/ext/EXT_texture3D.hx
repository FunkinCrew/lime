package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture3D
{
	public var PACK_SKIP_IMAGES_EXT = 0x806B;
	public var PACK_IMAGE_HEIGHT_EXT = 0x806C;
	public var UNPACK_SKIP_IMAGES_EXT = 0x806D;
	public var UNPACK_IMAGE_HEIGHT_EXT = 0x806E;
	public var TEXTURE_3D_EXT = 0x806F;
	public var PROXY_TEXTURE_3D_EXT = 0x8070;
	public var TEXTURE_DEPTH_EXT = 0x8071;
	public var TEXTURE_WRAP_R_EXT = 0x8072;
	public var MAX_3D_TEXTURE_SIZE_EXT = 0x8073;

	@:noCompletion private function new() {}

	// void glTexImage3DEXT (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const void *pixels)
	// void glTexSubImage3DEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const void *pixels)
}
