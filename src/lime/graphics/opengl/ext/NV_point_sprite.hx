package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_point_sprite
{
	public var POINT_SPRITE_NV = 0x8861;
	public var COORD_REPLACE_NV = 0x8862;
	public var POINT_SPRITE_R_MODE_NV = 0x8863;

	@:noCompletion private function new() {}

	// void glPointParameteriNV (GLenum pname, GLint param)
	// void glPointParameterivNV (GLenum pname, const GLint *params)
}
