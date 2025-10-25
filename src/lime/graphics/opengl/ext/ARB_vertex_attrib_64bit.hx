package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_attrib_64bit
{
	public var RGB32I = 0x8D83;
	public var DOUBLE_VEC2 = 0x8FFC;
	public var DOUBLE_VEC3 = 0x8FFD;
	public var DOUBLE_VEC4 = 0x8FFE;
	public var DOUBLE_MAT2 = 0x8F46;
	public var DOUBLE_MAT3 = 0x8F47;
	public var DOUBLE_MAT4 = 0x8F48;
	public var DOUBLE_MAT2x3 = 0x8F49;
	public var DOUBLE_MAT2x4 = 0x8F4A;
	public var DOUBLE_MAT3x2 = 0x8F4B;
	public var DOUBLE_MAT3x4 = 0x8F4C;
	public var DOUBLE_MAT4x2 = 0x8F4D;
	public var DOUBLE_MAT4x3 = 0x8F4E;

	@:noCompletion private function new() {}

	// void glVertexAttribL1d (GLuint index, GLdouble x)
	// void glVertexAttribL2d (GLuint index, GLdouble x, GLdouble y)
	// void glVertexAttribL3d (GLuint index, GLdouble x, GLdouble y, GLdouble z)
	// void glVertexAttribL4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glVertexAttribL1dv (GLuint index, const GLdouble *v)
	// void glVertexAttribL2dv (GLuint index, const GLdouble *v)
	// void glVertexAttribL3dv (GLuint index, const GLdouble *v)
	// void glVertexAttribL4dv (GLuint index, const GLdouble *v)
	// void glVertexAttribLPointer (GLuint index, GLint size, GLenum type, GLsizei stride, const void *pointer)
	// void glGetVertexAttribLdv (GLuint index, GLenum pname, GLdouble *params)
}
