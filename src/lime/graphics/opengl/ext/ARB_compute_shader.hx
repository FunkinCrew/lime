package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_compute_shader
{
	public var COMPUTE_SHADER = 0x91B9;
	public var MAX_COMPUTE_UNIFORM_BLOCKS = 0x91BB;
	public var MAX_COMPUTE_TEXTURE_IMAGE_UNITS = 0x91BC;
	public var MAX_COMPUTE_IMAGE_UNIFORMS = 0x91BD;
	public var MAX_COMPUTE_SHARED_MEMORY_SIZE = 0x8262;
	public var MAX_COMPUTE_UNIFORM_COMPONENTS = 0x8263;
	public var MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS = 0x8264;
	public var MAX_COMPUTE_ATOMIC_COUNTERS = 0x8265;
	public var MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS = 0x8266;
	public var MAX_COMPUTE_WORK_GROUP_INVOCATIONS = 0x90EB;
	public var MAX_COMPUTE_WORK_GROUP_COUNT = 0x91BE;
	public var MAX_COMPUTE_WORK_GROUP_SIZE = 0x91BF;
	public var COMPUTE_WORK_GROUP_SIZE = 0x8267;
	public var UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER = 0x90EC;
	public var ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER = 0x90ED;
	public var DISPATCH_INDIRECT_BUFFER = 0x90EE;
	public var DISPATCH_INDIRECT_BUFFER_BINDING = 0x90EF;
	public var COMPUTE_SHADER_BIT = 0x00000020;

	@:noCompletion private function new() {}

	// void glDispatchCompute (GLuint num_groups_x, GLuint num_groups_y, GLuint num_groups_z)
	// void glDispatchComputeIndirect (GLintptr indirect)
}
