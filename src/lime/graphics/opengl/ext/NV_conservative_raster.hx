package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_conservative_raster
{
	public var CONSERVATIVE_RASTERIZATION_NV = 0x9346;
	public var SUBPIXEL_PRECISION_BIAS_X_BITS_NV = 0x9347;
	public var SUBPIXEL_PRECISION_BIAS_Y_BITS_NV = 0x9348;
	public var MAX_SUBPIXEL_PRECISION_BIAS_BITS_NV = 0x9349;

	@:noCompletion private function new() {}

	// void glSubpixelPrecisionBiasNV (GLuint xbits, GLuint ybits)
}
