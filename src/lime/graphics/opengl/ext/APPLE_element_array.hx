package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_element_array
{
	public var ELEMENT_ARRAY_APPLE = 0x8A0C;
	public var ELEMENT_ARRAY_TYPE_APPLE = 0x8A0D;
	public var ELEMENT_ARRAY_POINTER_APPLE = 0x8A0E;

	@:noCompletion private function new() {}

	// void glElementPointerAPPLE (GLenum type, const void *pointer)
	// void glDrawElementArrayAPPLE (GLenum mode, GLint first, GLsizei count)
	// void glDrawRangeElementArrayAPPLE (GLenum mode, GLuint start, GLuint end, GLint first, GLsizei count)
	// void glMultiDrawElementArrayAPPLE (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount)
	// void glMultiDrawRangeElementArrayAPPLE (GLenum mode, GLuint start, GLuint end, const GLint *first, const GLsizei *count, GLsizei primcount)
}
