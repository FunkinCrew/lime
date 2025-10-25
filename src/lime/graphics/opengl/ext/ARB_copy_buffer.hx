package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_copy_buffer
{
	public var COPY_READ_BUFFER = 0x8F36;
	public var COPY_WRITE_BUFFER = 0x8F37;

	@:noCompletion private function new() {}

	// void glCopyBufferSubData (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size)
}
