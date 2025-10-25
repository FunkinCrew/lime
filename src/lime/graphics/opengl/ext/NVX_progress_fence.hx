package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NVX_progress_fence
{
	@:noCompletion private function new() {}

	// GLuint glCreateProgressFenceNVX ()
	// void glSignalSemaphoreui64NVX (GLuint signalGpu, GLsizei fenceObjectCount, const GLuint *semaphoreArray, const GLuint64 *fenceValueArray)
	// void glWaitSemaphoreui64NVX (GLuint waitGpu, GLsizei fenceObjectCount, const GLuint *semaphoreArray, const GLuint64 *fenceValueArray)
	// void glClientWaitSemaphoreui64NVX (GLsizei fenceObjectCount, const GLuint *semaphoreArray, const GLuint64 *fenceValueArray)
}
