package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_texture_compression
{
	public var COMPRESSED_ALPHA_ARB = 0x84E9;
	public var COMPRESSED_LUMINANCE_ARB = 0x84EA;
	public var COMPRESSED_LUMINANCE_ALPHA_ARB = 0x84EB;
	public var COMPRESSED_INTENSITY_ARB = 0x84EC;
	public var COMPRESSED_RGB_ARB = 0x84ED;
	public var COMPRESSED_RGBA_ARB = 0x84EE;
	public var TEXTURE_COMPRESSION_HINT_ARB = 0x84EF;
	public var TEXTURE_COMPRESSED_IMAGE_SIZE_ARB = 0x86A0;
	public var TEXTURE_COMPRESSED_ARB = 0x86A1;
	public var NUM_COMPRESSED_TEXTURE_FORMATS_ARB = 0x86A2;
	public var COMPRESSED_TEXTURE_FORMATS_ARB = 0x86A3;

	@:noCompletion private function new() {}

	// void glCompressedTexImage3DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const void *data)
	// void glCompressedTexImage2DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const void *data)
	// void glCompressedTexImage1DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const void *data)
	// void glCompressedTexSubImage3DARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const void *data)
	// void glCompressedTexSubImage2DARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const void *data)
	// void glCompressedTexSubImage1DARB (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const void *data)
	// void glGetCompressedTexImageARB (GLenum target, GLint level, void *img)
}
