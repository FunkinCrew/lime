package lime.graphics.opengl.ext;

@:keep
@:noCompletion class QCOM_motion_estimation
{
	public var MOTION_ESTIMATION_SEARCH_BLOCK_X_QCOM = 0x8C90;
	public var MOTION_ESTIMATION_SEARCH_BLOCK_Y_QCOM = 0x8C91;
	public var FOVEATION_SCALED_BIN_METHOD_BIT_QCOM = 0x00000002;

	@:noCompletion private function new() {}

	// void glTexEstimateMotionQCOM (GLuint ref, GLuint target, GLuint output)
	// void glTexEstimateMotionRegionsQCOM (GLuint ref, GLuint target, GLuint output, GLuint mask)
}
