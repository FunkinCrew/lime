package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_element_array
{
	public var ELEMENT_ARRAY_ATI = 0x8768;
	public var ELEMENT_ARRAY_TYPE_ATI = 0x8769;
	public var ELEMENT_ARRAY_POINTER_ATI = 0x876A;

	@:noCompletion private function new() {}

	// void glElementPointerATI (GLenum type, const void *pointer)
	// void glDrawElementArrayATI (GLenum mode, GLsizei count)
	// void glDrawRangeElementArrayATI (GLenum mode, GLuint start, GLuint end, GLsizei count)
}
