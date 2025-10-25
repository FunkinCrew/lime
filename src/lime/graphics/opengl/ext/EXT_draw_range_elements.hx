package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_draw_range_elements
{
	public var MAX_ELEMENTS_VERTICES_EXT = 0x80E8;
	public var MAX_ELEMENTS_INDICES_EXT = 0x80E9;

	@:noCompletion private function new() {}

	// void glDrawRangeElementsEXT (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const void *indices)
}
