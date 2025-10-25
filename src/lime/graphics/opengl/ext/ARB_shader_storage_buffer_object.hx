package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_shader_storage_buffer_object
{
	public var SHADER_STORAGE_BUFFER = 0x90D2;
	public var SHADER_STORAGE_BUFFER_BINDING = 0x90D3;
	public var SHADER_STORAGE_BUFFER_START = 0x90D4;
	public var SHADER_STORAGE_BUFFER_SIZE = 0x90D5;
	public var MAX_VERTEX_SHADER_STORAGE_BLOCKS = 0x90D6;
	public var MAX_GEOMETRY_SHADER_STORAGE_BLOCKS = 0x90D7;
	public var MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS = 0x90D8;
	public var MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS = 0x90D9;
	public var MAX_FRAGMENT_SHADER_STORAGE_BLOCKS = 0x90DA;
	public var MAX_COMPUTE_SHADER_STORAGE_BLOCKS = 0x90DB;
	public var MAX_COMBINED_SHADER_STORAGE_BLOCKS = 0x90DC;
	public var MAX_SHADER_STORAGE_BUFFER_BINDINGS = 0x90DD;
	public var MAX_SHADER_STORAGE_BLOCK_SIZE = 0x90DE;
	public var SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT = 0x90DF;
	public var SHADER_STORAGE_BARRIER_BIT = 0x00002000;
	public var MAX_COMBINED_SHADER_OUTPUT_RESOURCES = 0x8F39;
	public var MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS = 0x8F39;

	@:noCompletion private function new() {}

	// void glShaderStorageBlockBinding (GLuint program, GLuint storageBlockIndex, GLuint storageBlockBinding)
}
