package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_vertex_attrib_64bit
{
	public var DOUBLE = 0x140A;
	public var DOUBLE_VEC2_EXT = 0x8FFC;
	public var DOUBLE_VEC3_EXT = 0x8FFD;
	public var DOUBLE_VEC4_EXT = 0x8FFE;
	public var DOUBLE_MAT2_EXT = 0x8F46;
	public var DOUBLE_MAT3_EXT = 0x8F47;
	public var DOUBLE_MAT4_EXT = 0x8F48;
	public var DOUBLE_MAT2x3_EXT = 0x8F49;
	public var DOUBLE_MAT2x4_EXT = 0x8F4A;
	public var DOUBLE_MAT3x2_EXT = 0x8F4B;
	public var DOUBLE_MAT3x4_EXT = 0x8F4C;
	public var DOUBLE_MAT4x2_EXT = 0x8F4D;
	public var DOUBLE_MAT4x3_EXT = 0x8F4E;

	@:noCompletion private function new() {}

	// void glVertexAttribL1dEXT (GLuint index, GLdouble x)
	// void glVertexAttribL2dEXT (GLuint index, GLdouble x, GLdouble y)
	// void glVertexAttribL3dEXT (GLuint index, GLdouble x, GLdouble y, GLdouble z)
	// void glVertexAttribL4dEXT (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glVertexAttribL1dvEXT (GLuint index, const GLdouble *v)
	// void glVertexAttribL2dvEXT (GLuint index, const GLdouble *v)
	// void glVertexAttribL3dvEXT (GLuint index, const GLdouble *v)
	// void glVertexAttribL4dvEXT (GLuint index, const GLdouble *v)
	// void glVertexAttribLPointerEXT (GLuint index, GLint size, GLenum type, GLsizei stride, const void *pointer)
	// void glGetVertexAttribLdvEXT (GLuint index, GLenum pname, GLdouble *params)
}
