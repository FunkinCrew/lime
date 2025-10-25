package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_window_rectangles
{
	public var INCLUSIVE_EXT = 0x8F10;
	public var EXCLUSIVE_EXT = 0x8F11;
	public var WINDOW_RECTANGLE_EXT = 0x8F12;
	public var WINDOW_RECTANGLE_MODE_EXT = 0x8F13;
	public var MAX_WINDOW_RECTANGLES_EXT = 0x8F14;
	public var NUM_WINDOW_RECTANGLES_EXT = 0x8F15;

	@:noCompletion private function new() {}

	// void glWindowRectanglesEXT (GLenum mode, GLsizei count, const GLint *box)
}
