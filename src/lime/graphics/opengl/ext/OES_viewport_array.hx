package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_viewport_array
{
	public var SCISSOR_BOX = 0x0C10;
	public var VIEWPORT = 0x0BA2;
	public var DEPTH_RANGE = 0x0B70;
	public var SCISSOR_TEST = 0x0C11;
	public var MAX_VIEWPORTS_OES = 0x825B;
	public var VIEWPORT_SUBPIXEL_BITS_OES = 0x825C;
	public var VIEWPORT_BOUNDS_RANGE_OES = 0x825D;
	public var VIEWPORT_INDEX_PROVOKING_VERTEX_OES = 0x825F;

	@:noCompletion private function new() {}

	// void glViewportArrayvOES (GLuint first, GLsizei count, const GLfloat *v)
	// void glViewportIndexedfOES (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h)
	// void glViewportIndexedfvOES (GLuint index, const GLfloat *v)
	// void glScissorArrayvOES (GLuint first, GLsizei count, const GLint *v)
	// void glScissorIndexedOES (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height)
	// void glScissorIndexedvOES (GLuint index, const GLint *v)
	// void glDepthRangeArrayfvOES (GLuint first, GLsizei count, const GLfloat *v)
	// void glDepthRangeIndexedfOES (GLuint index, GLfloat n, GLfloat f)
	// void glGetFloati_vOES (GLenum target, GLuint index, GLfloat *data)
	// void glEnableiOES (GLenum target, GLuint index)
	// void glDisableiOES (GLenum target, GLuint index)
	// GLboolean glIsEnablediOES (GLenum target, GLuint index)
}
