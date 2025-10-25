package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_debug_output
{
	public var DEBUG_OUTPUT_SYNCHRONOUS_ARB = 0x8242;
	public var DEBUG_NEXT_LOGGED_MESSAGE_LENGTH_ARB = 0x8243;
	public var DEBUG_CALLBACK_FUNCTION_ARB = 0x8244;
	public var DEBUG_CALLBACK_USER_PARAM_ARB = 0x8245;
	public var DEBUG_SOURCE_API_ARB = 0x8246;
	public var DEBUG_SOURCE_WINDOW_SYSTEM_ARB = 0x8247;
	public var DEBUG_SOURCE_SHADER_COMPILER_ARB = 0x8248;
	public var DEBUG_SOURCE_THIRD_PARTY_ARB = 0x8249;
	public var DEBUG_SOURCE_APPLICATION_ARB = 0x824A;
	public var DEBUG_SOURCE_OTHER_ARB = 0x824B;
	public var DEBUG_TYPE_ERROR_ARB = 0x824C;
	public var DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB = 0x824D;
	public var DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB = 0x824E;
	public var DEBUG_TYPE_PORTABILITY_ARB = 0x824F;
	public var DEBUG_TYPE_PERFORMANCE_ARB = 0x8250;
	public var DEBUG_TYPE_OTHER_ARB = 0x8251;
	public var MAX_DEBUG_MESSAGE_LENGTH_ARB = 0x9143;
	public var MAX_DEBUG_LOGGED_MESSAGES_ARB = 0x9144;
	public var DEBUG_LOGGED_MESSAGES_ARB = 0x9145;
	public var DEBUG_SEVERITY_HIGH_ARB = 0x9146;
	public var DEBUG_SEVERITY_MEDIUM_ARB = 0x9147;
	public var DEBUG_SEVERITY_LOW_ARB = 0x9148;

	@:noCompletion private function new() {}

	// void glDebugMessageControlARB (GLenum source, GLenum type, GLenum severity, GLsizei count, const GLuint *ids, GLboolean enabled)
	// void glDebugMessageInsertARB (GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar *buf)
	// void glDebugMessageCallbackARB (GLDEBUGPROCARB callback, const void *userParam)
	// GLuint glGetDebugMessageLogARB (GLuint count, GLsizei bufSize, GLenum *sources, GLenum *types, GLuint *ids, GLenum *severities, GLsizei *lengths, GLchar *messageLog)
}
