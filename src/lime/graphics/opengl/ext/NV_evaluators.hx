package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_evaluators
{
	public var EVAL_2D_NV = 0x86C0;
	public var EVAL_TRIANGULAR_2D_NV = 0x86C1;
	public var MAP_TESSELLATION_NV = 0x86C2;
	public var MAP_ATTRIB_U_ORDER_NV = 0x86C3;
	public var MAP_ATTRIB_V_ORDER_NV = 0x86C4;
	public var EVAL_FRACTIONAL_TESSELLATION_NV = 0x86C5;
	public var EVAL_VERTEX_ATTRIB0_NV = 0x86C6;
	public var EVAL_VERTEX_ATTRIB1_NV = 0x86C7;
	public var EVAL_VERTEX_ATTRIB2_NV = 0x86C8;
	public var EVAL_VERTEX_ATTRIB3_NV = 0x86C9;
	public var EVAL_VERTEX_ATTRIB4_NV = 0x86CA;
	public var EVAL_VERTEX_ATTRIB5_NV = 0x86CB;
	public var EVAL_VERTEX_ATTRIB6_NV = 0x86CC;
	public var EVAL_VERTEX_ATTRIB7_NV = 0x86CD;
	public var EVAL_VERTEX_ATTRIB8_NV = 0x86CE;
	public var EVAL_VERTEX_ATTRIB9_NV = 0x86CF;
	public var EVAL_VERTEX_ATTRIB10_NV = 0x86D0;
	public var EVAL_VERTEX_ATTRIB11_NV = 0x86D1;
	public var EVAL_VERTEX_ATTRIB12_NV = 0x86D2;
	public var EVAL_VERTEX_ATTRIB13_NV = 0x86D3;
	public var EVAL_VERTEX_ATTRIB14_NV = 0x86D4;
	public var EVAL_VERTEX_ATTRIB15_NV = 0x86D5;
	public var MAX_MAP_TESSELLATION_NV = 0x86D6;
	public var MAX_RATIONAL_EVAL_ORDER_NV = 0x86D7;

	@:noCompletion private function new() {}

	// void glMapControlPointsNV (GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLint uorder, GLint vorder, GLboolean packed, const void *points)
	// void glMapParameterivNV (GLenum target, GLenum pname, const GLint *params)
	// void glMapParameterfvNV (GLenum target, GLenum pname, const GLfloat *params)
	// void glGetMapControlPointsNV (GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLboolean packed, void *points)
	// void glGetMapParameterivNV (GLenum target, GLenum pname, GLint *params)
	// void glGetMapParameterfvNV (GLenum target, GLenum pname, GLfloat *params)
	// void glGetMapAttribParameterivNV (GLenum target, GLuint index, GLenum pname, GLint *params)
	// void glGetMapAttribParameterfvNV (GLenum target, GLuint index, GLenum pname, GLfloat *params)
	// void glEvalMapsNV (GLenum target, GLenum mode)
}
