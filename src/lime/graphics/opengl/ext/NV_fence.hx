package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_fence
{
	public var ALL_COMPLETED_NV = 0x84F2;
	public var FENCE_STATUS_NV = 0x84F3;
	public var FENCE_CONDITION_NV = 0x84F4;

	@:noCompletion private function new() {}

	// void glDeleteFencesNV (GLsizei n, const GLuint *fences)
	// void glGenFencesNV (GLsizei n, GLuint *fences)
	// GLboolean glIsFenceNV (GLuint fence)
	// GLboolean glTestFenceNV (GLuint fence)
	// void glGetFenceivNV (GLuint fence, GLenum pname, GLint *params)
	// void glFinishFenceNV (GLuint fence)
	// void glSetFenceNV (GLuint fence, GLenum condition)
}
