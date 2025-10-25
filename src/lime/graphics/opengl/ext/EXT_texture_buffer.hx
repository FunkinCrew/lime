package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture_buffer
{
	public var TEXTURE_BUFFER_EXT = 0x8C2A;
	public var TEXTURE_BUFFER_BINDING_EXT = 0x8C2A;
	public var MAX_TEXTURE_BUFFER_SIZE_EXT = 0x8C2B;
	public var TEXTURE_BINDING_BUFFER_EXT = 0x8C2C;
	public var TEXTURE_BUFFER_DATA_STORE_BINDING_EXT = 0x8C2D;
	public var TEXTURE_BUFFER_OFFSET_ALIGNMENT_EXT = 0x919F;
	public var SAMPLER_BUFFER_EXT = 0x8DC2;
	public var INT_SAMPLER_BUFFER_EXT = 0x8DD0;
	public var UNSIGNED_INT_SAMPLER_BUFFER_EXT = 0x8DD8;
	public var IMAGE_BUFFER_EXT = 0x9051;
	public var INT_IMAGE_BUFFER_EXT = 0x905C;
	public var UNSIGNED_INT_IMAGE_BUFFER_EXT = 0x9067;
	public var TEXTURE_BUFFER_OFFSET_EXT = 0x919D;
	public var TEXTURE_BUFFER_SIZE_EXT = 0x919E;

	@:noCompletion private function new() {}

	// void glTexBufferEXT (GLenum target, GLenum internalformat, GLuint buffer)
	// void glTexBufferRangeEXT (GLenum target, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size)
}
