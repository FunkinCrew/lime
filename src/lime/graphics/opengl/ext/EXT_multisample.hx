package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_multisample
{
	public var MULTISAMPLE_EXT = 0x809D;
	public var SAMPLE_ALPHA_TO_MASK_EXT = 0x809E;
	public var SAMPLE_ALPHA_TO_ONE_EXT = 0x809F;
	public var SAMPLE_MASK_EXT = 0x80A0;
	public var _1PASS_EXT = 0x80A1;
	public var _2PASS_0_EXT = 0x80A2;
	public var _2PASS_1_EXT = 0x80A3;
	public var _4PASS_0_EXT = 0x80A4;
	public var _4PASS_1_EXT = 0x80A5;
	public var _4PASS_2_EXT = 0x80A6;
	public var _4PASS_3_EXT = 0x80A7;
	public var SAMPLE_BUFFERS_EXT = 0x80A8;
	public var SAMPLES_EXT = 0x80A9;
	public var SAMPLE_MASK_VALUE_EXT = 0x80AA;
	public var SAMPLE_MASK_INVERT_EXT = 0x80AB;
	public var SAMPLE_PATTERN_EXT = 0x80AC;
	public var MULTISAMPLE_BIT_EXT = 0x20000000;

	@:noCompletion private function new() {}

	// void glSampleMaskEXT (GLclampf value, GLboolean invert)
	// void glSamplePatternEXT (GLenum pattern)
}
