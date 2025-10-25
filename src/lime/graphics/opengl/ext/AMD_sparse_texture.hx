package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_sparse_texture
{
	public var VIRTUAL_PAGE_SIZE_X_AMD = 0x9195;
	public var VIRTUAL_PAGE_SIZE_Y_AMD = 0x9196;
	public var VIRTUAL_PAGE_SIZE_Z_AMD = 0x9197;
	public var MAX_SPARSE_TEXTURE_SIZE_AMD = 0x9198;
	public var MAX_SPARSE_3D_TEXTURE_SIZE_AMD = 0x9199;
	public var MAX_SPARSE_ARRAY_TEXTURE_LAYERS = 0x919A;
	public var MIN_SPARSE_LEVEL_AMD = 0x919B;
	public var MIN_LOD_WARNING_AMD = 0x919C;
	public var TEXTURE_STORAGE_SPARSE_BIT_AMD = 0x00000001;

	@:noCompletion private function new() {}

	// void glTexStorageSparseAMD (GLenum target, GLenum internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLsizei layers, GLbitfield flags)
	// void glTextureStorageSparseAMD (GLuint texture, GLenum target, GLenum internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLsizei layers, GLbitfield flags)
}
