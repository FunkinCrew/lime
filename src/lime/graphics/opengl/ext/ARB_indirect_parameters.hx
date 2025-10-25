package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_indirect_parameters
{
	public var PARAMETER_BUFFER_ARB = 0x80EE;
	public var PARAMETER_BUFFER_BINDING_ARB = 0x80EF;

	@:noCompletion private function new() {}

	// void glMultiDrawArraysIndirectCountARB (GLenum mode, const void *indirect, GLintptr drawcount, GLsizei maxdrawcount, GLsizei stride)
	// void glMultiDrawElementsIndirectCountARB (GLenum mode, GLenum type, const void *indirect, GLintptr drawcount, GLsizei maxdrawcount, GLsizei stride)
}
