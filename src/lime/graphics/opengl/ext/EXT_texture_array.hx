package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture_array
{
	public var TEXTURE_1D_ARRAY_EXT = 0x8C18;
	public var PROXY_TEXTURE_1D_ARRAY_EXT = 0x8C19;
	public var TEXTURE_2D_ARRAY_EXT = 0x8C1A;
	public var PROXY_TEXTURE_2D_ARRAY_EXT = 0x8C1B;
	public var TEXTURE_BINDING_1D_ARRAY_EXT = 0x8C1C;
	public var TEXTURE_BINDING_2D_ARRAY_EXT = 0x8C1D;
	public var MAX_ARRAY_TEXTURE_LAYERS_EXT = 0x88FF;
	public var COMPARE_REF_DEPTH_TO_TEXTURE_EXT = 0x884E;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT = 0x8CD4;

	@:noCompletion private function new() {}

	// void glFramebufferTextureLayerEXT (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer)
}
