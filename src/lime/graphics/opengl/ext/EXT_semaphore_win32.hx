package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_semaphore_win32
{
	public var HANDLE_TYPE_OPAQUE_WIN32_EXT = 0x9587;
	public var HANDLE_TYPE_OPAQUE_WIN32_KMT_EXT = 0x9588;
	public var DEVICE_LUID_EXT = 0x9599;
	public var DEVICE_NODE_MASK_EXT = 0x959A;
	public var LUID_SIZE_EXT = 8;
	public var HANDLE_TYPE_D3D12_FENCE_EXT = 0x9594;
	public var D3D12_FENCE_VALUE_EXT = 0x9595;

	@:noCompletion private function new() {}

	// void glImportSemaphoreWin32HandleEXT (GLuint semaphore, GLenum handleType, void *handle)
	// void glImportSemaphoreWin32NameEXT (GLuint semaphore, GLenum handleType, const void *name)
}
