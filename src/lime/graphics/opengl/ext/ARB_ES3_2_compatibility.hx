package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_ES3_2_compatibility
{
	public var PRIMITIVE_BOUNDING_BOX_ARB = 0x92BE;
	public var MULTISAMPLE_LINE_WIDTH_RANGE_ARB = 0x9381;
	public var MULTISAMPLE_LINE_WIDTH_GRANULARITY_ARB = 0x9382;

	@:noCompletion private function new() {}

	// void glPrimitiveBoundingBoxARB (GLfloat minX, GLfloat minY, GLfloat minZ, GLfloat minW, GLfloat maxX, GLfloat maxY, GLfloat maxZ, GLfloat maxW)
}
