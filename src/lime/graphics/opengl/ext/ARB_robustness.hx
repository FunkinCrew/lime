package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_robustness
{
	public var NO_ERROR = 0;
	public var CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB = 0x00000004;
	public var LOSE_CONTEXT_ON_RESET_ARB = 0x8252;
	public var GUILTY_CONTEXT_RESET_ARB = 0x8253;
	public var INNOCENT_CONTEXT_RESET_ARB = 0x8254;
	public var UNKNOWN_CONTEXT_RESET_ARB = 0x8255;
	public var RESET_NOTIFICATION_STRATEGY_ARB = 0x8256;
	public var NO_RESET_NOTIFICATION_ARB = 0x8261;

	@:noCompletion private function new() {}

	// GLenum glGetGraphicsResetStatusARB ()
	// void glGetnTexImageARB (GLenum target, GLint level, GLenum format, GLenum type, GLsizei bufSize, void *img)
	// void glReadnPixelsARB (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, void *data)
	// void glGetnCompressedTexImageARB (GLenum target, GLint lod, GLsizei bufSize, void *img)
	// void glGetnUniformfvARB (GLuint program, GLint location, GLsizei bufSize, GLfloat *params)
	// void glGetnUniformivARB (GLuint program, GLint location, GLsizei bufSize, GLint *params)
	// void glGetnUniformuivARB (GLuint program, GLint location, GLsizei bufSize, GLuint *params)
	// void glGetnUniformdvARB (GLuint program, GLint location, GLsizei bufSize, GLdouble *params)
}
