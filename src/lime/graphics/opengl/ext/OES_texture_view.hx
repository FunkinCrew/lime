package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_texture_view
{
	public var TEXTURE_VIEW_MIN_LEVEL_OES = 0x82DB;
	public var TEXTURE_VIEW_NUM_LEVELS_OES = 0x82DC;
	public var TEXTURE_VIEW_MIN_LAYER_OES = 0x82DD;
	public var TEXTURE_VIEW_NUM_LAYERS_OES = 0x82DE;
	public var TEXTURE_IMMUTABLE_LEVELS = 0x82DF;

	@:noCompletion private function new() {}

	// void glTextureViewOES (GLuint texture, GLenum target, GLuint origtexture, GLenum internalformat, GLuint minlevel, GLuint numlevels, GLuint minlayer, GLuint numlayers)
}
