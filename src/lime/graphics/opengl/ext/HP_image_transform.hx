package lime.graphics.opengl.ext;

@:keep
@:noCompletion class HP_image_transform
{
	public var IMAGE_SCALE_X_HP = 0x8155;
	public var IMAGE_SCALE_Y_HP = 0x8156;
	public var IMAGE_TRANSLATE_X_HP = 0x8157;
	public var IMAGE_TRANSLATE_Y_HP = 0x8158;
	public var IMAGE_ROTATE_ANGLE_HP = 0x8159;
	public var IMAGE_ROTATE_ORIGIN_X_HP = 0x815A;
	public var IMAGE_ROTATE_ORIGIN_Y_HP = 0x815B;
	public var IMAGE_MAG_FILTER_HP = 0x815C;
	public var IMAGE_MIN_FILTER_HP = 0x815D;
	public var IMAGE_CUBIC_WEIGHT_HP = 0x815E;
	public var CUBIC_HP = 0x815F;
	public var AVERAGE_HP = 0x8160;
	public var IMAGE_TRANSFORM_2D_HP = 0x8161;
	public var POST_IMAGE_TRANSFORM_COLOR_TABLE_HP = 0x8162;
	public var PROXY_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP = 0x8163;

	@:noCompletion private function new() {}

	// void glImageTransformParameteriHP (GLenum target, GLenum pname, GLint param)
	// void glImageTransformParameterfHP (GLenum target, GLenum pname, GLfloat param)
	// void glImageTransformParameterivHP (GLenum target, GLenum pname, const GLint *params)
	// void glImageTransformParameterfvHP (GLenum target, GLenum pname, const GLfloat *params)
	// void glGetImageTransformParameterivHP (GLenum target, GLenum pname, GLint *params)
	// void glGetImageTransformParameterfvHP (GLenum target, GLenum pname, GLfloat *params)
}
