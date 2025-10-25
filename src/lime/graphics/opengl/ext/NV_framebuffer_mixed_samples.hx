package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_framebuffer_mixed_samples
{
	public var RASTER_MULTISAMPLE_EXT = 0x9327;
	public var COVERAGE_MODULATION_TABLE_NV = 0x9331;
	public var RASTER_SAMPLES_EXT = 0x9328;
	public var MAX_RASTER_SAMPLES_EXT = 0x9329;
	public var RASTER_FIXED_SAMPLE_LOCATIONS_EXT = 0x932A;
	public var MULTISAMPLE_RASTERIZATION_ALLOWED_EXT = 0x932B;
	public var EFFECTIVE_RASTER_SAMPLES_EXT = 0x932C;
	public var COLOR_SAMPLES_NV = 0x8E20;
	public var DEPTH_SAMPLES_NV = 0x932D;
	public var STENCIL_SAMPLES_NV = 0x932E;
	public var MIXED_DEPTH_SAMPLES_SUPPORTED_NV = 0x932F;
	public var MIXED_STENCIL_SAMPLES_SUPPORTED_NV = 0x9330;
	public var COVERAGE_MODULATION_NV = 0x9332;
	public var COVERAGE_MODULATION_TABLE_SIZE_NV = 0x9333;

	@:noCompletion private function new() {}

	// void glRasterSamplesEXT (GLuint samples, GLboolean fixedsamplelocations)
	// void glCoverageModulationTableNV (GLsizei n, const GLfloat *v)
	// void glGetCoverageModulationTableNV (GLsizei bufSize, GLfloat *v)
	// void glCoverageModulationNV (GLenum components)
}
