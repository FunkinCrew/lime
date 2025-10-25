package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_timer_query
{
	public var TIME_ELAPSED_EXT = 0x88BF;

	@:noCompletion private function new() {}

	// void glGetQueryObjecti64vEXT (GLuint id, GLenum pname, GLint64 *params)
	// void glGetQueryObjectui64vEXT (GLuint id, GLenum pname, GLuint64 *params)
}
