package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_pixel_transform
{
	public var PIXEL_TRANSFORM_2D_EXT = 0x8330;
	public var PIXEL_MAG_FILTER_EXT = 0x8331;
	public var PIXEL_MIN_FILTER_EXT = 0x8332;
	public var PIXEL_CUBIC_WEIGHT_EXT = 0x8333;
	public var CUBIC_EXT = 0x8334;
	public var AVERAGE_EXT = 0x8335;
	public var PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT = 0x8336;
	public var MAX_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT = 0x8337;
	public var PIXEL_TRANSFORM_2D_MATRIX_EXT = 0x8338;

	@:noCompletion private function new() {}

	// void glPixelTransformParameteriEXT (GLenum target, GLenum pname, GLint param)
	// void glPixelTransformParameterfEXT (GLenum target, GLenum pname, GLfloat param)
	// void glPixelTransformParameterivEXT (GLenum target, GLenum pname, const GLint *params)
	// void glPixelTransformParameterfvEXT (GLenum target, GLenum pname, const GLfloat *params)
	// void glGetPixelTransformParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// void glGetPixelTransformParameterfvEXT (GLenum target, GLenum pname, GLfloat *params)
}
