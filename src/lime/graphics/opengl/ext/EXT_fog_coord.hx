package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_fog_coord
{
	public var FOG_COORDINATE_SOURCE_EXT = 0x8450;
	public var FOG_COORDINATE_EXT = 0x8451;
	public var FRAGMENT_DEPTH_EXT = 0x8452;
	public var CURRENT_FOG_COORDINATE_EXT = 0x8453;
	public var FOG_COORDINATE_ARRAY_TYPE_EXT = 0x8454;
	public var FOG_COORDINATE_ARRAY_STRIDE_EXT = 0x8455;
	public var FOG_COORDINATE_ARRAY_POINTER_EXT = 0x8456;
	public var FOG_COORDINATE_ARRAY_EXT = 0x8457;

	@:noCompletion private function new() {}

	// void glFogCoordfEXT (GLfloat coord)
	// void glFogCoordfvEXT (const GLfloat *coord)
	// void glFogCoorddEXT (GLdouble coord)
	// void glFogCoorddvEXT (const GLdouble *coord)
	// void glFogCoordPointerEXT (GLenum type, GLsizei stride, const void *pointer)
}
