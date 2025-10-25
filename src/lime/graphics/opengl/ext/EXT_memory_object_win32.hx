package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_memory_object_win32
{
	public var HANDLE_TYPE_OPAQUE_WIN32_EXT = 0x9587;
	public var HANDLE_TYPE_OPAQUE_WIN32_KMT_EXT = 0x9588;
	public var DEVICE_LUID_EXT = 0x9599;
	public var DEVICE_NODE_MASK_EXT = 0x959A;
	public var LUID_SIZE_EXT = 8;
	public var HANDLE_TYPE_D3D12_TILEPOOL_EXT = 0x9589;
	public var HANDLE_TYPE_D3D12_RESOURCE_EXT = 0x958A;
	public var HANDLE_TYPE_D3D11_IMAGE_EXT = 0x958B;
	public var HANDLE_TYPE_D3D11_IMAGE_KMT_EXT = 0x958C;

	@:noCompletion private function new() {}

	// void glImportMemoryWin32HandleEXT (GLuint memory, GLuint64 size, GLenum handleType, void *handle)
	// void glImportMemoryWin32NameEXT (GLuint memory, GLuint64 size, GLenum handleType, const void *name)
}
