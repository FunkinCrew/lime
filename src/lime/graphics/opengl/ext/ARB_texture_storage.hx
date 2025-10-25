package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_texture_storage
{
	public var TEXTURE_IMMUTABLE_FORMAT = 0x912F;

	@:noCompletion private function new() {}

	// void glTexStorage1D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width)
	// void glTexStorage2D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height)
	// void glTexStorage3D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth)
}
