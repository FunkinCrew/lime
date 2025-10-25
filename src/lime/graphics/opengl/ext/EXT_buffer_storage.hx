package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_buffer_storage
{
	public var MAP_READ_BIT = 0x0001;
	public var MAP_WRITE_BIT = 0x0002;
	public var MAP_PERSISTENT_BIT_EXT = 0x0040;
	public var MAP_COHERENT_BIT_EXT = 0x0080;
	public var DYNAMIC_STORAGE_BIT_EXT = 0x0100;
	public var CLIENT_STORAGE_BIT_EXT = 0x0200;
	public var CLIENT_MAPPED_BUFFER_BARRIER_BIT_EXT = 0x00004000;
	public var BUFFER_IMMUTABLE_STORAGE_EXT = 0x821F;
	public var BUFFER_STORAGE_FLAGS_EXT = 0x8220;

	@:noCompletion private function new() {}

	// void glBufferStorageEXT (GLenum target, GLsizeiptr size, const void *data, GLbitfield flags)
}
