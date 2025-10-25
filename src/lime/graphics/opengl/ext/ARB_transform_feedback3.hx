package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_transform_feedback3
{
	public var MAX_TRANSFORM_FEEDBACK_BUFFERS = 0x8E70;
	public var MAX_VERTEX_STREAMS = 0x8E71;

	@:noCompletion private function new() {}

	// void glDrawTransformFeedbackStream (GLenum mode, GLuint id, GLuint stream)
	// void glBeginQueryIndexed (GLenum target, GLuint index, GLuint id)
	// void glEndQueryIndexed (GLenum target, GLuint index)
	// void glGetQueryIndexediv (GLenum target, GLuint index, GLenum pname, GLint *params)
}
