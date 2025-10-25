package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_sample_locations
{
	public var SAMPLE_LOCATION_SUBPIXEL_BITS_ARB = 0x933D;
	public var SAMPLE_LOCATION_PIXEL_GRID_WIDTH_ARB = 0x933E;
	public var SAMPLE_LOCATION_PIXEL_GRID_HEIGHT_ARB = 0x933F;
	public var PROGRAMMABLE_SAMPLE_LOCATION_TABLE_SIZE_ARB = 0x9340;
	public var SAMPLE_LOCATION_ARB = 0x8E50;
	public var PROGRAMMABLE_SAMPLE_LOCATION_ARB = 0x9341;
	public var FRAMEBUFFER_PROGRAMMABLE_SAMPLE_LOCATIONS_ARB = 0x9342;
	public var FRAMEBUFFER_SAMPLE_LOCATION_PIXEL_GRID_ARB = 0x9343;

	@:noCompletion private function new() {}

	// void glFramebufferSampleLocationsfvARB (GLenum target, GLuint start, GLsizei count, const GLfloat *v)
	// void glNamedFramebufferSampleLocationsfvARB (GLuint framebuffer, GLuint start, GLsizei count, const GLfloat *v)
	// void glEvaluateDepthValuesARB ()
}
