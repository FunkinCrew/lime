package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_transpose_matrix
{
	public var TRANSPOSE_MODELVIEW_MATRIX_ARB = 0x84E3;
	public var TRANSPOSE_PROJECTION_MATRIX_ARB = 0x84E4;
	public var TRANSPOSE_TEXTURE_MATRIX_ARB = 0x84E5;
	public var TRANSPOSE_COLOR_MATRIX_ARB = 0x84E6;

	@:noCompletion private function new() {}

	// void glLoadTransposeMatrixfARB (const GLfloat *m)
	// void glLoadTransposeMatrixdARB (const GLdouble *m)
	// void glMultTransposeMatrixfARB (const GLfloat *m)
	// void glMultTransposeMatrixdARB (const GLdouble *m)
}
