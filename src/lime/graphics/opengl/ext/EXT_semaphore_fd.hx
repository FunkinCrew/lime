package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_semaphore_fd
{
	public var HANDLE_TYPE_OPAQUE_FD_EXT = 0x9586;

	@:noCompletion private function new() {}

	// void glImportSemaphoreFdEXT (GLuint semaphore, GLenum handleType, GLint fd)
}
