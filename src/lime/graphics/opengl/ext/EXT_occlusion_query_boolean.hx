package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_occlusion_query_boolean
{
	public var ANY_SAMPLES_PASSED_EXT = 0x8C2F;
	public var ANY_SAMPLES_PASSED_CONSERVATIVE_EXT = 0x8D6A;
	public var CURRENT_QUERY_EXT = 0x8865;
	public var QUERY_RESULT_EXT = 0x8866;
	public var QUERY_RESULT_AVAILABLE_EXT = 0x8867;

	@:noCompletion private function new() {}

	// void glGenQueriesEXT (GLsizei n, GLuint *ids)
	// void glDeleteQueriesEXT (GLsizei n, const GLuint *ids)
	// GLboolean glIsQueryEXT (GLuint id)
	// void glBeginQueryEXT (GLenum target, GLuint id)
	// void glEndQueryEXT (GLenum target)
	// void glGetQueryivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetQueryObjectuivEXT (GLuint id, GLenum pname, GLuint *params)
}
