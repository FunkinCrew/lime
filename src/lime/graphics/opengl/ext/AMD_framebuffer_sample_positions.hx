package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_framebuffer_sample_positions
{
	public var SUBSAMPLE_DISTANCE_AMD = 0x883F;
	public var PIXELS_PER_SAMPLE_PATTERN_X_AMD = 0x91AE;
	public var PIXELS_PER_SAMPLE_PATTERN_Y_AMD = 0x91AF;
	public var ALL_PIXELS_AMD = 0xFFFFFFFF;

	@:noCompletion private function new() {}

	// void glFramebufferSamplePositionsfvAMD (GLenum target, GLuint numsamples, GLuint pixelindex, const GLfloat *values)
	// void glNamedFramebufferSamplePositionsfvAMD (GLuint framebuffer, GLuint numsamples, GLuint pixelindex, const GLfloat *values)
	// void glGetFramebufferParameterfvAMD (GLenum target, GLenum pname, GLuint numsamples, GLuint pixelindex, GLsizei size, GLfloat *values)
	// void glGetNamedFramebufferParameterfvAMD (GLuint framebuffer, GLenum pname, GLuint numsamples, GLuint pixelindex, GLsizei size, GLfloat *values)
}
