package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_fog_function
{
	public var FOG_FUNC_SGIS = 0x812A;
	public var FOG_FUNC_POINTS_SGIS = 0x812B;
	public var MAX_FOG_FUNC_POINTS_SGIS = 0x812C;

	@:noCompletion private function new() {}

	// void glFogFuncSGIS (GLsizei n, const GLfloat *points)
	// void glGetFogFuncSGIS (GLfloat *points)
}
