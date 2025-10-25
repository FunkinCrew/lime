package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture_buffer_object
{
	public var TEXTURE_BUFFER_EXT = 0x8C2A;
	public var MAX_TEXTURE_BUFFER_SIZE_EXT = 0x8C2B;
	public var TEXTURE_BINDING_BUFFER_EXT = 0x8C2C;
	public var TEXTURE_BUFFER_DATA_STORE_BINDING_EXT = 0x8C2D;
	public var TEXTURE_BUFFER_FORMAT_EXT = 0x8C2E;

	@:noCompletion private function new() {}

	// void glTexBufferEXT (GLenum target, GLenum internalformat, GLuint buffer)
}
