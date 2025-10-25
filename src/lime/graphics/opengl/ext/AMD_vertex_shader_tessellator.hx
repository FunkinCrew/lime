package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_vertex_shader_tessellator
{
	public var SAMPLER_BUFFER_AMD = 0x9001;
	public var INT_SAMPLER_BUFFER_AMD = 0x9002;
	public var UNSIGNED_INT_SAMPLER_BUFFER_AMD = 0x9003;
	public var TESSELLATION_MODE_AMD = 0x9004;
	public var TESSELLATION_FACTOR_AMD = 0x9005;
	public var DISCRETE_AMD = 0x9006;
	public var CONTINUOUS_AMD = 0x9007;

	@:noCompletion private function new() {}

	// void glTessellationFactorAMD (GLfloat factor)
	// void glTessellationModeAMD (GLenum mode)
}
