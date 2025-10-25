package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_vertex_program
{
	public var VERTEX_PROGRAM_NV = 0x8620;
	public var VERTEX_STATE_PROGRAM_NV = 0x8621;
	public var ATTRIB_ARRAY_SIZE_NV = 0x8623;
	public var ATTRIB_ARRAY_STRIDE_NV = 0x8624;
	public var ATTRIB_ARRAY_TYPE_NV = 0x8625;
	public var CURRENT_ATTRIB_NV = 0x8626;
	public var PROGRAM_LENGTH_NV = 0x8627;
	public var PROGRAM_STRING_NV = 0x8628;
	public var MODELVIEW_PROJECTION_NV = 0x8629;
	public var IDENTITY_NV = 0x862A;
	public var INVERSE_NV = 0x862B;
	public var TRANSPOSE_NV = 0x862C;
	public var INVERSE_TRANSPOSE_NV = 0x862D;
	public var MAX_TRACK_MATRIX_STACK_DEPTH_NV = 0x862E;
	public var MAX_TRACK_MATRICES_NV = 0x862F;
	public var MATRIX0_NV = 0x8630;
	public var MATRIX1_NV = 0x8631;
	public var MATRIX2_NV = 0x8632;
	public var MATRIX3_NV = 0x8633;
	public var MATRIX4_NV = 0x8634;
	public var MATRIX5_NV = 0x8635;
	public var MATRIX6_NV = 0x8636;
	public var MATRIX7_NV = 0x8637;
	public var CURRENT_MATRIX_STACK_DEPTH_NV = 0x8640;
	public var CURRENT_MATRIX_NV = 0x8641;
	public var VERTEX_PROGRAM_POINT_SIZE_NV = 0x8642;
	public var VERTEX_PROGRAM_TWO_SIDE_NV = 0x8643;
	public var PROGRAM_PARAMETER_NV = 0x8644;
	public var ATTRIB_ARRAY_POINTER_NV = 0x8645;
	public var PROGRAM_TARGET_NV = 0x8646;
	public var PROGRAM_RESIDENT_NV = 0x8647;
	public var TRACK_MATRIX_NV = 0x8648;
	public var TRACK_MATRIX_TRANSFORM_NV = 0x8649;
	public var VERTEX_PROGRAM_BINDING_NV = 0x864A;
	public var PROGRAM_ERROR_POSITION_NV = 0x864B;
	public var VERTEX_ATTRIB_ARRAY0_NV = 0x8650;
	public var VERTEX_ATTRIB_ARRAY1_NV = 0x8651;
	public var VERTEX_ATTRIB_ARRAY2_NV = 0x8652;
	public var VERTEX_ATTRIB_ARRAY3_NV = 0x8653;
	public var VERTEX_ATTRIB_ARRAY4_NV = 0x8654;
	public var VERTEX_ATTRIB_ARRAY5_NV = 0x8655;
	public var VERTEX_ATTRIB_ARRAY6_NV = 0x8656;
	public var VERTEX_ATTRIB_ARRAY7_NV = 0x8657;
	public var VERTEX_ATTRIB_ARRAY8_NV = 0x8658;
	public var VERTEX_ATTRIB_ARRAY9_NV = 0x8659;
	public var VERTEX_ATTRIB_ARRAY10_NV = 0x865A;
	public var VERTEX_ATTRIB_ARRAY11_NV = 0x865B;
	public var VERTEX_ATTRIB_ARRAY12_NV = 0x865C;
	public var VERTEX_ATTRIB_ARRAY13_NV = 0x865D;
	public var VERTEX_ATTRIB_ARRAY14_NV = 0x865E;
	public var VERTEX_ATTRIB_ARRAY15_NV = 0x865F;
	public var MAP1_VERTEX_ATTRIB0_4_NV = 0x8660;
	public var MAP1_VERTEX_ATTRIB1_4_NV = 0x8661;
	public var MAP1_VERTEX_ATTRIB2_4_NV = 0x8662;
	public var MAP1_VERTEX_ATTRIB3_4_NV = 0x8663;
	public var MAP1_VERTEX_ATTRIB4_4_NV = 0x8664;
	public var MAP1_VERTEX_ATTRIB5_4_NV = 0x8665;
	public var MAP1_VERTEX_ATTRIB6_4_NV = 0x8666;
	public var MAP1_VERTEX_ATTRIB7_4_NV = 0x8667;
	public var MAP1_VERTEX_ATTRIB8_4_NV = 0x8668;
	public var MAP1_VERTEX_ATTRIB9_4_NV = 0x8669;
	public var MAP1_VERTEX_ATTRIB10_4_NV = 0x866A;
	public var MAP1_VERTEX_ATTRIB11_4_NV = 0x866B;
	public var MAP1_VERTEX_ATTRIB12_4_NV = 0x866C;
	public var MAP1_VERTEX_ATTRIB13_4_NV = 0x866D;
	public var MAP1_VERTEX_ATTRIB14_4_NV = 0x866E;
	public var MAP1_VERTEX_ATTRIB15_4_NV = 0x866F;
	public var MAP2_VERTEX_ATTRIB0_4_NV = 0x8670;
	public var MAP2_VERTEX_ATTRIB1_4_NV = 0x8671;
	public var MAP2_VERTEX_ATTRIB2_4_NV = 0x8672;
	public var MAP2_VERTEX_ATTRIB3_4_NV = 0x8673;
	public var MAP2_VERTEX_ATTRIB4_4_NV = 0x8674;
	public var MAP2_VERTEX_ATTRIB5_4_NV = 0x8675;
	public var MAP2_VERTEX_ATTRIB6_4_NV = 0x8676;
	public var MAP2_VERTEX_ATTRIB7_4_NV = 0x8677;
	public var MAP2_VERTEX_ATTRIB8_4_NV = 0x8678;
	public var MAP2_VERTEX_ATTRIB9_4_NV = 0x8679;
	public var MAP2_VERTEX_ATTRIB10_4_NV = 0x867A;
	public var MAP2_VERTEX_ATTRIB11_4_NV = 0x867B;
	public var MAP2_VERTEX_ATTRIB12_4_NV = 0x867C;
	public var MAP2_VERTEX_ATTRIB13_4_NV = 0x867D;
	public var MAP2_VERTEX_ATTRIB14_4_NV = 0x867E;
	public var MAP2_VERTEX_ATTRIB15_4_NV = 0x867F;

	@:noCompletion private function new() {}

	// GLboolean glAreProgramsResidentNV (GLsizei n, const GLuint *programs, GLboolean *residences)
	// void glBindProgramNV (GLenum target, GLuint id)
	// void glDeleteProgramsNV (GLsizei n, const GLuint *programs)
	// void glExecuteProgramNV (GLenum target, GLuint id, const GLfloat *params)
	// void glGenProgramsNV (GLsizei n, GLuint *programs)
	// void glGetProgramParameterdvNV (GLenum target, GLuint index, GLenum pname, GLdouble *params)
	// void glGetProgramParameterfvNV (GLenum target, GLuint index, GLenum pname, GLfloat *params)
	// void glGetProgramivNV (GLuint id, GLenum pname, GLint *params)
	// void glGetProgramStringNV (GLuint id, GLenum pname, GLubyte *program)
	// void glGetTrackMatrixivNV (GLenum target, GLuint address, GLenum pname, GLint *params)
	// void glGetVertexAttribdvNV (GLuint index, GLenum pname, GLdouble *params)
	// void glGetVertexAttribfvNV (GLuint index, GLenum pname, GLfloat *params)
	// void glGetVertexAttribivNV (GLuint index, GLenum pname, GLint *params)
	// void glGetVertexAttribPointervNV (GLuint index, GLenum pname, void **pointer)
	// GLboolean glIsProgramNV (GLuint id)
	// void glLoadProgramNV (GLenum target, GLuint id, GLsizei len, const GLubyte *program)
	// void glProgramParameter4dNV (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glProgramParameter4dvNV (GLenum target, GLuint index, const GLdouble *v)
	// void glProgramParameter4fNV (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glProgramParameter4fvNV (GLenum target, GLuint index, const GLfloat *v)
	// void glProgramParameters4dvNV (GLenum target, GLuint index, GLsizei count, const GLdouble *v)
	// void glProgramParameters4fvNV (GLenum target, GLuint index, GLsizei count, const GLfloat *v)
	// void glRequestResidentProgramsNV (GLsizei n, const GLuint *programs)
	// void glTrackMatrixNV (GLenum target, GLuint address, GLenum matrix, GLenum transform)
	// void glVertexAttribPointerNV (GLuint index, GLint fsize, GLenum type, GLsizei stride, const void *pointer)
	// void glVertexAttrib1dNV (GLuint index, GLdouble x)
	// void glVertexAttrib1dvNV (GLuint index, const GLdouble *v)
	// void glVertexAttrib1fNV (GLuint index, GLfloat x)
	// void glVertexAttrib1fvNV (GLuint index, const GLfloat *v)
	// void glVertexAttrib1sNV (GLuint index, GLshort x)
	// void glVertexAttrib1svNV (GLuint index, const GLshort *v)
	// void glVertexAttrib2dNV (GLuint index, GLdouble x, GLdouble y)
	// void glVertexAttrib2dvNV (GLuint index, const GLdouble *v)
	// void glVertexAttrib2fNV (GLuint index, GLfloat x, GLfloat y)
	// void glVertexAttrib2fvNV (GLuint index, const GLfloat *v)
	// void glVertexAttrib2sNV (GLuint index, GLshort x, GLshort y)
	// void glVertexAttrib2svNV (GLuint index, const GLshort *v)
	// void glVertexAttrib3dNV (GLuint index, GLdouble x, GLdouble y, GLdouble z)
	// void glVertexAttrib3dvNV (GLuint index, const GLdouble *v)
	// void glVertexAttrib3fNV (GLuint index, GLfloat x, GLfloat y, GLfloat z)
	// void glVertexAttrib3fvNV (GLuint index, const GLfloat *v)
	// void glVertexAttrib3sNV (GLuint index, GLshort x, GLshort y, GLshort z)
	// void glVertexAttrib3svNV (GLuint index, const GLshort *v)
	// void glVertexAttrib4dNV (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w)
	// void glVertexAttrib4dvNV (GLuint index, const GLdouble *v)
	// void glVertexAttrib4fNV (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w)
	// void glVertexAttrib4fvNV (GLuint index, const GLfloat *v)
	// void glVertexAttrib4sNV (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w)
	// void glVertexAttrib4svNV (GLuint index, const GLshort *v)
	// void glVertexAttrib4ubNV (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w)
	// void glVertexAttrib4ubvNV (GLuint index, const GLubyte *v)
	// void glVertexAttribs1dvNV (GLuint index, GLsizei count, const GLdouble *v)
	// void glVertexAttribs1fvNV (GLuint index, GLsizei count, const GLfloat *v)
	// void glVertexAttribs1svNV (GLuint index, GLsizei count, const GLshort *v)
	// void glVertexAttribs2dvNV (GLuint index, GLsizei count, const GLdouble *v)
	// void glVertexAttribs2fvNV (GLuint index, GLsizei count, const GLfloat *v)
	// void glVertexAttribs2svNV (GLuint index, GLsizei count, const GLshort *v)
	// void glVertexAttribs3dvNV (GLuint index, GLsizei count, const GLdouble *v)
	// void glVertexAttribs3fvNV (GLuint index, GLsizei count, const GLfloat *v)
	// void glVertexAttribs3svNV (GLuint index, GLsizei count, const GLshort *v)
	// void glVertexAttribs4dvNV (GLuint index, GLsizei count, const GLdouble *v)
	// void glVertexAttribs4fvNV (GLuint index, GLsizei count, const GLfloat *v)
	// void glVertexAttribs4svNV (GLuint index, GLsizei count, const GLshort *v)
	// void glVertexAttribs4ubvNV (GLuint index, GLsizei count, const GLubyte *v)
}
