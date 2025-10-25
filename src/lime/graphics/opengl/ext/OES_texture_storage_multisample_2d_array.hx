package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_texture_storage_multisample_2d_array
{
	public var TEXTURE_2D_MULTISAMPLE_ARRAY_OES = 0x9102;
	public var TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY_OES = 0x9105;
	public var SAMPLER_2D_MULTISAMPLE_ARRAY_OES = 0x910B;
	public var INT_SAMPLER_2D_MULTISAMPLE_ARRAY_OES = 0x910C;
	public var UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY_OES = 0x910D;

	@:noCompletion private function new() {}

	// void glTexStorage3DMultisampleOES (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations)
}
