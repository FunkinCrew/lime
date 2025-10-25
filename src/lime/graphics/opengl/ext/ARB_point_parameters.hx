package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_point_parameters
{
	public var POINT_SIZE_MIN_ARB = 0x8126;
	public var POINT_SIZE_MAX_ARB = 0x8127;
	public var POINT_FADE_THRESHOLD_SIZE_ARB = 0x8128;
	public var POINT_DISTANCE_ATTENUATION_ARB = 0x8129;

	@:noCompletion private function new() {}

	// void glPointParameterfARB (GLenum pname, GLfloat param)
	// void glPointParameterfvARB (GLenum pname, const GLfloat *params)
}
