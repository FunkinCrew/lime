package lime.graphics.opengl.ext;

@:keep
@:noCompletion class INTEL_parallel_arrays
{
	public var PARALLEL_ARRAYS_INTEL = 0x83F4;
	public var VERTEX_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F5;
	public var NORMAL_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F6;
	public var COLOR_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F7;
	public var TEXTURE_COORD_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F8;

	@:noCompletion private function new() {}

	// void glVertexPointervINTEL (GLint size, GLenum type, const void **pointer)
	// void glNormalPointervINTEL (GLenum type, const void **pointer)
	// void glColorPointervINTEL (GLint size, GLenum type, const void **pointer)
	// void glTexCoordPointervINTEL (GLint size, GLenum type, const void **pointer)
}
