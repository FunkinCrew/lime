package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_timer_query
{
	public var TIME_ELAPSED = 0x88BF;
	public var TIMESTAMP = 0x8E28;

	@:noCompletion private function new() {}

	// void glQueryCounter (GLuint id, GLenum target)
	// void glGetQueryObjecti64v (GLuint id, GLenum pname, GLint64 *params)
	// void glGetQueryObjectui64v (GLuint id, GLenum pname, GLuint64 *params)
}
