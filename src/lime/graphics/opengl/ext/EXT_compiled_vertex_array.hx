package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_compiled_vertex_array
{
	public var ARRAY_ELEMENT_LOCK_FIRST_EXT = 0x81A8;
	public var ARRAY_ELEMENT_LOCK_COUNT_EXT = 0x81A9;

	@:noCompletion private function new() {}

	// void glLockArraysEXT (GLint first, GLsizei count)
	// void glUnlockArraysEXT ()
}
