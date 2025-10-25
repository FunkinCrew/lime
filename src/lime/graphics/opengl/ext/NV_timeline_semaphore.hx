package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_timeline_semaphore
{
	public var TIMELINE_SEMAPHORE_VALUE_NV = 0x9595;
	public var SEMAPHORE_TYPE_NV = 0x95B3;
	public var SEMAPHORE_TYPE_BINARY_NV = 0x95B4;
	public var SEMAPHORE_TYPE_TIMELINE_NV = 0x95B5;
	public var MAX_TIMELINE_SEMAPHORE_VALUE_DIFFERENCE_NV = 0x95B6;

	@:noCompletion private function new() {}

	// void glCreateSemaphoresNV (GLsizei n, GLuint *semaphores)
	// void glSemaphoreParameterivNV (GLuint semaphore, GLenum pname, const GLint *params)
	// void glGetSemaphoreParameterivNV (GLuint semaphore, GLenum pname, GLint *params)
}
