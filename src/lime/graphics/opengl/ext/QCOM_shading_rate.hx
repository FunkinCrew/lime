package lime.graphics.opengl.ext;

@:keep
@:noCompletion class QCOM_shading_rate
{
	public var SHADING_RATE_QCOM = 0x96A4;
	public var SHADING_RATE_PRESERVE_ASPECT_RATIO_QCOM = 0x96A5;
	public var SHADING_RATE_1X1_PIXELS_QCOM = 0x96A6;
	public var SHADING_RATE_1X2_PIXELS_QCOM = 0x96A7;
	public var SHADING_RATE_2X1_PIXELS_QCOM = 0x96A8;
	public var SHADING_RATE_2X2_PIXELS_QCOM = 0x96A9;
	public var SHADING_RATE_4X2_PIXELS_QCOM = 0x96AC;
	public var SHADING_RATE_4X4_PIXELS_QCOM = 0x96AE;

	@:noCompletion private function new() {}

	// void glShadingRateQCOM (GLenum rate)
}
