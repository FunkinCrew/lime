package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_separate_shader_objects
{
	public var ACTIVE_PROGRAM_EXT = 0x8B8D;

	@:noCompletion private function new() {}

	// void glUseShaderProgramEXT (GLenum type, GLuint program)
	// void glActiveProgramEXT (GLuint program)
	// GLuint glCreateShaderProgramEXT (GLenum type, const GLchar *string)
}
