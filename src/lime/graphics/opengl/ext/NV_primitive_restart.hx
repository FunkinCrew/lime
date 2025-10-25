package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_primitive_restart
{
	public var PRIMITIVE_RESTART_NV = 0x8558;
	public var PRIMITIVE_RESTART_INDEX_NV = 0x8559;

	@:noCompletion private function new() {}

	// void glPrimitiveRestartNV ()
	// void glPrimitiveRestartIndexNV (GLuint index)
}
