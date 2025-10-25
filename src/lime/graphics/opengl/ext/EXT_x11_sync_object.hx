package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_x11_sync_object
{
	public var SYNC_X11_FENCE_EXT = 0x90E1;

	@:noCompletion private function new() {}

	// GLsync glImportSyncEXT (GLenum external_sync_type, GLintptr external_sync, GLbitfield flags)
}
