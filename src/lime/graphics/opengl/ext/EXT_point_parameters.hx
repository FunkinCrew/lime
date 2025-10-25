package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_point_parameters
{
	public var POINT_SIZE_MIN_EXT = 0x8126;
	public var POINT_SIZE_MAX_EXT = 0x8127;
	public var POINT_FADE_THRESHOLD_SIZE_EXT = 0x8128;
	public var DISTANCE_ATTENUATION_EXT = 0x8129;

	@:noCompletion private function new() {}

	// void glPointParameterfEXT (GLenum pname, GLfloat param)
	// void glPointParameterfvEXT (GLenum pname, const GLfloat *params)
}
