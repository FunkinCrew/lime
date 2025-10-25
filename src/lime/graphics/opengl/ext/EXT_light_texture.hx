package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_light_texture
{
	public var FRAGMENT_MATERIAL_EXT = 0x8349;
	public var FRAGMENT_NORMAL_EXT = 0x834A;
	public var FRAGMENT_COLOR_EXT = 0x834C;
	public var ATTENUATION_EXT = 0x834D;
	public var SHADOW_ATTENUATION_EXT = 0x834E;
	public var TEXTURE_APPLICATION_MODE_EXT = 0x834F;
	public var TEXTURE_LIGHT_EXT = 0x8350;
	public var TEXTURE_MATERIAL_FACE_EXT = 0x8351;
	public var TEXTURE_MATERIAL_PARAMETER_EXT = 0x8352;
	public var FRAGMENT_DEPTH_EXT = 0x8452;

	@:noCompletion private function new() {}

	// void glApplyTextureEXT (GLenum mode)
	// void glTextureLightEXT (GLenum pname)
	// void glTextureMaterialEXT (GLenum face, GLenum mode)
}
