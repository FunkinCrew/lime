package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_raster_multisample
{
	public var RASTER_MULTISAMPLE_EXT = 0x9327;
	public var RASTER_SAMPLES_EXT = 0x9328;
	public var MAX_RASTER_SAMPLES_EXT = 0x9329;
	public var RASTER_FIXED_SAMPLE_LOCATIONS_EXT = 0x932A;
	public var MULTISAMPLE_RASTERIZATION_ALLOWED_EXT = 0x932B;
	public var EFFECTIVE_RASTER_SAMPLES_EXT = 0x932C;

	@:noCompletion private function new() {}

	// void glRasterSamplesEXT (GLuint samples, GLboolean fixedsamplelocations)
}
