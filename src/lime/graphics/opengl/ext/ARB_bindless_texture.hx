package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_bindless_texture
{
	public var UNSIGNED_INT64_ARB = 0x140F;

	@:noCompletion private function new() {}

	// GLuint64 glGetTextureHandleARB (GLuint texture)
	// GLuint64 glGetTextureSamplerHandleARB (GLuint texture, GLuint sampler)
	// void glMakeTextureHandleResidentARB (GLuint64 handle)
	// void glMakeTextureHandleNonResidentARB (GLuint64 handle)
	// GLuint64 glGetImageHandleARB (GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum format)
	// void glMakeImageHandleResidentARB (GLuint64 handle, GLenum access)
	// void glMakeImageHandleNonResidentARB (GLuint64 handle)
	// void glUniformHandleui64ARB (GLint location, GLuint64 value)
	// void glUniformHandleui64vARB (GLint location, GLsizei count, const GLuint64 *value)
	// void glProgramUniformHandleui64ARB (GLuint program, GLint location, GLuint64 value)
	// void glProgramUniformHandleui64vARB (GLuint program, GLint location, GLsizei count, const GLuint64 *values)
	// GLboolean glIsTextureHandleResidentARB (GLuint64 handle)
	// GLboolean glIsImageHandleResidentARB (GLuint64 handle)
	// void glVertexAttribL1ui64ARB (GLuint index, GLuint64EXT x)
	// void glVertexAttribL1ui64vARB (GLuint index, const GLuint64EXT *v)
	// void glGetVertexAttribLui64vARB (GLuint index, GLenum pname, GLuint64EXT *params)
}
