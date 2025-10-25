package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_texture_buffer_range
{
	public var TEXTURE_BUFFER_OFFSET = 0x919D;
	public var TEXTURE_BUFFER_SIZE = 0x919E;
	public var TEXTURE_BUFFER_OFFSET_ALIGNMENT = 0x919F;

	@:noCompletion private function new() {}

	// void glTexBufferRange (GLenum target, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size)
}
