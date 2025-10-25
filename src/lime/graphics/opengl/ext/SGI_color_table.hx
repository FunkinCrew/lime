package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGI_color_table
{
	public var COLOR_TABLE_SGI = 0x80D0;
	public var POST_CONVOLUTION_COLOR_TABLE_SGI = 0x80D1;
	public var POST_COLOR_MATRIX_COLOR_TABLE_SGI = 0x80D2;
	public var PROXY_COLOR_TABLE_SGI = 0x80D3;
	public var PROXY_POST_CONVOLUTION_COLOR_TABLE_SGI = 0x80D4;
	public var PROXY_POST_COLOR_MATRIX_COLOR_TABLE_SGI = 0x80D5;
	public var COLOR_TABLE_SCALE_SGI = 0x80D6;
	public var COLOR_TABLE_BIAS_SGI = 0x80D7;
	public var COLOR_TABLE_FORMAT_SGI = 0x80D8;
	public var COLOR_TABLE_WIDTH_SGI = 0x80D9;
	public var COLOR_TABLE_RED_SIZE_SGI = 0x80DA;
	public var COLOR_TABLE_GREEN_SIZE_SGI = 0x80DB;
	public var COLOR_TABLE_BLUE_SIZE_SGI = 0x80DC;
	public var COLOR_TABLE_ALPHA_SIZE_SGI = 0x80DD;
	public var COLOR_TABLE_LUMINANCE_SIZE_SGI = 0x80DE;
	public var COLOR_TABLE_INTENSITY_SIZE_SGI = 0x80DF;

	@:noCompletion private function new() {}

	// void glColorTableSGI (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const void *table)
	// void glColorTableParameterfvSGI (GLenum target, GLenum pname, const GLfloat *params)
	// void glColorTableParameterivSGI (GLenum target, GLenum pname, const GLint *params)
	// void glCopyColorTableSGI (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width)
	// void glGetColorTableSGI (GLenum target, GLenum format, GLenum type, void *table)
	// void glGetColorTableParameterfvSGI (GLenum target, GLenum pname, GLfloat *params)
	// void glGetColorTableParameterivSGI (GLenum target, GLenum pname, GLint *params)
}
