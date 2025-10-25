package lime.graphics.opengl.ext;

@:keep
@:noCompletion class KHR_robustness
{
	public var NO_ERROR = 0;
	public var CONTEXT_ROBUST_ACCESS = 0x90F3;
	public var LOSE_CONTEXT_ON_RESET = 0x8252;
	public var GUILTY_CONTEXT_RESET = 0x8253;
	public var INNOCENT_CONTEXT_RESET = 0x8254;
	public var UNKNOWN_CONTEXT_RESET = 0x8255;
	public var RESET_NOTIFICATION_STRATEGY = 0x8256;
	public var NO_RESET_NOTIFICATION = 0x8261;
	public var CONTEXT_LOST = 0x0507;

	@:noCompletion private function new() {}

	// GLenum glGetGraphicsResetStatus ()
	// void glReadnPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, void *data)
	// void glGetnUniformfv (GLuint program, GLint location, GLsizei bufSize, GLfloat *params)
	// void glGetnUniformiv (GLuint program, GLint location, GLsizei bufSize, GLint *params)
	// void glGetnUniformuiv (GLuint program, GLint location, GLsizei bufSize, GLuint *params)
}
