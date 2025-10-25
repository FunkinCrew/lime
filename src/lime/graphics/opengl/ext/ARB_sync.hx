package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_sync
{
	public var MAX_SERVER_WAIT_TIMEOUT = 0x9111;
	public var OBJECT_TYPE = 0x9112;
	public var SYNC_CONDITION = 0x9113;
	public var SYNC_STATUS = 0x9114;
	public var SYNC_FLAGS = 0x9115;
	public var SYNC_FENCE = 0x9116;
	public var SYNC_GPU_COMMANDS_COMPLETE = 0x9117;
	public var UNSIGNALED = 0x9118;
	public var SIGNALED = 0x9119;
	public var ALREADY_SIGNALED = 0x911A;
	public var TIMEOUT_EXPIRED = 0x911B;
	public var CONDITION_SATISFIED = 0x911C;
	public var WAIT_FAILED = 0x911D;
	public var SYNC_FLUSH_COMMANDS_BIT = 0x00000001;
	public var TIMEOUT_IGNORED = 0xFFFFFFFF; // 0xFFFFFFFFFFFFFFFF

	@:noCompletion private function new() {}

	// GLsync glFenceSync (GLenum condition, GLbitfield flags)
	// GLboolean glIsSync (GLsync sync)
	// void glDeleteSync (GLsync sync)
	// GLenum glClientWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout)
	// void glWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout)
	// void glGetInteger64v (GLenum pname, GLint64 *data)
	// void glGetSynciv (GLsync sync, GLenum pname, GLsizei count, GLsizei *length, GLint *values)
}
