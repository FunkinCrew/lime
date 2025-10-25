package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_sparse_texture
{
	public var TEXTURE_SPARSE_EXT = 0x91A6;
	public var VIRTUAL_PAGE_SIZE_INDEX_EXT = 0x91A7;
	public var NUM_SPARSE_LEVELS_EXT = 0x91AA;
	public var NUM_VIRTUAL_PAGE_SIZES_EXT = 0x91A8;
	public var VIRTUAL_PAGE_SIZE_X_EXT = 0x9195;
	public var VIRTUAL_PAGE_SIZE_Y_EXT = 0x9196;
	public var VIRTUAL_PAGE_SIZE_Z_EXT = 0x9197;
	public var TEXTURE_2D = 0x0DE1;
	public var TEXTURE_2D_ARRAY = 0x8C1A;
	public var TEXTURE_CUBE_MAP = 0x8513;
	public var TEXTURE_CUBE_MAP_ARRAY_OES = 0x9009;
	public var TEXTURE_3D = 0x806F;
	public var MAX_SPARSE_TEXTURE_SIZE_EXT = 0x9198;
	public var MAX_SPARSE_3D_TEXTURE_SIZE_EXT = 0x9199;
	public var MAX_SPARSE_ARRAY_TEXTURE_LAYERS_EXT = 0x919A;
	public var SPARSE_TEXTURE_FULL_ARRAY_CUBE_MIPMAPS_EXT = 0x91A9;

	@:noCompletion private function new() {}

	// void glTexPageCommitmentEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLboolean commit)
}
