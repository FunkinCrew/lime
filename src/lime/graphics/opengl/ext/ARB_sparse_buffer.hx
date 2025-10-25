package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_sparse_buffer
{
	public var SPARSE_STORAGE_BIT_ARB = 0x0400;
	public var SPARSE_BUFFER_PAGE_SIZE_ARB = 0x82F8;

	@:noCompletion private function new() {}

	// void glBufferPageCommitmentARB (GLenum target, GLintptr offset, GLsizeiptr size, GLboolean commit)
}
