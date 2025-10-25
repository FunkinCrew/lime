package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_conditional_render
{
	public var QUERY_WAIT_NV = 0x8E13;
	public var QUERY_NO_WAIT_NV = 0x8E14;
	public var QUERY_BY_REGION_WAIT_NV = 0x8E15;
	public var QUERY_BY_REGION_NO_WAIT_NV = 0x8E16;

	@:noCompletion private function new() {}

	// void glBeginConditionalRenderNV (GLuint id, GLenum mode)
	// void glEndConditionalRenderNV ()
}
