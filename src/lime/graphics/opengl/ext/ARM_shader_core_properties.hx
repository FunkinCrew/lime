package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARM_shader_core_properties
{
	public var SHADER_CORE_COUNT_ARM = 0x96F0;
	public var SHADER_CORE_ACTIVE_COUNT_ARM = 0x96F1;
	public var SHADER_CORE_PRESENT_MASK_ARM = 0x96F2;
	public var SHADER_CORE_MAX_WARP_COUNT_ARM = 0x96F3;
	public var SHADER_CORE_PIXEL_RATE_ARM = 0x96F4;
	public var SHADER_CORE_TEXEL_RATE_ARM = 0x96F5;
	public var SHADER_CORE_FMA_RATE_ARM = 0x96F6;

	@:noCompletion private function new() {}

	// void glMaxActiveShaderCoresARM (GLuint count)
}
