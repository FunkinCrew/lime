package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_stencil_operation_extended
{
	public var SET_AMD = 0x874A;
	public var REPLACE_VALUE_AMD = 0x874B;
	public var STENCIL_OP_VALUE_AMD = 0x874C;
	public var STENCIL_BACK_OP_VALUE_AMD = 0x874D;

	@:noCompletion private function new() {}

	// void glStencilOpValueAMD (GLenum face, GLuint value)
}
