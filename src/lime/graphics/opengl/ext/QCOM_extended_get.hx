package lime.graphics.opengl.ext;

@:keep
@:noCompletion class QCOM_extended_get
{
	public var TEXTURE_WIDTH_QCOM = 0x8BD2;
	public var TEXTURE_HEIGHT_QCOM = 0x8BD3;
	public var TEXTURE_DEPTH_QCOM = 0x8BD4;
	public var TEXTURE_INTERNAL_FORMAT_QCOM = 0x8BD5;
	public var TEXTURE_FORMAT_QCOM = 0x8BD6;
	public var TEXTURE_TYPE_QCOM = 0x8BD7;
	public var TEXTURE_IMAGE_VALID_QCOM = 0x8BD8;
	public var TEXTURE_NUM_LEVELS_QCOM = 0x8BD9;
	public var TEXTURE_TARGET_QCOM = 0x8BDA;
	public var TEXTURE_OBJECT_VALID_QCOM = 0x8BDB;
	public var STATE_RESTORE = 0x8BDC;

	@:noCompletion private function new() {}

	// void glExtGetTexturesQCOM (GLuint *textures, GLint maxTextures, GLint *numTextures)
	// void glExtGetBuffersQCOM (GLuint *buffers, GLint maxBuffers, GLint *numBuffers)
	// void glExtGetRenderbuffersQCOM (GLuint *renderbuffers, GLint maxRenderbuffers, GLint *numRenderbuffers)
	// void glExtGetFramebuffersQCOM (GLuint *framebuffers, GLint maxFramebuffers, GLint *numFramebuffers)
	// void glExtGetTexLevelParameterivQCOM (GLuint texture, GLenum face, GLint level, GLenum pname, GLint *params)
	// void glExtTexObjectStateOverrideiQCOM (GLenum target, GLenum pname, GLint param)
	// void glExtGetTexSubImageQCOM (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, void *texels)
	// void glExtGetBufferPointervQCOM (GLenum target, void **params)
}
