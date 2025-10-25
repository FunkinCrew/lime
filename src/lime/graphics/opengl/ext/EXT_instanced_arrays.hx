package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_instanced_arrays
{
	public var VERTEX_ATTRIB_ARRAY_DIVISOR_EXT = 0x88FE;

	@:noCompletion private function new() {}

	// void glDrawArraysInstancedEXT (GLenum mode, GLint start, GLsizei count, GLsizei primcount)
	// void glDrawElementsInstancedEXT (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount)
	// void glVertexAttribDivisorEXT (GLuint index, GLuint divisor)
}
