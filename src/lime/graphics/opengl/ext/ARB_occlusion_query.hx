package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_occlusion_query
{
	public var QUERY_COUNTER_BITS_ARB = 0x8864;
	public var CURRENT_QUERY_ARB = 0x8865;
	public var QUERY_RESULT_ARB = 0x8866;
	public var QUERY_RESULT_AVAILABLE_ARB = 0x8867;
	public var SAMPLES_PASSED_ARB = 0x8914;

	@:noCompletion private function new() {}

	// void glGenQueriesARB (GLsizei n, GLuint *ids)
	// void glDeleteQueriesARB (GLsizei n, const GLuint *ids)
	// GLboolean glIsQueryARB (GLuint id)
	// void glBeginQueryARB (GLenum target, GLuint id)
	// void glEndQueryARB (GLenum target)
	// void glGetQueryivARB (GLenum target, GLenum pname, GLint *params)
	// void glGetQueryObjectivARB (GLuint id, GLenum pname, GLint *params)
	// void glGetQueryObjectuivARB (GLuint id, GLenum pname, GLuint *params)
}
