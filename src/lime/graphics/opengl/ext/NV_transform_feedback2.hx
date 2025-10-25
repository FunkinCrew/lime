package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_transform_feedback2
{
	public var TRANSFORM_FEEDBACK_NV = 0x8E22;
	public var TRANSFORM_FEEDBACK_BUFFER_PAUSED_NV = 0x8E23;
	public var TRANSFORM_FEEDBACK_BUFFER_ACTIVE_NV = 0x8E24;
	public var TRANSFORM_FEEDBACK_BINDING_NV = 0x8E25;

	@:noCompletion private function new() {}

	// void glBindTransformFeedbackNV (GLenum target, GLuint id)
	// void glDeleteTransformFeedbacksNV (GLsizei n, const GLuint *ids)
	// void glGenTransformFeedbacksNV (GLsizei n, GLuint *ids)
	// GLboolean glIsTransformFeedbackNV (GLuint id)
	// void glPauseTransformFeedbackNV ()
	// void glResumeTransformFeedbackNV ()
	// void glDrawTransformFeedbackNV (GLenum mode, GLuint id)
}
