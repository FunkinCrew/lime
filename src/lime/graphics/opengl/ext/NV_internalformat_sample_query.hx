package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_internalformat_sample_query
{
	public var RENDERBUFFER = 0x8D41;
	public var TEXTURE_2D_MULTISAMPLE = 0x9100;
	public var TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9102;
	public var MULTISAMPLES_NV = 0x9371;
	public var SUPERSAMPLE_SCALE_X_NV = 0x9372;
	public var SUPERSAMPLE_SCALE_Y_NV = 0x9373;
	public var CONFORMANT_NV = 0x9374;

	@:noCompletion private function new() {}

	// void glGetInternalformatSampleivNV (GLenum target, GLenum internalformat, GLsizei samples, GLenum pname, GLsizei count, GLint *params)
}
