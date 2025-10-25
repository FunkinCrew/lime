package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NVX_gpu_multicast2
{
	public var UPLOAD_GPU_MASK_NVX = 0x954A;

	@:noCompletion private function new() {}

	// void glUploadGpuMaskNVX (GLbitfield mask)
	// void glMulticastViewportArrayvNVX (GLuint gpu, GLuint first, GLsizei count, const GLfloat *v)
	// void glMulticastViewportPositionWScaleNVX (GLuint gpu, GLuint index, GLfloat xcoeff, GLfloat ycoeff)
	// void glMulticastScissorArrayvNVX (GLuint gpu, GLuint first, GLsizei count, const GLint *v)
	// GLuint glAsyncCopyBufferSubDataNVX (GLsizei waitSemaphoreCount, const GLuint *waitSemaphoreArray, const GLuint64 *fenceValueArray, GLuint readGpu, GLbitfield writeGpuMask, GLuint readBuffer, GLuint writeBuffer, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size, GLsizei signalSemaphoreCount, const GLuint *signalSemaphoreArray, const GLuint64 *signalValueArray)
	// GLuint glAsyncCopyImageSubDataNVX (GLsizei waitSemaphoreCount, const GLuint *waitSemaphoreArray, const GLuint64 *waitValueArray, GLuint srcGpu, GLbitfield dstGpuMask, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei srcWidth, GLsizei srcHeight, GLsizei srcDepth, GLsizei signalSemaphoreCount, const GLuint *signalSemaphoreArray, const GLuint64 *signalValueArray)
}
