package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_get_program_binary
{
	public var PROGRAM_BINARY_RETRIEVABLE_HINT = 0x8257;
	public var PROGRAM_BINARY_LENGTH = 0x8741;
	public var NUM_PROGRAM_BINARY_FORMATS = 0x87FE;
	public var PROGRAM_BINARY_FORMATS = 0x87FF;

	@:noCompletion private function new() {}

	// void glGetProgramBinary (GLuint program, GLsizei bufSize, GLsizei *length, GLenum *binaryFormat, void *binary)
	// void glProgramBinary (GLuint program, GLenum binaryFormat, const void *binary, GLsizei length)
	// void glProgramParameteri (GLuint program, GLenum pname, GLint value)
}
