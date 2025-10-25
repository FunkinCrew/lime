package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_viewport_array
{
	public var MAX_VIEWPORTS_NV = 0x825B;
	public var VIEWPORT_SUBPIXEL_BITS_NV = 0x825C;
	public var VIEWPORT_BOUNDS_RANGE_NV = 0x825D;
	public var VIEWPORT_INDEX_PROVOKING_VERTEX_NV = 0x825F;
	public var SCISSOR_BOX = 0x0C10;
	public var VIEWPORT = 0x0BA2;
	public var DEPTH_RANGE = 0x0B70;
	public var SCISSOR_TEST = 0x0C11;

	@:noCompletion private function new() {}

	// void glViewportArrayvNV (GLuint first, GLsizei count, const GLfloat *v)
	// void glViewportIndexedfNV (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h)
	// void glViewportIndexedfvNV (GLuint index, const GLfloat *v)
	// void glScissorArrayvNV (GLuint first, GLsizei count, const GLint *v)
	// void glScissorIndexedNV (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height)
	// void glScissorIndexedvNV (GLuint index, const GLint *v)
	// void glDepthRangeArrayfvNV (GLuint first, GLsizei count, const GLfloat *v)
	// void glDepthRangeIndexedfNV (GLuint index, GLfloat n, GLfloat f)
	// void glGetFloati_vNV (GLenum target, GLuint index, GLfloat *data)
	// void glEnableiNV (GLenum target, GLuint index)
	// void glDisableiNV (GLenum target, GLuint index)
	// GLboolean glIsEnablediNV (GLenum target, GLuint index)
}
