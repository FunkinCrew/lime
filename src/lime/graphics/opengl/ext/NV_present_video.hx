package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_present_video
{
	public var FRAME_NV = 0x8E26;
	public var FIELDS_NV = 0x8E27;
	public var CURRENT_TIME_NV = 0x8E28;
	public var NUM_FILL_STREAMS_NV = 0x8E29;
	public var PRESENT_TIME_NV = 0x8E2A;
	public var PRESENT_DURATION_NV = 0x8E2B;

	@:noCompletion private function new() {}

	// void glPresentFrameKeyedNV (GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLuint key0, GLenum target1, GLuint fill1, GLuint key1)
	// void glPresentFrameDualFillNV (GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLenum target1, GLuint fill1, GLenum target2, GLuint fill2, GLenum target3, GLuint fill3)
	// void glGetVideoivNV (GLuint video_slot, GLenum pname, GLint *params)
	// void glGetVideouivNV (GLuint video_slot, GLenum pname, GLuint *params)
	// void glGetVideoi64vNV (GLuint video_slot, GLenum pname, GLint64EXT *params)
	// void glGetVideoui64vNV (GLuint video_slot, GLenum pname, GLuint64EXT *params)
}
