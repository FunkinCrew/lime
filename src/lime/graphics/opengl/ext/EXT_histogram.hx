package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_histogram
{
	public var HISTOGRAM_EXT = 0x8024;
	public var PROXY_HISTOGRAM_EXT = 0x8025;
	public var HISTOGRAM_WIDTH_EXT = 0x8026;
	public var HISTOGRAM_FORMAT_EXT = 0x8027;
	public var HISTOGRAM_RED_SIZE_EXT = 0x8028;
	public var HISTOGRAM_GREEN_SIZE_EXT = 0x8029;
	public var HISTOGRAM_BLUE_SIZE_EXT = 0x802A;
	public var HISTOGRAM_ALPHA_SIZE_EXT = 0x802B;
	public var HISTOGRAM_LUMINANCE_SIZE_EXT = 0x802C;
	public var HISTOGRAM_SINK_EXT = 0x802D;
	public var MINMAX_EXT = 0x802E;
	public var MINMAX_FORMAT_EXT = 0x802F;
	public var MINMAX_SINK_EXT = 0x8030;
	public var TABLE_TOO_LARGE_EXT = 0x8031;

	@:noCompletion private function new() {}

	// void glGetHistogramEXT (GLenum target, GLboolean reset, GLenum format, GLenum type, void *values)
	// void glGetHistogramParameterfvEXT (GLenum target, GLenum pname, GLfloat *params)
	// void glGetHistogramParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetMinmaxEXT (GLenum target, GLboolean reset, GLenum format, GLenum type, void *values)
	// void glGetMinmaxParameterfvEXT (GLenum target, GLenum pname, GLfloat *params)
	// void glGetMinmaxParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// void glHistogramEXT (GLenum target, GLsizei width, GLenum internalformat, GLboolean sink)
	// void glMinmaxEXT (GLenum target, GLenum internalformat, GLboolean sink)
	// void glResetHistogramEXT (GLenum target)
	// void glResetMinmaxEXT (GLenum target)
}
