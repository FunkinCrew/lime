package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_cl_event
{
	public var SYNC_CL_EVENT_ARB = 0x8240;
	public var SYNC_CL_EVENT_COMPLETE_ARB = 0x8241;

	@:noCompletion private function new() {}

	// GLsync glCreateSyncFromCLeventARB (struct _cl_context *context, struct _cl_event *event, GLbitfield flags)
}
