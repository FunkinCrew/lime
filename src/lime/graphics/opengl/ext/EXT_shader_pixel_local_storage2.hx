package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_shader_pixel_local_storage2
{
	public var MAX_SHADER_COMBINED_LOCAL_STORAGE_FAST_SIZE_EXT = 0x9650;
	public var MAX_SHADER_COMBINED_LOCAL_STORAGE_SIZE_EXT = 0x9651;
	public var FRAMEBUFFER_INCOMPLETE_INSUFFICIENT_SHADER_COMBINED_LOCAL_STORAGE_EXT = 0x9652;

	@:noCompletion private function new() {}

	// void glFramebufferPixelLocalStorageSizeEXT (GLuint target, GLsizei size)
	// GLsizei glGetFramebufferPixelLocalStorageSizeEXT (GLuint target)
	// void glClearPixelLocalStorageuiEXT (GLsizei offset, GLsizei n, const GLuint *values)
}
