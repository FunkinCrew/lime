package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_pn_triangles
{
	public var PN_TRIANGLES_ATI = 0x87F0;
	public var MAX_PN_TRIANGLES_TESSELATION_LEVEL_ATI = 0x87F1;
	public var PN_TRIANGLES_POINT_MODE_ATI = 0x87F2;
	public var PN_TRIANGLES_NORMAL_MODE_ATI = 0x87F3;
	public var PN_TRIANGLES_TESSELATION_LEVEL_ATI = 0x87F4;
	public var PN_TRIANGLES_POINT_MODE_LINEAR_ATI = 0x87F5;
	public var PN_TRIANGLES_POINT_MODE_CUBIC_ATI = 0x87F6;
	public var PN_TRIANGLES_NORMAL_MODE_LINEAR_ATI = 0x87F7;
	public var PN_TRIANGLES_NORMAL_MODE_QUADRATIC_ATI = 0x87F8;

	@:noCompletion private function new() {}

	// void glPNTrianglesiATI (GLenum pname, GLint param)
	// void glPNTrianglesfATI (GLenum pname, GLfloat param)
}
