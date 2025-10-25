package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_flush_buffer_range
{
	public var BUFFER_SERIALIZED_MODIFY_APPLE = 0x8A12;
	public var BUFFER_FLUSHING_UNMAP_APPLE = 0x8A13;

	@:noCompletion private function new() {}

	// void glBufferParameteriAPPLE (GLenum target, GLenum pname, GLint param)
	// void glFlushMappedBufferRangeAPPLE (GLenum target, GLintptr offset, GLsizeiptr size)
}
