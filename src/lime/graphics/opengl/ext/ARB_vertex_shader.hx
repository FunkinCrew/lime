package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_shader
{
	public var VERTEX_SHADER_ARB = 0x8B31;
	public var MAX_VERTEX_UNIFORM_COMPONENTS_ARB = 0x8B4A;
	public var MAX_VARYING_FLOATS_ARB = 0x8B4B;
	public var MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB = 0x8B4C;
	public var MAX_COMBINED_TEXTURE_IMAGE_UNITS_ARB = 0x8B4D;
	public var OBJECT_ACTIVE_ATTRIBUTES_ARB = 0x8B89;
	public var OBJECT_ACTIVE_ATTRIBUTE_MAX_LENGTH_ARB = 0x8B8A;
	public var MAX_VERTEX_ATTRIBS_ARB = 0x8869;
	public var MAX_TEXTURE_IMAGE_UNITS_ARB = 0x8872;
	public var MAX_TEXTURE_COORDS_ARB = 0x8871;
	public var VERTEX_PROGRAM_POINT_SIZE_ARB = 0x8642;
	public var VERTEX_PROGRAM_TWO_SIDE_ARB = 0x8643;
	public var VERTEX_ATTRIB_ARRAY_ENABLED_ARB = 0x8622;
	public var VERTEX_ATTRIB_ARRAY_SIZE_ARB = 0x8623;
	public var VERTEX_ATTRIB_ARRAY_STRIDE_ARB = 0x8624;
	public var VERTEX_ATTRIB_ARRAY_TYPE_ARB = 0x8625;
	public var VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB = 0x886A;
	public var CURRENT_VERTEX_ATTRIB_ARB = 0x8626;
	public var VERTEX_ATTRIB_ARRAY_POINTER_ARB = 0x8645;
	public var FLOAT = 0x1406;
	public var FLOAT_VEC2_ARB = 0x8B50;
	public var FLOAT_VEC3_ARB = 0x8B51;
	public var FLOAT_VEC4_ARB = 0x8B52;
	public var FLOAT_MAT2_ARB = 0x8B5A;
	public var FLOAT_MAT3_ARB = 0x8B5B;
	public var FLOAT_MAT4_ARB = 0x8B5C;

	@:noCompletion private function new() {}

	// void glVertexAttrib1fARB (GLuint index, GLfloat x)
	// void glVertexAttrib1sARB (GLuint index, GLshort x)
	// void glVertexAttrib1dARB (GLuint index, GLdouble x)
	// void glVertexAttrib2fARB (GLuint index, GLfloat x, GLfloat y)
	// void glVertexAttrib2sARB (GLuint index, GLshort x, GLshort y)
	// void glVertexAttrib2dARB (GLuint index, GLdouble x, GLdouble y)
	// void glVertexAttrib3fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z)
	// void glVertexAttrib3sARB (GLuint index, GLshort x, GLshort y, GLshort z)
	// void glVertexAttrib3dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z)
	// void glVertexAttrib4fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glVertexAttrib4sARB (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w)
	// void glVertexAttrib4dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glVertexAttrib4NubARB (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w)
	// void glVertexAttrib1fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib1svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib1dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib2fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib2svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib2dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib3fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib3svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib3dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib4fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib4svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib4dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib4ivARB (GLuint index, const GLint *v)
	// void glVertexAttrib4bvARB (GLuint index, const GLbyte *v)
	// void glVertexAttrib4ubvARB (GLuint index, const GLubyte *v)
	// void glVertexAttrib4usvARB (GLuint index, const GLushort *v)
	// void glVertexAttrib4uivARB (GLuint index, const GLuint *v)
	// void glVertexAttrib4NbvARB (GLuint index, const GLbyte *v)
	// void glVertexAttrib4NsvARB (GLuint index, const GLshort *v)
	// void glVertexAttrib4NivARB (GLuint index, const GLint *v)
	// void glVertexAttrib4NubvARB (GLuint index, const GLubyte *v)
	// void glVertexAttrib4NusvARB (GLuint index, const GLushort *v)
	// void glVertexAttrib4NuivARB (GLuint index, const GLuint *v)
	// void glVertexAttribPointerARB (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void *pointer)
	// void glEnableVertexAttribArrayARB (GLuint index)
	// void glDisableVertexAttribArrayARB (GLuint index)
	// void glBindAttribLocationARB (GLhandleARB programObj, GLuint index, const GLcharARB *name)
	// void glGetActiveAttribARB (GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name)
	// GLint glGetAttribLocationARB (GLhandleARB programObj, const GLcharARB *name)
	// void glGetVertexAttribdvARB (GLuint index, GLenum pname, GLdouble *params)
	// void glGetVertexAttribfvARB (GLuint index, GLenum pname, GLfloat *params)
	// void glGetVertexAttribivARB (GLuint index, GLenum pname, GLint *params)
	// void glGetVertexAttribPointervARB (GLuint index, GLenum pname, void **pointer)
}
