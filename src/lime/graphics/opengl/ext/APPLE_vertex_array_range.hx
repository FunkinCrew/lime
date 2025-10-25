package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_vertex_array_range
{
	public var VERTEX_ARRAY_RANGE_APPLE = 0x851D;
	public var VERTEX_ARRAY_RANGE_LENGTH_APPLE = 0x851E;
	public var VERTEX_ARRAY_STORAGE_HINT_APPLE = 0x851F;
	public var VERTEX_ARRAY_RANGE_POINTER_APPLE = 0x8521;
	public var STORAGE_CLIENT_APPLE = 0x85B4;
	public var STORAGE_CACHED_APPLE = 0x85BE;
	public var STORAGE_SHARED_APPLE = 0x85BF;

	@:noCompletion private function new() {}

	// void glVertexArrayRangeAPPLE (GLsizei length, void *pointer)
	// void glFlushVertexArrayRangeAPPLE (GLsizei length, void *pointer)
	// void glVertexArrayParameteriAPPLE (GLenum pname, GLint param)
}
