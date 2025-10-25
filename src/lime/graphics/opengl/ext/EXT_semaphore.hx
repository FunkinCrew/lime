package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_semaphore
{
	public var NUM_DEVICE_UUIDS_EXT = 0x9596;
	public var DEVICE_UUID_EXT = 0x9597;
	public var DRIVER_UUID_EXT = 0x9598;
	public var UUID_SIZE_EXT = 16;
	public var LAYOUT_GENERAL_EXT = 0x958D;
	public var LAYOUT_COLOR_ATTACHMENT_EXT = 0x958E;
	public var LAYOUT_DEPTH_STENCIL_ATTACHMENT_EXT = 0x958F;
	public var LAYOUT_DEPTH_STENCIL_READ_ONLY_EXT = 0x9590;
	public var LAYOUT_SHADER_READ_ONLY_EXT = 0x9591;
	public var LAYOUT_TRANSFER_SRC_EXT = 0x9592;
	public var LAYOUT_TRANSFER_DST_EXT = 0x9593;
	public var LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_EXT = 0x9530;
	public var LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_EXT = 0x9531;

	@:noCompletion private function new() {}

	// void glGetUnsignedBytevEXT (GLenum pname, GLubyte *data)
	// void glGetUnsignedBytei_vEXT (GLenum target, GLuint index, GLubyte *data)
	// void glGenSemaphoresEXT (GLsizei n, GLuint *semaphores)
	// void glDeleteSemaphoresEXT (GLsizei n, const GLuint *semaphores)
	// GLboolean glIsSemaphoreEXT (GLuint semaphore)
	// void glSemaphoreParameterui64vEXT (GLuint semaphore, GLenum pname, const GLuint64 *params)
	// void glGetSemaphoreParameterui64vEXT (GLuint semaphore, GLenum pname, GLuint64 *params)
	// void glWaitSemaphoreEXT (GLuint semaphore, GLuint numBufferBarriers, const GLuint *buffers, GLuint numTextureBarriers, const GLuint *textures, const GLenum *srcLayouts)
	// void glSignalSemaphoreEXT (GLuint semaphore, GLuint numBufferBarriers, const GLuint *buffers, GLuint numTextureBarriers, const GLuint *textures, const GLenum *dstLayouts)
}
