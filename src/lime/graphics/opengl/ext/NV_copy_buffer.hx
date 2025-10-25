package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_copy_buffer
{
	public var COPY_READ_BUFFER_NV = 0x8F36;
	public var COPY_WRITE_BUFFER_NV = 0x8F37;

	@:noCompletion private function new() {}

	// void glCopyBufferSubDataNV (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size)
}
