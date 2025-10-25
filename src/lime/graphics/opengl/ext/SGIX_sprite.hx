package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_sprite
{
	public var SPRITE_SGIX = 0x8148;
	public var SPRITE_MODE_SGIX = 0x8149;
	public var SPRITE_AXIS_SGIX = 0x814A;
	public var SPRITE_TRANSLATION_SGIX = 0x814B;
	public var SPRITE_AXIAL_SGIX = 0x814C;
	public var SPRITE_OBJECT_ALIGNED_SGIX = 0x814D;
	public var SPRITE_EYE_ALIGNED_SGIX = 0x814E;

	@:noCompletion private function new() {}

	// void glSpriteParameterfSGIX (GLenum pname, GLfloat param)
	// void glSpriteParameterfvSGIX (GLenum pname, const GLfloat *params)
	// void glSpriteParameteriSGIX (GLenum pname, GLint param)
	// void glSpriteParameterivSGIX (GLenum pname, const GLint *params)
}
