package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_polygon_offset
{
	public var POLYGON_OFFSET_EXT = 0x8037;
	public var POLYGON_OFFSET_FACTOR_EXT = 0x8038;
	public var POLYGON_OFFSET_BIAS_EXT = 0x8039;

	@:noCompletion private function new() {}

	// void glPolygonOffsetEXT (GLfloat factor, GLfloat bias)
}
