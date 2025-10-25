package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_viewport_array
{
	public var SCISSOR_BOX = 0x0C10;
	public var VIEWPORT = 0x0BA2;
	public var DEPTH_RANGE = 0x0B70;
	public var SCISSOR_TEST = 0x0C11;
	public var MAX_VIEWPORTS = 0x825B;
	public var VIEWPORT_SUBPIXEL_BITS = 0x825C;
	public var VIEWPORT_BOUNDS_RANGE = 0x825D;
	public var LAYER_PROVOKING_VERTEX = 0x825E;
	public var VIEWPORT_INDEX_PROVOKING_VERTEX = 0x825F;
	public var UNDEFINED_VERTEX = 0x8260;
	public var FIRST_VERTEX_CONVENTION = 0x8E4D;
	public var LAST_VERTEX_CONVENTION = 0x8E4E;
	public var PROVOKING_VERTEX = 0x8E4F;

	@:noCompletion private function new() {}

	// void glViewportArrayv (GLuint first, GLsizei count, const GLfloat *v)
	// void glViewportIndexedf (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h)
	// void glViewportIndexedfv (GLuint index, const GLfloat *v)
	// void glScissorArrayv (GLuint first, GLsizei count, const GLint *v)
	// void glScissorIndexed (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height)
	// void glScissorIndexedv (GLuint index, const GLint *v)
	// void glDepthRangeArrayv (GLuint first, GLsizei count, const GLdouble *v)
	// void glDepthRangeIndexed (GLuint index, GLdouble n, GLdouble f)
	// void glGetFloati_v (GLenum target, GLuint index, GLfloat *data)
	// void glGetDoublei_v (GLenum target, GLuint index, GLdouble *data)
}
