package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_depth_buffer_float
{
	public var DEPTH_COMPONENT32F_NV = 0x8DAB;
	public var DEPTH32F_STENCIL8_NV = 0x8DAC;
	public var FLOAT_32_UNSIGNED_INT_24_8_REV_NV = 0x8DAD;
	public var DEPTH_BUFFER_FLOAT_MODE_NV = 0x8DAF;

	@:noCompletion private function new() {}

	// void glDepthRangedNV (GLdouble zNear, GLdouble zFar)
	// void glClearDepthdNV (GLdouble depth)
	// void glDepthBoundsdNV (GLdouble zmin, GLdouble zmax)
}
