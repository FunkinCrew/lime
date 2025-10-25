package lime.graphics.opengl.ext;

@:keep
@:noCompletion class IMG_framebuffer_downsample
{
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_AND_DOWNSAMPLE_IMG = 0x913C;
	public var NUM_DOWNSAMPLE_SCALES_IMG = 0x913D;
	public var DOWNSAMPLE_SCALES_IMG = 0x913E;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_SCALE_IMG = 0x913F;

	@:noCompletion private function new() {}

	// void glFramebufferTexture2DDownsampleIMG (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint xscale, GLint yscale)
	// void glFramebufferTextureLayerDownsampleIMG (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer, GLint xscale, GLint yscale)
}
