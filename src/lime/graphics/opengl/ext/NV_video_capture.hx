package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_video_capture
{
	public var VIDEO_BUFFER_NV = 0x9020;
	public var VIDEO_BUFFER_BINDING_NV = 0x9021;
	public var FIELD_UPPER_NV = 0x9022;
	public var FIELD_LOWER_NV = 0x9023;
	public var NUM_VIDEO_CAPTURE_STREAMS_NV = 0x9024;
	public var NEXT_VIDEO_CAPTURE_BUFFER_STATUS_NV = 0x9025;
	public var VIDEO_CAPTURE_TO_422_SUPPORTED_NV = 0x9026;
	public var LAST_VIDEO_CAPTURE_STATUS_NV = 0x9027;
	public var VIDEO_BUFFER_PITCH_NV = 0x9028;
	public var VIDEO_COLOR_CONVERSION_MATRIX_NV = 0x9029;
	public var VIDEO_COLOR_CONVERSION_MAX_NV = 0x902A;
	public var VIDEO_COLOR_CONVERSION_MIN_NV = 0x902B;
	public var VIDEO_COLOR_CONVERSION_OFFSET_NV = 0x902C;
	public var VIDEO_BUFFER_INTERNAL_FORMAT_NV = 0x902D;
	public var PARTIAL_SUCCESS_NV = 0x902E;
	public var SUCCESS_NV = 0x902F;
	public var FAILURE_NV = 0x9030;
	public var YCBYCR8_422_NV = 0x9031;
	public var YCBAYCR8A_4224_NV = 0x9032;
	public var Z6Y10Z6CB10Z6Y10Z6CR10_422_NV = 0x9033;
	public var Z6Y10Z6CB10Z6A10Z6Y10Z6CR10Z6A10_4224_NV = 0x9034;
	public var Z4Y12Z4CB12Z4Y12Z4CR12_422_NV = 0x9035;
	public var Z4Y12Z4CB12Z4A12Z4Y12Z4CR12Z4A12_4224_NV = 0x9036;
	public var Z4Y12Z4CB12Z4CR12_444_NV = 0x9037;
	public var VIDEO_CAPTURE_FRAME_WIDTH_NV = 0x9038;
	public var VIDEO_CAPTURE_FRAME_HEIGHT_NV = 0x9039;
	public var VIDEO_CAPTURE_FIELD_UPPER_HEIGHT_NV = 0x903A;
	public var VIDEO_CAPTURE_FIELD_LOWER_HEIGHT_NV = 0x903B;
	public var VIDEO_CAPTURE_SURFACE_ORIGIN_NV = 0x903C;

	@:noCompletion private function new() {}

	// void glBeginVideoCaptureNV (GLuint video_capture_slot)
	// void glBindVideoCaptureStreamBufferNV (GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLintptrARB offset)
	// void glBindVideoCaptureStreamTextureNV (GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLenum target, GLuint texture)
	// void glEndVideoCaptureNV (GLuint video_capture_slot)
	// void glGetVideoCaptureivNV (GLuint video_capture_slot, GLenum pname, GLint *params)
	// void glGetVideoCaptureStreamivNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLint *params)
	// void glGetVideoCaptureStreamfvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLfloat *params)
	// void glGetVideoCaptureStreamdvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLdouble *params)
	// GLenum glVideoCaptureNV (GLuint video_capture_slot, GLuint *sequence_num, GLuint64EXT *capture_time)
	// void glVideoCaptureStreamParameterivNV (GLuint video_capture_slot, GLuint stream, GLenum pname, const GLint *params)
	// void glVideoCaptureStreamParameterfvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, const GLfloat *params)
	// void glVideoCaptureStreamParameterdvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, const GLdouble *params)
}
