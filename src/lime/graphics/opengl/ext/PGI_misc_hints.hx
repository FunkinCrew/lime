package lime.graphics.opengl.ext;

@:keep
@:noCompletion class PGI_misc_hints
{
	public var PREFER_DOUBLEBUFFER_HINT_PGI = 0x1A1F8;
	public var CONSERVE_MEMORY_HINT_PGI = 0x1A1FD;
	public var RECLAIM_MEMORY_HINT_PGI = 0x1A1FE;
	public var NATIVE_GRAPHICS_HANDLE_PGI = 0x1A202;
	public var NATIVE_GRAPHICS_BEGIN_HINT_PGI = 0x1A203;
	public var NATIVE_GRAPHICS_END_HINT_PGI = 0x1A204;
	public var ALWAYS_FAST_HINT_PGI = 0x1A20C;
	public var ALWAYS_SOFT_HINT_PGI = 0x1A20D;
	public var ALLOW_DRAW_OBJ_HINT_PGI = 0x1A20E;
	public var ALLOW_DRAW_WIN_HINT_PGI = 0x1A20F;
	public var ALLOW_DRAW_FRG_HINT_PGI = 0x1A210;
	public var ALLOW_DRAW_MEM_HINT_PGI = 0x1A211;
	public var STRICT_DEPTHFUNC_HINT_PGI = 0x1A216;
	public var STRICT_LIGHTING_HINT_PGI = 0x1A217;
	public var STRICT_SCISSOR_HINT_PGI = 0x1A218;
	public var FULL_STIPPLE_HINT_PGI = 0x1A219;
	public var CLIP_NEAR_HINT_PGI = 0x1A220;
	public var CLIP_FAR_HINT_PGI = 0x1A221;
	public var WIDE_LINE_HINT_PGI = 0x1A222;
	public var BACK_NORMALS_HINT_PGI = 0x1A223;

	@:noCompletion private function new() {}

	// void glHintPGI (GLenum target, GLint mode)
}
