package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_framebuffer_multisample_advanced
{
	public var RENDERBUFFER_STORAGE_SAMPLES_AMD = 0x91B2;
	public var MAX_COLOR_FRAMEBUFFER_SAMPLES_AMD = 0x91B3;
	public var MAX_COLOR_FRAMEBUFFER_STORAGE_SAMPLES_AMD = 0x91B4;
	public var MAX_DEPTH_STENCIL_FRAMEBUFFER_SAMPLES_AMD = 0x91B5;
	public var NUM_SUPPORTED_MULTISAMPLE_MODES_AMD = 0x91B6;
	public var SUPPORTED_MULTISAMPLE_MODES_AMD = 0x91B7;

	@:noCompletion private function new() {}

	// void glRenderbufferStorageMultisampleAdvancedAMD (GLenum target, GLsizei samples, GLsizei storageSamples, GLenum internalformat, GLsizei width, GLsizei height)
	// void glNamedRenderbufferStorageMultisampleAdvancedAMD (GLuint renderbuffer, GLsizei samples, GLsizei storageSamples, GLenum internalformat, GLsizei width, GLsizei height)
}
