package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_vertex_array
{
	public var VERTEX_ARRAY_EXT = 0x8074;
	public var NORMAL_ARRAY_EXT = 0x8075;
	public var COLOR_ARRAY_EXT = 0x8076;
	public var INDEX_ARRAY_EXT = 0x8077;
	public var TEXTURE_COORD_ARRAY_EXT = 0x8078;
	public var EDGE_FLAG_ARRAY_EXT = 0x8079;
	public var VERTEX_ARRAY_SIZE_EXT = 0x807A;
	public var VERTEX_ARRAY_TYPE_EXT = 0x807B;
	public var VERTEX_ARRAY_STRIDE_EXT = 0x807C;
	public var VERTEX_ARRAY_COUNT_EXT = 0x807D;
	public var NORMAL_ARRAY_TYPE_EXT = 0x807E;
	public var NORMAL_ARRAY_STRIDE_EXT = 0x807F;
	public var NORMAL_ARRAY_COUNT_EXT = 0x8080;
	public var COLOR_ARRAY_SIZE_EXT = 0x8081;
	public var COLOR_ARRAY_TYPE_EXT = 0x8082;
	public var COLOR_ARRAY_STRIDE_EXT = 0x8083;
	public var COLOR_ARRAY_COUNT_EXT = 0x8084;
	public var INDEX_ARRAY_TYPE_EXT = 0x8085;
	public var INDEX_ARRAY_STRIDE_EXT = 0x8086;
	public var INDEX_ARRAY_COUNT_EXT = 0x8087;
	public var TEXTURE_COORD_ARRAY_SIZE_EXT = 0x8088;
	public var TEXTURE_COORD_ARRAY_TYPE_EXT = 0x8089;
	public var TEXTURE_COORD_ARRAY_STRIDE_EXT = 0x808A;
	public var TEXTURE_COORD_ARRAY_COUNT_EXT = 0x808B;
	public var EDGE_FLAG_ARRAY_STRIDE_EXT = 0x808C;
	public var EDGE_FLAG_ARRAY_COUNT_EXT = 0x808D;
	public var VERTEX_ARRAY_POINTER_EXT = 0x808E;
	public var NORMAL_ARRAY_POINTER_EXT = 0x808F;
	public var COLOR_ARRAY_POINTER_EXT = 0x8090;
	public var INDEX_ARRAY_POINTER_EXT = 0x8091;
	public var TEXTURE_COORD_ARRAY_POINTER_EXT = 0x8092;
	public var EDGE_FLAG_ARRAY_POINTER_EXT = 0x8093;

	@:noCompletion private function new() {}

	// void glArrayElementEXT (GLint i)
	// void glColorPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, const void *pointer)
	// void glDrawArraysEXT (GLenum mode, GLint first, GLsizei count)
	// void glEdgeFlagPointerEXT (GLsizei stride, GLsizei count, const GLboolean *pointer)
	// void glGetPointervEXT (GLenum pname, void **params)
	// void glIndexPointerEXT (GLenum type, GLsizei stride, GLsizei count, const void *pointer)
	// void glNormalPointerEXT (GLenum type, GLsizei stride, GLsizei count, const void *pointer)
	// void glTexCoordPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, const void *pointer)
	// void glVertexPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, const void *pointer)
}
