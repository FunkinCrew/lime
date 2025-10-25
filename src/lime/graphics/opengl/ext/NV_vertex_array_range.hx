package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_vertex_array_range
{
	public var VERTEX_ARRAY_RANGE_NV = 0x851D;
	public var VERTEX_ARRAY_RANGE_LENGTH_NV = 0x851E;
	public var VERTEX_ARRAY_RANGE_VALID_NV = 0x851F;
	public var MAX_VERTEX_ARRAY_RANGE_ELEMENT_NV = 0x8520;
	public var VERTEX_ARRAY_RANGE_POINTER_NV = 0x8521;

	@:noCompletion private function new() {}

	// void glFlushVertexArrayRangeNV ()
	// void glVertexArrayRangeNV (GLsizei length, const void *pointer)
}
