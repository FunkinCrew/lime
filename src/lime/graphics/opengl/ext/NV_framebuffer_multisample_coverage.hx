package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_framebuffer_multisample_coverage
{
	public var RENDERBUFFER_COVERAGE_SAMPLES_NV = 0x8CAB;
	public var RENDERBUFFER_COLOR_SAMPLES_NV = 0x8E10;
	public var MAX_MULTISAMPLE_COVERAGE_MODES_NV = 0x8E11;
	public var MULTISAMPLE_COVERAGE_MODES_NV = 0x8E12;

	@:noCompletion private function new() {}

	// void glRenderbufferStorageMultisampleCoverageNV (GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height)
}
