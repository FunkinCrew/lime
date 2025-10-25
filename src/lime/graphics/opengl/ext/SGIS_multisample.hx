package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_multisample
{
	public var MULTISAMPLE_SGIS = 0x809D;
	public var SAMPLE_ALPHA_TO_MASK_SGIS = 0x809E;
	public var SAMPLE_ALPHA_TO_ONE_SGIS = 0x809F;
	public var SAMPLE_MASK_SGIS = 0x80A0;
	public var _1PASS_SGIS = 0x80A1;
	public var _2PASS_0_SGIS = 0x80A2;
	public var _2PASS_1_SGIS = 0x80A3;
	public var _4PASS_0_SGIS = 0x80A4;
	public var _4PASS_1_SGIS = 0x80A5;
	public var _4PASS_2_SGIS = 0x80A6;
	public var _4PASS_3_SGIS = 0x80A7;
	public var SAMPLE_BUFFERS_SGIS = 0x80A8;
	public var SAMPLES_SGIS = 0x80A9;
	public var SAMPLE_MASK_VALUE_SGIS = 0x80AA;
	public var SAMPLE_MASK_INVERT_SGIS = 0x80AB;
	public var SAMPLE_PATTERN_SGIS = 0x80AC;

	@:noCompletion private function new() {}

	// void glSampleMaskSGIS (GLclampf value, GLboolean invert)
	// void glSamplePatternSGIS (GLenum pattern)
}
