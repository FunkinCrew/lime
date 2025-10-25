package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_gpu_program5
{
	public var MAX_GEOMETRY_PROGRAM_INVOCATIONS_NV = 0x8E5A;
	public var MIN_FRAGMENT_INTERPOLATION_OFFSET_NV = 0x8E5B;
	public var MAX_FRAGMENT_INTERPOLATION_OFFSET_NV = 0x8E5C;
	public var FRAGMENT_PROGRAM_INTERPOLATION_OFFSET_BITS_NV = 0x8E5D;
	public var MIN_PROGRAM_TEXTURE_GATHER_OFFSET_NV = 0x8E5E;
	public var MAX_PROGRAM_TEXTURE_GATHER_OFFSET_NV = 0x8E5F;
	public var MAX_PROGRAM_SUBROUTINE_PARAMETERS_NV = 0x8F44;
	public var MAX_PROGRAM_SUBROUTINE_NUM_NV = 0x8F45;

	@:noCompletion private function new() {}

	// void glProgramSubroutineParametersuivNV (GLenum target, GLsizei count, const GLuint *params)
	// void glGetProgramSubroutineParameteruivNV (GLenum target, GLuint index, GLuint *param)
}
