package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_explicit_multisample
{
	public var SAMPLE_POSITION_NV = 0x8E50;
	public var SAMPLE_MASK_NV = 0x8E51;
	public var SAMPLE_MASK_VALUE_NV = 0x8E52;
	public var TEXTURE_BINDING_RENDERBUFFER_NV = 0x8E53;
	public var TEXTURE_RENDERBUFFER_DATA_STORE_BINDING_NV = 0x8E54;
	public var TEXTURE_RENDERBUFFER_NV = 0x8E55;
	public var SAMPLER_RENDERBUFFER_NV = 0x8E56;
	public var INT_SAMPLER_RENDERBUFFER_NV = 0x8E57;
	public var UNSIGNED_INT_SAMPLER_RENDERBUFFER_NV = 0x8E58;
	public var MAX_SAMPLE_MASK_WORDS_NV = 0x8E59;

	@:noCompletion private function new() {}

	// void glGetMultisamplefvNV (GLenum pname, GLuint index, GLfloat *val)
	// void glSampleMaskIndexedNV (GLuint index, GLbitfield mask)
	// void glTexRenderbufferNV (GLenum target, GLuint renderbuffer)
}
