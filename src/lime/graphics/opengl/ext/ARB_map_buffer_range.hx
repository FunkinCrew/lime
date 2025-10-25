package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_map_buffer_range
{
	public var MAP_READ_BIT = 0x0001;
	public var MAP_WRITE_BIT = 0x0002;
	public var MAP_INVALIDATE_RANGE_BIT = 0x0004;
	public var MAP_INVALIDATE_BUFFER_BIT = 0x0008;
	public var MAP_FLUSH_EXPLICIT_BIT = 0x0010;
	public var MAP_UNSYNCHRONIZED_BIT = 0x0020;

	@:noCompletion private function new() {}

	// void * glMapBufferRange (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access)
	// void glFlushMappedBufferRange (GLenum target, GLintptr offset, GLsizeiptr length)
}
