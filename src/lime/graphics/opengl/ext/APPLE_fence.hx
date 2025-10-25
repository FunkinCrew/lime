package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_fence
{
	public var DRAW_PIXELS_APPLE = 0x8A0A;
	public var FENCE_APPLE = 0x8A0B;

	@:noCompletion private function new() {}

	// void glGenFencesAPPLE (GLsizei n, GLuint *fences)
	// void glDeleteFencesAPPLE (GLsizei n, const GLuint *fences)
	// void glSetFenceAPPLE (GLuint fence)
	// GLboolean glIsFenceAPPLE (GLuint fence)
	// GLboolean glTestFenceAPPLE (GLuint fence)
	// void glFinishFenceAPPLE (GLuint fence)
	// GLboolean glTestObjectAPPLE (GLenum object, GLuint name)
	// void glFinishObjectAPPLE (GLenum object, GLint name)
}
