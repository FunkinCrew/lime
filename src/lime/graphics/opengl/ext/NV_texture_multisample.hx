package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_texture_multisample
{
	public var TEXTURE_COVERAGE_SAMPLES_NV = 0x9045;
	public var TEXTURE_COLOR_SAMPLES_NV = 0x9046;

	@:noCompletion private function new() {}

	// void glTexImage2DMultisampleCoverageNV (GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLint internalFormat, GLsizei width, GLsizei height, GLboolean fixedSampleLocations)
	// void glTexImage3DMultisampleCoverageNV (GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLint internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedSampleLocations)
}
