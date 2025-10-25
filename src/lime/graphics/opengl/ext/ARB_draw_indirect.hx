package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_draw_indirect
{
	public var DRAW_INDIRECT_BUFFER = 0x8F3F;
	public var DRAW_INDIRECT_BUFFER_BINDING = 0x8F43;

	@:noCompletion private function new() {}

	// void glDrawArraysIndirect (GLenum mode, const void *indirect)
	// void glDrawElementsIndirect (GLenum mode, GLenum type, const void *indirect)
}
