package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_pipeline_statistics_query
{
	public var VERTICES_SUBMITTED_ARB = 0x82EE;
	public var PRIMITIVES_SUBMITTED_ARB = 0x82EF;
	public var VERTEX_SHADER_INVOCATIONS_ARB = 0x82F0;
	public var TESS_CONTROL_SHADER_PATCHES_ARB = 0x82F1;
	public var TESS_EVALUATION_SHADER_INVOCATIONS_ARB = 0x82F2;
	public var GEOMETRY_SHADER_INVOCATIONS = 0x887F;
	public var GEOMETRY_SHADER_PRIMITIVES_EMITTED_ARB = 0x82F3;
	public var FRAGMENT_SHADER_INVOCATIONS_ARB = 0x82F4;
	public var COMPUTE_SHADER_INVOCATIONS_ARB = 0x82F5;
	public var CLIPPING_INPUT_PRIMITIVES_ARB = 0x82F6;
	public var CLIPPING_OUTPUT_PRIMITIVES_ARB = 0x82F7;

	@:noCompletion private function new() {}
}
