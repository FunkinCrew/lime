package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_separate_stencil
{
	public var STENCIL_BACK_FUNC_ATI = 0x8800;
	public var STENCIL_BACK_FAIL_ATI = 0x8801;
	public var STENCIL_BACK_PASS_DEPTH_FAIL_ATI = 0x8802;
	public var STENCIL_BACK_PASS_DEPTH_PASS_ATI = 0x8803;

	@:noCompletion private function new() {}

	// void glStencilOpSeparateATI (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass)
	// void glStencilFuncSeparateATI (GLenum frontfunc, GLenum backfunc, GLint ref, GLuint mask)
}
