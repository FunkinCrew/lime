package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_attrib_binding
{
	public var VERTEX_ATTRIB_BINDING = 0x82D4;
	public var VERTEX_ATTRIB_RELATIVE_OFFSET = 0x82D5;
	public var VERTEX_BINDING_DIVISOR = 0x82D6;
	public var VERTEX_BINDING_OFFSET = 0x82D7;
	public var VERTEX_BINDING_STRIDE = 0x82D8;
	public var MAX_VERTEX_ATTRIB_RELATIVE_OFFSET = 0x82D9;
	public var MAX_VERTEX_ATTRIB_BINDINGS = 0x82DA;

	@:noCompletion private function new() {}

	// void glBindVertexBuffer (GLuint bindingindex, GLuint buffer, GLintptr offset, GLsizei stride)
	// void glVertexAttribFormat (GLuint attribindex, GLint size, GLenum type, GLboolean normalized, GLuint relativeoffset)
	// void glVertexAttribIFormat (GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset)
	// void glVertexAttribLFormat (GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset)
	// void glVertexAttribBinding (GLuint attribindex, GLuint bindingindex)
	// void glVertexBindingDivisor (GLuint bindingindex, GLuint divisor)
}
