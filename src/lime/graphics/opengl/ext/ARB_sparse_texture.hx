package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_sparse_texture
{
	public var TEXTURE_SPARSE_ARB = 0x91A6;
	public var VIRTUAL_PAGE_SIZE_INDEX_ARB = 0x91A7;
	public var NUM_SPARSE_LEVELS_ARB = 0x91AA;
	public var NUM_VIRTUAL_PAGE_SIZES_ARB = 0x91A8;
	public var VIRTUAL_PAGE_SIZE_X_ARB = 0x9195;
	public var VIRTUAL_PAGE_SIZE_Y_ARB = 0x9196;
	public var VIRTUAL_PAGE_SIZE_Z_ARB = 0x9197;
	public var MAX_SPARSE_TEXTURE_SIZE_ARB = 0x9198;
	public var MAX_SPARSE_3D_TEXTURE_SIZE_ARB = 0x9199;
	public var MAX_SPARSE_ARRAY_TEXTURE_LAYERS_ARB = 0x919A;
	public var SPARSE_TEXTURE_FULL_ARRAY_CUBE_MIPMAPS_ARB = 0x91A9;

	@:noCompletion private function new() {}

	// void glTexPageCommitmentARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLboolean commit)
}
