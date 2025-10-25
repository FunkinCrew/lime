package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_sample_locations
{
	public var SAMPLE_LOCATION_SUBPIXEL_BITS_NV = 0x933D;
	public var SAMPLE_LOCATION_PIXEL_GRID_WIDTH_NV = 0x933E;
	public var SAMPLE_LOCATION_PIXEL_GRID_HEIGHT_NV = 0x933F;
	public var PROGRAMMABLE_SAMPLE_LOCATION_TABLE_SIZE_NV = 0x9340;
	public var SAMPLE_LOCATION_NV = 0x8E50;
	public var PROGRAMMABLE_SAMPLE_LOCATION_NV = 0x9341;
	public var FRAMEBUFFER_PROGRAMMABLE_SAMPLE_LOCATIONS_NV = 0x9342;
	public var FRAMEBUFFER_SAMPLE_LOCATION_PIXEL_GRID_NV = 0x9343;

	@:noCompletion private function new() {}

	// void glFramebufferSampleLocationsfvNV (GLenum target, GLuint start, GLsizei count, const GLfloat *v)
	// void glNamedFramebufferSampleLocationsfvNV (GLuint framebuffer, GLuint start, GLsizei count, const GLfloat *v)
	// void glResolveDepthValuesNV ()
}
