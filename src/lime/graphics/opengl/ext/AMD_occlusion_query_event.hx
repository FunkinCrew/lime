package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_occlusion_query_event
{
	public var OCCLUSION_QUERY_EVENT_MASK_AMD = 0x874F;
	public var QUERY_DEPTH_PASS_EVENT_BIT_AMD = 0x00000001;
	public var QUERY_DEPTH_FAIL_EVENT_BIT_AMD = 0x00000002;
	public var QUERY_STENCIL_FAIL_EVENT_BIT_AMD = 0x00000004;
	public var QUERY_DEPTH_BOUNDS_FAIL_EVENT_BIT_AMD = 0x00000008;
	public var QUERY_ALL_EVENT_BITS_AMD = 0xFFFFFFFF;

	@:noCompletion private function new() {}

	// void glQueryObjectParameteruiAMD (GLenum target, GLuint id, GLenum pname, GLuint param)
}
