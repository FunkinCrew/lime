package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_blend_func_separate
{
	public var BLEND_DST_RGB_EXT = 0x80C8;
	public var BLEND_SRC_RGB_EXT = 0x80C9;
	public var BLEND_DST_ALPHA_EXT = 0x80CA;
	public var BLEND_SRC_ALPHA_EXT = 0x80CB;

	@:noCompletion private function new() {}

	// void glBlendFuncSeparateEXT (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha)
}
