package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_program
{
	public var COLOR_SUM_ARB = 0x8458;
	public var VERTEX_PROGRAM_ARB = 0x8620;
	public var VERTEX_ATTRIB_ARRAY_ENABLED_ARB = 0x8622;
	public var VERTEX_ATTRIB_ARRAY_SIZE_ARB = 0x8623;
	public var VERTEX_ATTRIB_ARRAY_STRIDE_ARB = 0x8624;
	public var VERTEX_ATTRIB_ARRAY_TYPE_ARB = 0x8625;
	public var CURRENT_VERTEX_ATTRIB_ARB = 0x8626;
	public var PROGRAM_LENGTH_ARB = 0x8627;
	public var PROGRAM_STRING_ARB = 0x8628;
	public var MAX_PROGRAM_MATRIX_STACK_DEPTH_ARB = 0x862E;
	public var MAX_PROGRAM_MATRICES_ARB = 0x862F;
	public var CURRENT_MATRIX_STACK_DEPTH_ARB = 0x8640;
	public var CURRENT_MATRIX_ARB = 0x8641;
	public var VERTEX_PROGRAM_POINT_SIZE_ARB = 0x8642;
	public var VERTEX_PROGRAM_TWO_SIDE_ARB = 0x8643;
	public var VERTEX_ATTRIB_ARRAY_POINTER_ARB = 0x8645;
	public var PROGRAM_ERROR_POSITION_ARB = 0x864B;
	public var PROGRAM_BINDING_ARB = 0x8677;
	public var MAX_VERTEX_ATTRIBS_ARB = 0x8869;
	public var VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB = 0x886A;
	public var PROGRAM_ERROR_STRING_ARB = 0x8874;
	public var PROGRAM_FORMAT_ASCII_ARB = 0x8875;
	public var PROGRAM_FORMAT_ARB = 0x8876;
	public var PROGRAM_INSTRUCTIONS_ARB = 0x88A0;
	public var MAX_PROGRAM_INSTRUCTIONS_ARB = 0x88A1;
	public var PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A2;
	public var MAX_PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A3;
	public var PROGRAM_TEMPORARIES_ARB = 0x88A4;
	public var MAX_PROGRAM_TEMPORARIES_ARB = 0x88A5;
	public var PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A6;
	public var MAX_PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A7;
	public var PROGRAM_PARAMETERS_ARB = 0x88A8;
	public var MAX_PROGRAM_PARAMETERS_ARB = 0x88A9;
	public var PROGRAM_NATIVE_PARAMETERS_ARB = 0x88AA;
	public var MAX_PROGRAM_NATIVE_PARAMETERS_ARB = 0x88AB;
	public var PROGRAM_ATTRIBS_ARB = 0x88AC;
	public var MAX_PROGRAM_ATTRIBS_ARB = 0x88AD;
	public var PROGRAM_NATIVE_ATTRIBS_ARB = 0x88AE;
	public var MAX_PROGRAM_NATIVE_ATTRIBS_ARB = 0x88AF;
	public var PROGRAM_ADDRESS_REGISTERS_ARB = 0x88B0;
	public var MAX_PROGRAM_ADDRESS_REGISTERS_ARB = 0x88B1;
	public var PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B2;
	public var MAX_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B3;
	public var MAX_PROGRAM_LOCAL_PARAMETERS_ARB = 0x88B4;
	public var MAX_PROGRAM_ENV_PARAMETERS_ARB = 0x88B5;
	public var PROGRAM_UNDER_NATIVE_LIMITS_ARB = 0x88B6;
	public var TRANSPOSE_CURRENT_MATRIX_ARB = 0x88B7;
	public var MATRIX0_ARB = 0x88C0;
	public var MATRIX1_ARB = 0x88C1;
	public var MATRIX2_ARB = 0x88C2;
	public var MATRIX3_ARB = 0x88C3;
	public var MATRIX4_ARB = 0x88C4;
	public var MATRIX5_ARB = 0x88C5;
	public var MATRIX6_ARB = 0x88C6;
	public var MATRIX7_ARB = 0x88C7;
	public var MATRIX8_ARB = 0x88C8;
	public var MATRIX9_ARB = 0x88C9;
	public var MATRIX10_ARB = 0x88CA;
	public var MATRIX11_ARB = 0x88CB;
	public var MATRIX12_ARB = 0x88CC;
	public var MATRIX13_ARB = 0x88CD;
	public var MATRIX14_ARB = 0x88CE;
	public var MATRIX15_ARB = 0x88CF;
	public var MATRIX16_ARB = 0x88D0;
	public var MATRIX17_ARB = 0x88D1;
	public var MATRIX18_ARB = 0x88D2;
	public var MATRIX19_ARB = 0x88D3;
	public var MATRIX20_ARB = 0x88D4;
	public var MATRIX21_ARB = 0x88D5;
	public var MATRIX22_ARB = 0x88D6;
	public var MATRIX23_ARB = 0x88D7;
	public var MATRIX24_ARB = 0x88D8;
	public var MATRIX25_ARB = 0x88D9;
	public var MATRIX26_ARB = 0x88DA;
	public var MATRIX27_ARB = 0x88DB;
	public var MATRIX28_ARB = 0x88DC;
	public var MATRIX29_ARB = 0x88DD;
	public var MATRIX30_ARB = 0x88DE;
	public var MATRIX31_ARB = 0x88DF;

	@:noCompletion private function new() {}

	// void glVertexAttrib1dARB (GLuint index, GLdouble x)
	// void glVertexAttrib1dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib1fARB (GLuint index, GLfloat x)
	// void glVertexAttrib1fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib1sARB (GLuint index, GLshort x)
	// void glVertexAttrib1svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib2dARB (GLuint index, GLdouble x, GLdouble y)
	// void glVertexAttrib2dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib2fARB (GLuint index, GLfloat x, GLfloat y)
	// void glVertexAttrib2fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib2sARB (GLuint index, GLshort x, GLshort y)
	// void glVertexAttrib2svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib3dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z)
	// void glVertexAttrib3dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib3fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z)
	// void glVertexAttrib3fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib3sARB (GLuint index, GLshort x, GLshort y, GLshort z)
	// void glVertexAttrib3svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib4NbvARB (GLuint index, const GLbyte *v)
	// void glVertexAttrib4NivARB (GLuint index, const GLint *v)
	// void glVertexAttrib4NsvARB (GLuint index, const GLshort *v)
	// void glVertexAttrib4NubARB (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w)
	// void glVertexAttrib4NubvARB (GLuint index, const GLubyte *v)
	// void glVertexAttrib4NuivARB (GLuint index, const GLuint *v)
	// void glVertexAttrib4NusvARB (GLuint index, const GLushort *v)
	// void glVertexAttrib4bvARB (GLuint index, const GLbyte *v)
	// void glVertexAttrib4dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glVertexAttrib4dvARB (GLuint index, const GLdouble *v)
	// void glVertexAttrib4fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glVertexAttrib4fvARB (GLuint index, const GLfloat *v)
	// void glVertexAttrib4ivARB (GLuint index, const GLint *v)
	// void glVertexAttrib4sARB (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w)
	// void glVertexAttrib4svARB (GLuint index, const GLshort *v)
	// void glVertexAttrib4ubvARB (GLuint index, const GLubyte *v)
	// void glVertexAttrib4uivARB (GLuint index, const GLuint *v)
	// void glVertexAttrib4usvARB (GLuint index, const GLushort *v)
	// void glVertexAttribPointerARB (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void *pointer)
	// void glEnableVertexAttribArrayARB (GLuint index)
	// void glDisableVertexAttribArrayARB (GLuint index)
	// void glProgramStringARB (GLenum target, GLenum format, GLsizei len, const void *string)
	// void glBindProgramARB (GLenum target, GLuint program)
	// void glDeleteProgramsARB (GLsizei n, const GLuint *programs)
	// void glGenProgramsARB (GLsizei n, GLuint *programs)
	// void glProgramEnvParameter4dARB (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glProgramEnvParameter4dvARB (GLenum target, GLuint index, const GLdouble *params)
	// void glProgramEnvParameter4fARB (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glProgramEnvParameter4fvARB (GLenum target, GLuint index, const GLfloat *params)
	// void glProgramLocalParameter4dARB (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glProgramLocalParameter4dvARB (GLenum target, GLuint index, const GLdouble *params)
	// void glProgramLocalParameter4fARB (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glProgramLocalParameter4fvARB (GLenum target, GLuint index, const GLfloat *params)
	// void glGetProgramEnvParameterdvARB (GLenum target, GLuint index, GLdouble *params)
	// void glGetProgramEnvParameterfvARB (GLenum target, GLuint index, GLfloat *params)
	// void glGetProgramLocalParameterdvARB (GLenum target, GLuint index, GLdouble *params)
	// void glGetProgramLocalParameterfvARB (GLenum target, GLuint index, GLfloat *params)
	// void glGetProgramivARB (GLenum target, GLenum pname, GLint *params)
	// void glGetProgramStringARB (GLenum target, GLenum pname, void *string)
	// void glGetVertexAttribdvARB (GLuint index, GLenum pname, GLdouble *params)
	// void glGetVertexAttribfvARB (GLuint index, GLenum pname, GLfloat *params)
	// void glGetVertexAttribivARB (GLuint index, GLenum pname, GLint *params)
	// void glGetVertexAttribPointervARB (GLuint index, GLenum pname, void **pointer)
	// GLboolean glIsProgramARB (GLuint program)
}
