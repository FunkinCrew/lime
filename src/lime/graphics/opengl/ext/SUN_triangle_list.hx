package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SUN_triangle_list
{
	public var RESTART_SUN = 0x0001;
	public var REPLACE_MIDDLE_SUN = 0x0002;
	public var REPLACE_OLDEST_SUN = 0x0003;
	public var TRIANGLE_LIST_SUN = 0x81D7;
	public var REPLACEMENT_CODE_SUN = 0x81D8;
	public var REPLACEMENT_CODE_ARRAY_SUN = 0x85C0;
	public var REPLACEMENT_CODE_ARRAY_TYPE_SUN = 0x85C1;
	public var REPLACEMENT_CODE_ARRAY_STRIDE_SUN = 0x85C2;
	public var REPLACEMENT_CODE_ARRAY_POINTER_SUN = 0x85C3;
	public var R1UI_V3F_SUN = 0x85C4;
	public var R1UI_C4UB_V3F_SUN = 0x85C5;
	public var R1UI_C3F_V3F_SUN = 0x85C6;
	public var R1UI_N3F_V3F_SUN = 0x85C7;
	public var R1UI_C4F_N3F_V3F_SUN = 0x85C8;
	public var R1UI_T2F_V3F_SUN = 0x85C9;
	public var R1UI_T2F_N3F_V3F_SUN = 0x85CA;
	public var R1UI_T2F_C4F_N3F_V3F_SUN = 0x85CB;

	@:noCompletion private function new() {}

	// void glReplacementCodeuiSUN (GLuint code)
	// void glReplacementCodeusSUN (GLushort code)
	// void glReplacementCodeubSUN (GLubyte code)
	// void glReplacementCodeuivSUN (const GLuint *code)
	// void glReplacementCodeusvSUN (const GLushort *code)
	// void glReplacementCodeubvSUN (const GLubyte *code)
	// void glReplacementCodePointerSUN (GLenum type, GLsizei stride, const void **pointer)
}
