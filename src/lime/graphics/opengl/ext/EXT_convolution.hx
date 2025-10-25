package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_convolution
{
	public var CONVOLUTION_1D_EXT = 0x8010;
	public var CONVOLUTION_2D_EXT = 0x8011;
	public var SEPARABLE_2D_EXT = 0x8012;
	public var CONVOLUTION_BORDER_MODE_EXT = 0x8013;
	public var CONVOLUTION_FILTER_SCALE_EXT = 0x8014;
	public var CONVOLUTION_FILTER_BIAS_EXT = 0x8015;
	public var REDUCE_EXT = 0x8016;
	public var CONVOLUTION_FORMAT_EXT = 0x8017;
	public var CONVOLUTION_WIDTH_EXT = 0x8018;
	public var CONVOLUTION_HEIGHT_EXT = 0x8019;
	public var MAX_CONVOLUTION_WIDTH_EXT = 0x801A;
	public var MAX_CONVOLUTION_HEIGHT_EXT = 0x801B;
	public var POST_CONVOLUTION_RED_SCALE_EXT = 0x801C;
	public var POST_CONVOLUTION_GREEN_SCALE_EXT = 0x801D;
	public var POST_CONVOLUTION_BLUE_SCALE_EXT = 0x801E;
	public var POST_CONVOLUTION_ALPHA_SCALE_EXT = 0x801F;
	public var POST_CONVOLUTION_RED_BIAS_EXT = 0x8020;
	public var POST_CONVOLUTION_GREEN_BIAS_EXT = 0x8021;
	public var POST_CONVOLUTION_BLUE_BIAS_EXT = 0x8022;
	public var POST_CONVOLUTION_ALPHA_BIAS_EXT = 0x8023;

	@:noCompletion private function new() {}

	// void glConvolutionFilter1DEXT (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const void *image)
	// void glConvolutionFilter2DEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const void *image)
	// void glConvolutionParameterfEXT (GLenum target, GLenum pname, GLfloat params)
	// void glConvolutionParameterfvEXT (GLenum target, GLenum pname, const GLfloat *params)
	// void glConvolutionParameteriEXT (GLenum target, GLenum pname, GLint params)
	// void glConvolutionParameterivEXT (GLenum target, GLenum pname, const GLint *params)
	// void glCopyConvolutionFilter1DEXT (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width)
	// void glCopyConvolutionFilter2DEXT (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height)
	// void glGetConvolutionFilterEXT (GLenum target, GLenum format, GLenum type, void *image)
	// void glGetConvolutionParameterfvEXT (GLenum target, GLenum pname, GLfloat *params)
	// void glGetConvolutionParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetSeparableFilterEXT (GLenum target, GLenum format, GLenum type, void *row, void *column, void *span)
	// void glSeparableFilter2DEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const void *row, const void *column)
}
