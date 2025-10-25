package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NVX_linked_gpu_multicast
{
	public var LGPU_SEPARATE_STORAGE_BIT_NVX = 0x0800;
	public var MAX_LGPU_GPUS_NVX = 0x92BA;

	@:noCompletion private function new() {}

	// void glLGPUNamedBufferSubDataNVX (GLbitfield gpuMask, GLuint buffer, GLintptr offset, GLsizeiptr size, const void *data)
	// void glLGPUCopyImageSubDataNVX (GLuint sourceGpu, GLbitfield destinationGpuMask, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srxY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth)
	// void glLGPUInterlockNVX ()
}
