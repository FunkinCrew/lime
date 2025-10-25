package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_polygon_mode
{
	public var POLYGON_MODE_NV = 0x0B40;
	public var POLYGON_OFFSET_POINT_NV = 0x2A01;
	public var POLYGON_OFFSET_LINE_NV = 0x2A02;
	public var POINT_NV = 0x1B00;
	public var LINE_NV = 0x1B01;
	public var FILL_NV = 0x1B02;

	@:noCompletion private function new() {}

	// void glPolygonModeNV (GLenum face, GLenum mode)
}
