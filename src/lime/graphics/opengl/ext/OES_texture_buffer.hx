package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_texture_buffer
{
	public var TEXTURE_BUFFER_OES = 0x8C2A;
	public var TEXTURE_BUFFER_BINDING_OES = 0x8C2A;
	public var MAX_TEXTURE_BUFFER_SIZE_OES = 0x8C2B;
	public var TEXTURE_BINDING_BUFFER_OES = 0x8C2C;
	public var TEXTURE_BUFFER_DATA_STORE_BINDING_OES = 0x8C2D;
	public var TEXTURE_BUFFER_OFFSET_ALIGNMENT_OES = 0x919F;
	public var SAMPLER_BUFFER_OES = 0x8DC2;
	public var INT_SAMPLER_BUFFER_OES = 0x8DD0;
	public var UNSIGNED_INT_SAMPLER_BUFFER_OES = 0x8DD8;
	public var IMAGE_BUFFER_OES = 0x9051;
	public var INT_IMAGE_BUFFER_OES = 0x905C;
	public var UNSIGNED_INT_IMAGE_BUFFER_OES = 0x9067;
	public var TEXTURE_BUFFER_OFFSET_OES = 0x919D;
	public var TEXTURE_BUFFER_SIZE_OES = 0x919E;

	@:noCompletion private function new() {}

	// void glTexBufferOES (GLenum target, GLenum internalformat, GLuint buffer)
	// void glTexBufferRangeOES (GLenum target, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size)
}
