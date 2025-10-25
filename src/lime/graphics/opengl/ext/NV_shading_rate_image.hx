package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_shading_rate_image
{
	public var SHADING_RATE_IMAGE_NV = 0x9563;
	public var SHADING_RATE_NO_INVOCATIONS_NV = 0x9564;
	public var SHADING_RATE_1_INVOCATION_PER_PIXEL_NV = 0x9565;
	public var SHADING_RATE_1_INVOCATION_PER_1X2_PIXELS_NV = 0x9566;
	public var SHADING_RATE_1_INVOCATION_PER_2X1_PIXELS_NV = 0x9567;
	public var SHADING_RATE_1_INVOCATION_PER_2X2_PIXELS_NV = 0x9568;
	public var SHADING_RATE_1_INVOCATION_PER_2X4_PIXELS_NV = 0x9569;
	public var SHADING_RATE_1_INVOCATION_PER_4X2_PIXELS_NV = 0x956A;
	public var SHADING_RATE_1_INVOCATION_PER_4X4_PIXELS_NV = 0x956B;
	public var SHADING_RATE_2_INVOCATIONS_PER_PIXEL_NV = 0x956C;
	public var SHADING_RATE_4_INVOCATIONS_PER_PIXEL_NV = 0x956D;
	public var SHADING_RATE_8_INVOCATIONS_PER_PIXEL_NV = 0x956E;
	public var SHADING_RATE_16_INVOCATIONS_PER_PIXEL_NV = 0x956F;
	public var SHADING_RATE_IMAGE_BINDING_NV = 0x955B;
	public var SHADING_RATE_IMAGE_TEXEL_WIDTH_NV = 0x955C;
	public var SHADING_RATE_IMAGE_TEXEL_HEIGHT_NV = 0x955D;
	public var SHADING_RATE_IMAGE_PALETTE_SIZE_NV = 0x955E;
	public var MAX_COARSE_FRAGMENT_SAMPLES_NV = 0x955F;
	public var SHADING_RATE_SAMPLE_ORDER_DEFAULT_NV = 0x95AE;
	public var SHADING_RATE_SAMPLE_ORDER_PIXEL_MAJOR_NV = 0x95AF;
	public var SHADING_RATE_SAMPLE_ORDER_SAMPLE_MAJOR_NV = 0x95B0;

	@:noCompletion private function new() {}

	// void glBindShadingRateImageNV (GLuint texture)
	// void glGetShadingRateImagePaletteNV (GLuint viewport, GLuint entry, GLenum *rate)
	// void glGetShadingRateSampleLocationivNV (GLenum rate, GLuint samples, GLuint index, GLint *location)
	// void glShadingRateImageBarrierNV (GLboolean synchronize)
	// void glShadingRateImagePaletteNV (GLuint viewport, GLuint first, GLsizei count, const GLenum *rates)
	// void glShadingRateSampleOrderNV (GLenum order)
	// void glShadingRateSampleOrderCustomNV (GLenum rate, GLuint samples, const GLint *locations)
}
