package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_compute_variable_group_size
{
	public var MAX_COMPUTE_VARIABLE_GROUP_INVOCATIONS_ARB = 0x9344;
	public var MAX_COMPUTE_FIXED_GROUP_INVOCATIONS_ARB = 0x90EB;
	public var MAX_COMPUTE_VARIABLE_GROUP_SIZE_ARB = 0x9345;
	public var MAX_COMPUTE_FIXED_GROUP_SIZE_ARB = 0x91BF;

	@:noCompletion private function new() {}

	// void glDispatchComputeGroupSizeARB (GLuint num_groups_x, GLuint num_groups_y, GLuint num_groups_z, GLuint group_size_x, GLuint group_size_y, GLuint group_size_z)
}
