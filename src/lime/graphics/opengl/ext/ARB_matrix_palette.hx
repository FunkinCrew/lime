package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_matrix_palette
{
	public var MATRIX_PALETTE_ARB = 0x8840;
	public var MAX_MATRIX_PALETTE_STACK_DEPTH_ARB = 0x8841;
	public var MAX_PALETTE_MATRICES_ARB = 0x8842;
	public var CURRENT_PALETTE_MATRIX_ARB = 0x8843;
	public var MATRIX_INDEX_ARRAY_ARB = 0x8844;
	public var CURRENT_MATRIX_INDEX_ARB = 0x8845;
	public var MATRIX_INDEX_ARRAY_SIZE_ARB = 0x8846;
	public var MATRIX_INDEX_ARRAY_TYPE_ARB = 0x8847;
	public var MATRIX_INDEX_ARRAY_STRIDE_ARB = 0x8848;
	public var MATRIX_INDEX_ARRAY_POINTER_ARB = 0x8849;

	@:noCompletion private function new() {}

	// void glCurrentPaletteMatrixARB (GLint index)
	// void glMatrixIndexubvARB (GLint size, const GLubyte *indices)
	// void glMatrixIndexusvARB (GLint size, const GLushort *indices)
	// void glMatrixIndexuivARB (GLint size, const GLuint *indices)
	// void glMatrixIndexPointerARB (GLint size, GLenum type, GLsizei stride, const void *pointer)
}
