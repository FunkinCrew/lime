package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_occlusion_query
{
	public var PIXEL_COUNTER_BITS_NV = 0x8864;
	public var CURRENT_OCCLUSION_QUERY_ID_NV = 0x8865;
	public var PIXEL_COUNT_NV = 0x8866;
	public var PIXEL_COUNT_AVAILABLE_NV = 0x8867;

	@:noCompletion private function new() {}

	// void glGenOcclusionQueriesNV (GLsizei n, GLuint *ids)
	// void glDeleteOcclusionQueriesNV (GLsizei n, const GLuint *ids)
	// GLboolean glIsOcclusionQueryNV (GLuint id)
	// void glBeginOcclusionQueryNV (GLuint id)
	// void glEndOcclusionQueryNV ()
	// void glGetOcclusionQueryivNV (GLuint id, GLenum pname, GLint *params)
	// void glGetOcclusionQueryuivNV (GLuint id, GLenum pname, GLuint *params)
}
