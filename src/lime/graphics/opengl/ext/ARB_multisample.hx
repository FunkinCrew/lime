package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_multisample
{
	public var MULTISAMPLE_ARB = 0x809D;
	public var SAMPLE_ALPHA_TO_COVERAGE_ARB = 0x809E;
	public var SAMPLE_ALPHA_TO_ONE_ARB = 0x809F;
	public var SAMPLE_COVERAGE_ARB = 0x80A0;
	public var SAMPLE_BUFFERS_ARB = 0x80A8;
	public var SAMPLES_ARB = 0x80A9;
	public var SAMPLE_COVERAGE_VALUE_ARB = 0x80AA;
	public var SAMPLE_COVERAGE_INVERT_ARB = 0x80AB;
	public var MULTISAMPLE_BIT_ARB = 0x20000000;

	@:noCompletion private function new() {}

	// void glSampleCoverageARB (GLfloat value, GLboolean invert)
}
