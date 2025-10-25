package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_program_interface_query
{
	public var UNIFORM = 0x92E1;
	public var UNIFORM_BLOCK = 0x92E2;
	public var PROGRAM_INPUT = 0x92E3;
	public var PROGRAM_OUTPUT = 0x92E4;
	public var BUFFER_VARIABLE = 0x92E5;
	public var SHADER_STORAGE_BLOCK = 0x92E6;
	public var ATOMIC_COUNTER_BUFFER = 0x92C0;
	public var VERTEX_SUBROUTINE = 0x92E8;
	public var TESS_CONTROL_SUBROUTINE = 0x92E9;
	public var TESS_EVALUATION_SUBROUTINE = 0x92EA;
	public var GEOMETRY_SUBROUTINE = 0x92EB;
	public var FRAGMENT_SUBROUTINE = 0x92EC;
	public var COMPUTE_SUBROUTINE = 0x92ED;
	public var VERTEX_SUBROUTINE_UNIFORM = 0x92EE;
	public var TESS_CONTROL_SUBROUTINE_UNIFORM = 0x92EF;
	public var TESS_EVALUATION_SUBROUTINE_UNIFORM = 0x92F0;
	public var GEOMETRY_SUBROUTINE_UNIFORM = 0x92F1;
	public var FRAGMENT_SUBROUTINE_UNIFORM = 0x92F2;
	public var COMPUTE_SUBROUTINE_UNIFORM = 0x92F3;
	public var TRANSFORM_FEEDBACK_VARYING = 0x92F4;
	public var ACTIVE_RESOURCES = 0x92F5;
	public var MAX_NAME_LENGTH = 0x92F6;
	public var MAX_NUM_ACTIVE_VARIABLES = 0x92F7;
	public var MAX_NUM_COMPATIBLE_SUBROUTINES = 0x92F8;
	public var NAME_LENGTH = 0x92F9;
	public var TYPE = 0x92FA;
	public var ARRAY_SIZE = 0x92FB;
	public var OFFSET = 0x92FC;
	public var BLOCK_INDEX = 0x92FD;
	public var ARRAY_STRIDE = 0x92FE;
	public var MATRIX_STRIDE = 0x92FF;
	public var IS_ROW_MAJOR = 0x9300;
	public var ATOMIC_COUNTER_BUFFER_INDEX = 0x9301;
	public var BUFFER_BINDING = 0x9302;
	public var BUFFER_DATA_SIZE = 0x9303;
	public var NUM_ACTIVE_VARIABLES = 0x9304;
	public var ACTIVE_VARIABLES = 0x9305;
	public var REFERENCED_BY_VERTEX_SHADER = 0x9306;
	public var REFERENCED_BY_TESS_CONTROL_SHADER = 0x9307;
	public var REFERENCED_BY_TESS_EVALUATION_SHADER = 0x9308;
	public var REFERENCED_BY_GEOMETRY_SHADER = 0x9309;
	public var REFERENCED_BY_FRAGMENT_SHADER = 0x930A;
	public var REFERENCED_BY_COMPUTE_SHADER = 0x930B;
	public var TOP_LEVEL_ARRAY_SIZE = 0x930C;
	public var TOP_LEVEL_ARRAY_STRIDE = 0x930D;
	public var LOCATION = 0x930E;
	public var LOCATION_INDEX = 0x930F;
	public var IS_PER_PATCH = 0x92E7;
	public var NUM_COMPATIBLE_SUBROUTINES = 0x8E4A;
	public var COMPATIBLE_SUBROUTINES = 0x8E4B;

	@:noCompletion private function new() {}

	// void glGetProgramInterfaceiv (GLuint program, GLenum programInterface, GLenum pname, GLint *params)
	// GLuint glGetProgramResourceIndex (GLuint program, GLenum programInterface, const GLchar *name)
	// void glGetProgramResourceName (GLuint program, GLenum programInterface, GLuint index, GLsizei bufSize, GLsizei *length, GLchar *name)
	// void glGetProgramResourceiv (GLuint program, GLenum programInterface, GLuint index, GLsizei propCount, const GLenum *props, GLsizei count, GLsizei *length, GLint *params)
	// GLint glGetProgramResourceLocation (GLuint program, GLenum programInterface, const GLchar *name)
	// GLint glGetProgramResourceLocationIndex (GLuint program, GLenum programInterface, const GLchar *name)
}
