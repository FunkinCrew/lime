package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_gpu_multicast
{
	public var PER_GPU_STORAGE_BIT_NV = 0x0800;
	public var MULTICAST_GPUS_NV = 0x92BA;
	public var RENDER_GPU_MASK_NV = 0x9558;
	public var PER_GPU_STORAGE_NV = 0x9548;
	public var MULTICAST_PROGRAMMABLE_SAMPLE_LOCATION_NV = 0x9549;

	@:noCompletion private function new() {}

	// void glRenderGpuMaskNV (GLbitfield mask)
	// void glMulticastBufferSubDataNV (GLbitfield gpuMask, GLuint buffer, GLintptr offset, GLsizeiptr size, const void *data)
	// void glMulticastCopyBufferSubDataNV (GLuint readGpu, GLbitfield writeGpuMask, GLuint readBuffer, GLuint writeBuffer, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size)
	// void glMulticastCopyImageSubDataNV (GLuint srcGpu, GLbitfield dstGpuMask, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei srcWidth, GLsizei srcHeight, GLsizei srcDepth)
	// void glMulticastBlitFramebufferNV (GLuint srcGpu, GLuint dstGpu, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter)
	// void glMulticastFramebufferSampleLocationsfvNV (GLuint gpu, GLuint framebuffer, GLuint start, GLsizei count, const GLfloat *v)
	// void glMulticastBarrierNV ()
	// void glMulticastWaitSyncNV (GLuint signalGpu, GLbitfield waitGpuMask)
	// void glMulticastGetQueryObjectivNV (GLuint gpu, GLuint id, GLenum pname, GLint *params)
	// void glMulticastGetQueryObjectuivNV (GLuint gpu, GLuint id, GLenum pname, GLuint *params)
	// void glMulticastGetQueryObjecti64vNV (GLuint gpu, GLuint id, GLenum pname, GLint64 *params)
	// void glMulticastGetQueryObjectui64vNV (GLuint gpu, GLuint id, GLenum pname, GLuint64 *params)
}
