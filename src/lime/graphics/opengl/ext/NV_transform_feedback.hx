package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_transform_feedback
{
	public var BACK_PRIMARY_COLOR_NV = 0x8C77;
	public var BACK_SECONDARY_COLOR_NV = 0x8C78;
	public var TEXTURE_COORD_NV = 0x8C79;
	public var CLIP_DISTANCE_NV = 0x8C7A;
	public var VERTEX_ID_NV = 0x8C7B;
	public var PRIMITIVE_ID_NV = 0x8C7C;
	public var GENERIC_ATTRIB_NV = 0x8C7D;
	public var TRANSFORM_FEEDBACK_ATTRIBS_NV = 0x8C7E;
	public var TRANSFORM_FEEDBACK_BUFFER_MODE_NV = 0x8C7F;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_NV = 0x8C80;
	public var ACTIVE_VARYINGS_NV = 0x8C81;
	public var ACTIVE_VARYING_MAX_LENGTH_NV = 0x8C82;
	public var TRANSFORM_FEEDBACK_VARYINGS_NV = 0x8C83;
	public var TRANSFORM_FEEDBACK_BUFFER_START_NV = 0x8C84;
	public var TRANSFORM_FEEDBACK_BUFFER_SIZE_NV = 0x8C85;
	public var TRANSFORM_FEEDBACK_RECORD_NV = 0x8C86;
	public var PRIMITIVES_GENERATED_NV = 0x8C87;
	public var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV = 0x8C88;
	public var RASTERIZER_DISCARD_NV = 0x8C89;
	public var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_NV = 0x8C8A;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_NV = 0x8C8B;
	public var INTERLEAVED_ATTRIBS_NV = 0x8C8C;
	public var SEPARATE_ATTRIBS_NV = 0x8C8D;
	public var TRANSFORM_FEEDBACK_BUFFER_NV = 0x8C8E;
	public var TRANSFORM_FEEDBACK_BUFFER_BINDING_NV = 0x8C8F;
	public var LAYER_NV = 0x8DAA;

	@:noCompletion private function new() {}

	// void glBeginTransformFeedbackNV (GLenum primitiveMode)
	// void glEndTransformFeedbackNV ()
	// void glTransformFeedbackAttribsNV (GLsizei count, const GLint *attribs, GLenum bufferMode)
	// void glBindBufferRangeNV (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size)
	// void glBindBufferOffsetNV (GLenum target, GLuint index, GLuint buffer, GLintptr offset)
	// void glBindBufferBaseNV (GLenum target, GLuint index, GLuint buffer)
	// void glTransformFeedbackVaryingsNV (GLuint program, GLsizei count, const GLint *locations, GLenum bufferMode)
	// void glActiveVaryingNV (GLuint program, const GLchar *name)
	// GLint glGetVaryingLocationNV (GLuint program, const GLchar *name)
	// void glGetActiveVaryingNV (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name)
	// void glGetTransformFeedbackVaryingNV (GLuint program, GLuint index, GLint *location)
}
