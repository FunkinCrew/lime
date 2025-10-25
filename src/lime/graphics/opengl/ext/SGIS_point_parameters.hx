package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_point_parameters
{
	public var POINT_SIZE_MIN_SGIS = 0x8126;
	public var POINT_SIZE_MAX_SGIS = 0x8127;
	public var POINT_FADE_THRESHOLD_SIZE_SGIS = 0x8128;
	public var DISTANCE_ATTENUATION_SGIS = 0x8129;

	@:noCompletion private function new() {}

	// void glPointParameterfSGIS (GLenum pname, GLfloat param)
	// void glPointParameterfvSGIS (GLenum pname, const GLfloat *params)
}
