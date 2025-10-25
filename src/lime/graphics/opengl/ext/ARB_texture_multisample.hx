package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_texture_multisample
{
	public var SAMPLE_POSITION = 0x8E50;
	public var SAMPLE_MASK = 0x8E51;
	public var SAMPLE_MASK_VALUE = 0x8E52;
	public var MAX_SAMPLE_MASK_WORDS = 0x8E59;
	public var TEXTURE_2D_MULTISAMPLE = 0x9100;
	public var PROXY_TEXTURE_2D_MULTISAMPLE = 0x9101;
	public var TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9102;
	public var PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103;
	public var TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104;
	public var TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105;
	public var TEXTURE_SAMPLES = 0x9106;
	public var TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107;
	public var SAMPLER_2D_MULTISAMPLE = 0x9108;
	public var INT_SAMPLER_2D_MULTISAMPLE = 0x9109;
	public var UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910A;
	public var SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910B;
	public var INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910C;
	public var UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D;
	public var MAX_COLOR_TEXTURE_SAMPLES = 0x910E;
	public var MAX_DEPTH_TEXTURE_SAMPLES = 0x910F;
	public var MAX_INTEGER_SAMPLES = 0x9110;

	@:noCompletion private function new() {}

	// void glTexImage2DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations)
	// void glTexImage3DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations)
	// void glGetMultisamplefv (GLenum pname, GLuint index, GLfloat *val)
	// void glSampleMaski (GLuint maskNumber, GLbitfield mask)
}
