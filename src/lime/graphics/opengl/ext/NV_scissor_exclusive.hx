package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_scissor_exclusive
{
	public var SCISSOR_TEST_EXCLUSIVE_NV = 0x9555;
	public var SCISSOR_BOX_EXCLUSIVE_NV = 0x9556;

	@:noCompletion private function new() {}

	// void glScissorExclusiveNV (GLint x, GLint y, GLsizei width, GLsizei height)
	// void glScissorExclusiveArrayvNV (GLuint first, GLsizei count, const GLint *v)
}
