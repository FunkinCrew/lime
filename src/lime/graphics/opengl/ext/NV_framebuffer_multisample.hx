package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_framebuffer_multisample
{
	public var RENDERBUFFER_SAMPLES_NV = 0x8CAB;
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_NV = 0x8D56;
	public var MAX_SAMPLES_NV = 0x8D57;

	@:noCompletion private function new() {}

	// void glRenderbufferStorageMultisampleNV (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height)
}
