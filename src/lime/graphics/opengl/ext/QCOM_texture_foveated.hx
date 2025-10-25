package lime.graphics.opengl.ext;

@:keep
@:noCompletion class QCOM_texture_foveated
{
	public var FOVEATION_ENABLE_BIT_QCOM = 0x00000001;
	public var FOVEATION_SCALED_BIN_METHOD_BIT_QCOM = 0x00000002;
	public var TEXTURE_FOVEATED_FEATURE_BITS_QCOM = 0x8BFB;
	public var TEXTURE_FOVEATED_MIN_PIXEL_DENSITY_QCOM = 0x8BFC;
	public var TEXTURE_FOVEATED_FEATURE_QUERY_QCOM = 0x8BFD;
	public var TEXTURE_FOVEATED_NUM_FOCAL_POINTS_QUERY_QCOM = 0x8BFE;
	public var FRAMEBUFFER_INCOMPLETE_FOVEATION_QCOM = 0x8BFF;

	@:noCompletion private function new() {}

	// void glTextureFoveationParametersQCOM (GLuint texture, GLuint layer, GLuint focalPoint, GLfloat focalX, GLfloat focalY, GLfloat gainX, GLfloat gainY, GLfloat foveaArea)
}
