package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_async
{
	public var ASYNC_MARKER_SGIX = 0x8329;

	@:noCompletion private function new() {}

	// void glAsyncMarkerSGIX (GLuint marker)
	// GLint glFinishAsyncSGIX (GLuint *markerp)
	// GLint glPollAsyncSGIX (GLuint *markerp)
	// GLuint glGenAsyncMarkersSGIX (GLsizei range)
	// void glDeleteAsyncMarkersSGIX (GLuint marker, GLsizei range)
	// GLboolean glIsAsyncMarkerSGIX (GLuint marker)
}
