package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ANGLE_instanced_arrays
{
	public var VERTEX_ATTRIB_ARRAY_DIVISOR_ANGLE = 0x88FE;

	@:noCompletion private function new() {}

	// void glDrawArraysInstancedANGLE (GLenum mode, GLint first, GLsizei count, GLsizei primcount)
	// void glDrawElementsInstancedANGLE (GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount)
	// void glVertexAttribDivisorANGLE (GLuint index, GLuint divisor)
}
