package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_disjoint_timer_query
{
	public var QUERY_COUNTER_BITS_EXT = 0x8864;
	public var CURRENT_QUERY_EXT = 0x8865;
	public var QUERY_RESULT_EXT = 0x8866;
	public var QUERY_RESULT_AVAILABLE_EXT = 0x8867;
	public var TIME_ELAPSED_EXT = 0x88BF;
	public var TIMESTAMP_EXT = 0x8E28;
	public var GPU_DISJOINT_EXT = 0x8FBB;

	@:noCompletion private function new() {}

	// void glGenQueriesEXT (GLsizei n, GLuint *ids)
	// void glDeleteQueriesEXT (GLsizei n, const GLuint *ids)
	// GLboolean glIsQueryEXT (GLuint id)
	// void glBeginQueryEXT (GLenum target, GLuint id)
	// void glEndQueryEXT (GLenum target)
	// void glQueryCounterEXT (GLuint id, GLenum target)
	// void glGetQueryivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetQueryObjectivEXT (GLuint id, GLenum pname, GLint *params)
	// void glGetQueryObjectuivEXT (GLuint id, GLenum pname, GLuint *params)
	// void glGetQueryObjecti64vEXT (GLuint id, GLenum pname, GLint64 *params)
	// void glGetQueryObjectui64vEXT (GLuint id, GLenum pname, GLuint64 *params)
	// void glGetInteger64vEXT (GLenum pname, GLint64 *data)
}
