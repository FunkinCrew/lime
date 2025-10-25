package lime.graphics.opengl.ext;

@:keep
@:noCompletion class IBM_vertex_array_lists
{
	public var VERTEX_ARRAY_LIST_IBM = 103070;
	public var NORMAL_ARRAY_LIST_IBM = 103071;
	public var COLOR_ARRAY_LIST_IBM = 103072;
	public var INDEX_ARRAY_LIST_IBM = 103073;
	public var TEXTURE_COORD_ARRAY_LIST_IBM = 103074;
	public var EDGE_FLAG_ARRAY_LIST_IBM = 103075;
	public var FOG_COORDINATE_ARRAY_LIST_IBM = 103076;
	public var SECONDARY_COLOR_ARRAY_LIST_IBM = 103077;
	public var VERTEX_ARRAY_LIST_STRIDE_IBM = 103080;
	public var NORMAL_ARRAY_LIST_STRIDE_IBM = 103081;
	public var COLOR_ARRAY_LIST_STRIDE_IBM = 103082;
	public var INDEX_ARRAY_LIST_STRIDE_IBM = 103083;
	public var TEXTURE_COORD_ARRAY_LIST_STRIDE_IBM = 103084;
	public var EDGE_FLAG_ARRAY_LIST_STRIDE_IBM = 103085;
	public var FOG_COORDINATE_ARRAY_LIST_STRIDE_IBM = 103086;
	public var SECONDARY_COLOR_ARRAY_LIST_STRIDE_IBM = 103087;

	@:noCompletion private function new() {}

	// void glColorPointerListIBM (GLint size, GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glSecondaryColorPointerListIBM (GLint size, GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glEdgeFlagPointerListIBM (GLint stride, const GLboolean **pointer, GLint ptrstride)
	// void glFogCoordPointerListIBM (GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glIndexPointerListIBM (GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glNormalPointerListIBM (GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glTexCoordPointerListIBM (GLint size, GLenum type, GLint stride, const void **pointer, GLint ptrstride)
	// void glVertexPointerListIBM (GLint size, GLenum type, GLint stride, const void **pointer, GLint ptrstride)
}
