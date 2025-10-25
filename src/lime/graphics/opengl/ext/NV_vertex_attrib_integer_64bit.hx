package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_vertex_attrib_integer_64bit
{
	public var INT64_NV = 0x140E;
	public var UNSIGNED_INT64_NV = 0x140F;

	@:noCompletion private function new() {}

	// void glVertexAttribL1i64NV (GLuint index, GLint64EXT x)
	// void glVertexAttribL2i64NV (GLuint index, GLint64EXT x, GLint64EXT y)
	// void glVertexAttribL3i64NV (GLuint index, GLint64EXT x, GLint64EXT y, GLint64EXT z)
	// void glVertexAttribL4i64NV (GLuint index, GLint64EXT x, GLint64EXT y, GLint64EXT z, GLint64EXT w)
	// void glVertexAttribL1i64vNV (GLuint index, const GLint64EXT *v)
	// void glVertexAttribL2i64vNV (GLuint index, const GLint64EXT *v)
	// void glVertexAttribL3i64vNV (GLuint index, const GLint64EXT *v)
	// void glVertexAttribL4i64vNV (GLuint index, const GLint64EXT *v)
	// void glVertexAttribL1ui64NV (GLuint index, GLuint64EXT x)
	// void glVertexAttribL2ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y)
	// void glVertexAttribL3ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z)
	// void glVertexAttribL4ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z, GLuint64EXT w)
	// void glVertexAttribL1ui64vNV (GLuint index, const GLuint64EXT *v)
	// void glVertexAttribL2ui64vNV (GLuint index, const GLuint64EXT *v)
	// void glVertexAttribL3ui64vNV (GLuint index, const GLuint64EXT *v)
	// void glVertexAttribL4ui64vNV (GLuint index, const GLuint64EXT *v)
	// void glGetVertexAttribLi64vNV (GLuint index, GLenum pname, GLint64EXT *params)
	// void glGetVertexAttribLui64vNV (GLuint index, GLenum pname, GLuint64EXT *params)
	// void glVertexAttribLFormatNV (GLuint index, GLint size, GLenum type, GLsizei stride)
}
