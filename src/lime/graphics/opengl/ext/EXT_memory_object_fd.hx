package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_memory_object_fd
{
	public var HANDLE_TYPE_OPAQUE_FD_EXT = 0x9586;

	@:noCompletion private function new() {}

	// void glImportMemoryFdEXT (GLuint memory, GLuint64 size, GLenum handleType, GLint fd)
}
