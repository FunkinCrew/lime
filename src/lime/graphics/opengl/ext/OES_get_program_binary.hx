package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_get_program_binary
{
	public var PROGRAM_BINARY_LENGTH_OES = 0x8741;
	public var NUM_PROGRAM_BINARY_FORMATS_OES = 0x87FE;
	public var PROGRAM_BINARY_FORMATS_OES = 0x87FF;

	@:noCompletion private function new() {}

	// void glGetProgramBinaryOES (GLuint program, GLsizei bufSize, GLsizei *length, GLenum *binaryFormat, void *binary)
	// void glProgramBinaryOES (GLuint program, GLenum binaryFormat, const void *binary, GLint length)
}
