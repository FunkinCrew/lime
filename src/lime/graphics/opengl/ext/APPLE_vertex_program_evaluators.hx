package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_vertex_program_evaluators
{
	public var VERTEX_ATTRIB_MAP1_APPLE = 0x8A00;
	public var VERTEX_ATTRIB_MAP2_APPLE = 0x8A01;
	public var VERTEX_ATTRIB_MAP1_SIZE_APPLE = 0x8A02;
	public var VERTEX_ATTRIB_MAP1_COEFF_APPLE = 0x8A03;
	public var VERTEX_ATTRIB_MAP1_ORDER_APPLE = 0x8A04;
	public var VERTEX_ATTRIB_MAP1_DOMAIN_APPLE = 0x8A05;
	public var VERTEX_ATTRIB_MAP2_SIZE_APPLE = 0x8A06;
	public var VERTEX_ATTRIB_MAP2_COEFF_APPLE = 0x8A07;
	public var VERTEX_ATTRIB_MAP2_ORDER_APPLE = 0x8A08;
	public var VERTEX_ATTRIB_MAP2_DOMAIN_APPLE = 0x8A09;

	@:noCompletion private function new() {}

	// void glEnableVertexAttribAPPLE (GLuint index, GLenum pname)
	// void glDisableVertexAttribAPPLE (GLuint index, GLenum pname)
	// GLboolean glIsVertexAttribEnabledAPPLE (GLuint index, GLenum pname)
	// void glMapVertexAttrib1dAPPLE (GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points)
	// void glMapVertexAttrib1fAPPLE (GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points)
	// void glMapVertexAttrib2dAPPLE (GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points)
	// void glMapVertexAttrib2fAPPLE (GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points)
}
