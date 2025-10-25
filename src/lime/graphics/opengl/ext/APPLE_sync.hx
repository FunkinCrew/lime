package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_sync
{
	public var SYNC_OBJECT_APPLE = 0x8A53;
	public var MAX_SERVER_WAIT_TIMEOUT_APPLE = 0x9111;
	public var OBJECT_TYPE_APPLE = 0x9112;
	public var SYNC_CONDITION_APPLE = 0x9113;
	public var SYNC_STATUS_APPLE = 0x9114;
	public var SYNC_FLAGS_APPLE = 0x9115;
	public var SYNC_FENCE_APPLE = 0x9116;
	public var SYNC_GPU_COMMANDS_COMPLETE_APPLE = 0x9117;
	public var UNSIGNALED_APPLE = 0x9118;
	public var SIGNALED_APPLE = 0x9119;
	public var ALREADY_SIGNALED_APPLE = 0x911A;
	public var TIMEOUT_EXPIRED_APPLE = 0x911B;
	public var CONDITION_SATISFIED_APPLE = 0x911C;
	public var WAIT_FAILED_APPLE = 0x911D;
	public var SYNC_FLUSH_COMMANDS_BIT_APPLE = 0x00000001;
	public var TIMEOUT_IGNORED_APPLE = 0xFFFFFFFF; // 0xFFFFFFFFFFFFFFFF

	@:noCompletion private function new() {}

	// GLsync glFenceSyncAPPLE (GLenum condition, GLbitfield flags)
	// GLboolean glIsSyncAPPLE (GLsync sync)
	// void glDeleteSyncAPPLE (GLsync sync)
	// GLenum glClientWaitSyncAPPLE (GLsync sync, GLbitfield flags, GLuint64 timeout)
	// void glWaitSyncAPPLE (GLsync sync, GLbitfield flags, GLuint64 timeout)
	// void glGetInteger64vAPPLE (GLenum pname, GLint64 *params)
	// void glGetSyncivAPPLE (GLsync sync, GLenum pname, GLsizei count, GLsizei *length, GLint *values)
}
