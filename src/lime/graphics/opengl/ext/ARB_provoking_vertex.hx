package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_provoking_vertex
{
	public var QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4C;
	public var FIRST_VERTEX_CONVENTION = 0x8E4D;
	public var LAST_VERTEX_CONVENTION = 0x8E4E;
	public var PROVOKING_VERTEX = 0x8E4F;

	@:noCompletion private function new() {}

	// void glProvokingVertex (GLenum mode)
}
