package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_provoking_vertex
{
	public var QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION_EXT = 0x8E4C;
	public var FIRST_VERTEX_CONVENTION_EXT = 0x8E4D;
	public var LAST_VERTEX_CONVENTION_EXT = 0x8E4E;
	public var PROVOKING_VERTEX_EXT = 0x8E4F;

	@:noCompletion private function new() {}

	// void glProvokingVertexEXT (GLenum mode)
}
