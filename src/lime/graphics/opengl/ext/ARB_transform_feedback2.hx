package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_transform_feedback2
{
	public var TRANSFORM_FEEDBACK = 0x8E22;
	public var TRANSFORM_FEEDBACK_BUFFER_PAUSED = 0x8E23;
	public var TRANSFORM_FEEDBACK_BUFFER_ACTIVE = 0x8E24;
	public var TRANSFORM_FEEDBACK_BINDING = 0x8E25;

	@:noCompletion private function new() {}

	// void glBindTransformFeedback (GLenum target, GLuint id)
	// void glDeleteTransformFeedbacks (GLsizei n, const GLuint *ids)
	// void glGenTransformFeedbacks (GLsizei n, GLuint *ids)
	// GLboolean glIsTransformFeedback (GLuint id)
	// void glPauseTransformFeedback ()
	// void glResumeTransformFeedback ()
	// void glDrawTransformFeedback (GLenum mode, GLuint id)
}
