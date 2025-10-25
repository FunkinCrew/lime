package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_detail_texture
{
	public var DETAIL_TEXTURE_2D_SGIS = 0x8095;
	public var DETAIL_TEXTURE_2D_BINDING_SGIS = 0x8096;
	public var LINEAR_DETAIL_SGIS = 0x8097;
	public var LINEAR_DETAIL_ALPHA_SGIS = 0x8098;
	public var LINEAR_DETAIL_COLOR_SGIS = 0x8099;
	public var DETAIL_TEXTURE_LEVEL_SGIS = 0x809A;
	public var DETAIL_TEXTURE_MODE_SGIS = 0x809B;
	public var DETAIL_TEXTURE_FUNC_POINTS_SGIS = 0x809C;

	@:noCompletion private function new() {}

	// void glDetailTexFuncSGIS (GLenum target, GLsizei n, const GLfloat *points)
	// void glGetDetailTexFuncSGIS (GLenum target, GLfloat *points)
}
