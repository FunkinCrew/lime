package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_framebuffer_no_attachments
{
	public var FRAMEBUFFER_DEFAULT_WIDTH = 0x9310;
	public var FRAMEBUFFER_DEFAULT_HEIGHT = 0x9311;
	public var FRAMEBUFFER_DEFAULT_LAYERS = 0x9312;
	public var FRAMEBUFFER_DEFAULT_SAMPLES = 0x9313;
	public var FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS = 0x9314;
	public var MAX_FRAMEBUFFER_WIDTH = 0x9315;
	public var MAX_FRAMEBUFFER_HEIGHT = 0x9316;
	public var MAX_FRAMEBUFFER_LAYERS = 0x9317;
	public var MAX_FRAMEBUFFER_SAMPLES = 0x9318;

	@:noCompletion private function new() {}

	// void glFramebufferParameteri (GLenum target, GLenum pname, GLint param)
	// void glGetFramebufferParameteriv (GLenum target, GLenum pname, GLint *params)
}
