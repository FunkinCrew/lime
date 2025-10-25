package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_debug_output
{
	public var MAX_DEBUG_MESSAGE_LENGTH_AMD = 0x9143;
	public var MAX_DEBUG_LOGGED_MESSAGES_AMD = 0x9144;
	public var DEBUG_LOGGED_MESSAGES_AMD = 0x9145;
	public var DEBUG_SEVERITY_HIGH_AMD = 0x9146;
	public var DEBUG_SEVERITY_MEDIUM_AMD = 0x9147;
	public var DEBUG_SEVERITY_LOW_AMD = 0x9148;
	public var DEBUG_CATEGORY_API_ERROR_AMD = 0x9149;
	public var DEBUG_CATEGORY_WINDOW_SYSTEM_AMD = 0x914A;
	public var DEBUG_CATEGORY_DEPRECATION_AMD = 0x914B;
	public var DEBUG_CATEGORY_UNDEFINED_BEHAVIOR_AMD = 0x914C;
	public var DEBUG_CATEGORY_PERFORMANCE_AMD = 0x914D;
	public var DEBUG_CATEGORY_SHADER_COMPILER_AMD = 0x914E;
	public var DEBUG_CATEGORY_APPLICATION_AMD = 0x914F;
	public var DEBUG_CATEGORY_OTHER_AMD = 0x9150;

	@:noCompletion private function new() {}

	// void glDebugMessageEnableAMD (GLenum category, GLenum severity, GLsizei count, const GLuint *ids, GLboolean enabled)
	// void glDebugMessageInsertAMD (GLenum category, GLenum severity, GLuint id, GLsizei length, const GLchar *buf)
	// void glDebugMessageCallbackAMD (GLDEBUGPROCAMD callback, void *userParam)
	// GLuint glGetDebugMessageLogAMD (GLuint count, GLsizei bufSize, GLenum *categories, GLenum *severities, GLuint *ids, GLsizei *lengths, GLchar *message)
}
