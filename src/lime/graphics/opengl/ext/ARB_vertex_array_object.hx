package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_array_object
{
	public var VERTEX_ARRAY_BINDING = 0x85B5;

	@:noCompletion private function new() {}

	// void glBindVertexArray (GLuint array)
	// void glDeleteVertexArrays (GLsizei n, const GLuint *arrays)
	// void glGenVertexArrays (GLsizei n, GLuint *arrays)
	// GLboolean glIsVertexArray (GLuint array)
}
