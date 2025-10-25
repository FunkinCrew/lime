package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ANGLE_framebuffer_multisample
{
	public var RENDERBUFFER_SAMPLES_ANGLE = 0x8CAB;
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_ANGLE = 0x8D56;
	public var MAX_SAMPLES_ANGLE = 0x8D57;

	@:noCompletion private function new() {}

	// void glRenderbufferStorageMultisampleANGLE (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height)
}
