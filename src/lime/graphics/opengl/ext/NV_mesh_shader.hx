package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_mesh_shader
{
	public var MESH_SHADER_NV = 0x9559;
	public var TASK_SHADER_NV = 0x955A;
	public var MAX_MESH_UNIFORM_BLOCKS_NV = 0x8E60;
	public var MAX_MESH_TEXTURE_IMAGE_UNITS_NV = 0x8E61;
	public var MAX_MESH_IMAGE_UNIFORMS_NV = 0x8E62;
	public var MAX_MESH_UNIFORM_COMPONENTS_NV = 0x8E63;
	public var MAX_MESH_ATOMIC_COUNTER_BUFFERS_NV = 0x8E64;
	public var MAX_MESH_ATOMIC_COUNTERS_NV = 0x8E65;
	public var MAX_MESH_SHADER_STORAGE_BLOCKS_NV = 0x8E66;
	public var MAX_COMBINED_MESH_UNIFORM_COMPONENTS_NV = 0x8E67;
	public var MAX_TASK_UNIFORM_BLOCKS_NV = 0x8E68;
	public var MAX_TASK_TEXTURE_IMAGE_UNITS_NV = 0x8E69;
	public var MAX_TASK_IMAGE_UNIFORMS_NV = 0x8E6A;
	public var MAX_TASK_UNIFORM_COMPONENTS_NV = 0x8E6B;
	public var MAX_TASK_ATOMIC_COUNTER_BUFFERS_NV = 0x8E6C;
	public var MAX_TASK_ATOMIC_COUNTERS_NV = 0x8E6D;
	public var MAX_TASK_SHADER_STORAGE_BLOCKS_NV = 0x8E6E;
	public var MAX_COMBINED_TASK_UNIFORM_COMPONENTS_NV = 0x8E6F;
	public var MAX_MESH_WORK_GROUP_INVOCATIONS_NV = 0x95A2;
	public var MAX_TASK_WORK_GROUP_INVOCATIONS_NV = 0x95A3;
	public var MAX_MESH_TOTAL_MEMORY_SIZE_NV = 0x9536;
	public var MAX_TASK_TOTAL_MEMORY_SIZE_NV = 0x9537;
	public var MAX_MESH_OUTPUT_VERTICES_NV = 0x9538;
	public var MAX_MESH_OUTPUT_PRIMITIVES_NV = 0x9539;
	public var MAX_TASK_OUTPUT_COUNT_NV = 0x953A;
	public var MAX_DRAW_MESH_TASKS_COUNT_NV = 0x953D;
	public var MAX_MESH_VIEWS_NV = 0x9557;
	public var MESH_OUTPUT_PER_VERTEX_GRANULARITY_NV = 0x92DF;
	public var MESH_OUTPUT_PER_PRIMITIVE_GRANULARITY_NV = 0x9543;
	public var MAX_MESH_WORK_GROUP_SIZE_NV = 0x953B;
	public var MAX_TASK_WORK_GROUP_SIZE_NV = 0x953C;
	public var MESH_WORK_GROUP_SIZE_NV = 0x953E;
	public var TASK_WORK_GROUP_SIZE_NV = 0x953F;
	public var MESH_VERTICES_OUT_NV = 0x9579;
	public var MESH_PRIMITIVES_OUT_NV = 0x957A;
	public var MESH_OUTPUT_TYPE_NV = 0x957B;
	public var UNIFORM_BLOCK_REFERENCED_BY_MESH_SHADER_NV = 0x959C;
	public var UNIFORM_BLOCK_REFERENCED_BY_TASK_SHADER_NV = 0x959D;
	public var REFERENCED_BY_MESH_SHADER_NV = 0x95A0;
	public var REFERENCED_BY_TASK_SHADER_NV = 0x95A1;
	public var MESH_SHADER_BIT_NV = 0x00000040;
	public var TASK_SHADER_BIT_NV = 0x00000080;

	@:noCompletion private function new() {}

	// void glDrawMeshTasksNV (GLuint first, GLuint count)
	// void glDrawMeshTasksIndirectNV (GLintptr indirect)
	// void glMultiDrawMeshTasksIndirectNV (GLintptr indirect, GLsizei drawcount, GLsizei stride)
	// void glMultiDrawMeshTasksIndirectCountNV (GLintptr indirect, GLintptr drawcount, GLsizei maxdrawcount, GLsizei stride)
}
