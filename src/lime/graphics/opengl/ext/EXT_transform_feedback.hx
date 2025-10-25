package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_transform_feedback
{
	public var TRANSFORM_FEEDBACK_BUFFER_EXT = 0x8C8E;
	public var TRANSFORM_FEEDBACK_BUFFER_START_EXT = 0x8C84;
	public var TRANSFORM_FEEDBACK_BUFFER_SIZE_EXT = 0x8C85;
	public var TRANSFORM_FEEDBACK_BUFFER_BINDING_EXT = 0x8C8F;
	public var INTERLEAVED_ATTRIBS_EXT = 0x8C8C;
	public var SEPARATE_ATTRIBS_EXT = 0x8C8D;
	public var PRIMITIVES_GENERATED_EXT = 0x8C87;
	public var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_EXT = 0x8C88;
	public var RASTERIZER_DISCARD_EXT = 0x8C89;
	public var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_EXT = 0x8C8A;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_EXT = 0x8C8B;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_EXT = 0x8C80;
	public var TRANSFORM_FEEDBACK_VARYINGS_EXT = 0x8C83;
	public var TRANSFORM_FEEDBACK_BUFFER_MODE_EXT = 0x8C7F;
	public var TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH_EXT = 0x8C76;

	@:noCompletion private function new() {}

	// void glBeginTransformFeedbackEXT (GLenum primitiveMode)
	// void glEndTransformFeedbackEXT ()
	// void glBindBufferRangeEXT (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size)
	// void glBindBufferOffsetEXT (GLenum target, GLuint index, GLuint buffer, GLintptr offset)
	// void glBindBufferBaseEXT (GLenum target, GLuint index, GLuint buffer)
	// void glTransformFeedbackVaryingsEXT (GLuint program, GLsizei count, const GLchar *const*varyings, GLenum bufferMode)
	// void glGetTransformFeedbackVaryingEXT (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name)
}
