package lime.graphics.opengl.ext;

@:keep
@:noCompletion class QCOM_framebuffer_foveated
{
	public var FOVEATION_ENABLE_BIT_QCOM = 0x00000001;
	public var FOVEATION_SCALED_BIN_METHOD_BIT_QCOM = 0x00000002;

	@:noCompletion private function new() {}

	// void glFramebufferFoveationConfigQCOM (GLuint framebuffer, GLuint numLayers, GLuint focalPointsPerLayer, GLuint requestedFeatures, GLuint *providedFeatures)
	// void glFramebufferFoveationParametersQCOM (GLuint framebuffer, GLuint layer, GLuint focalPoint, GLfloat focalX, GLfloat focalY, GLfloat gainX, GLfloat gainY, GLfloat foveaArea)
}
