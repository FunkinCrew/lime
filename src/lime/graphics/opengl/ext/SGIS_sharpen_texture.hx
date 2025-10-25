package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_sharpen_texture
{
	public var LINEAR_SHARPEN_SGIS = 0x80AD;
	public var LINEAR_SHARPEN_ALPHA_SGIS = 0x80AE;
	public var LINEAR_SHARPEN_COLOR_SGIS = 0x80AF;
	public var SHARPEN_TEXTURE_FUNC_POINTS_SGIS = 0x80B0;

	@:noCompletion private function new() {}

	// void glSharpenTexFuncSGIS (GLenum target, GLsizei n, const GLfloat *points)
	// void glGetSharpenTexFuncSGIS (GLenum target, GLfloat *points)
}
