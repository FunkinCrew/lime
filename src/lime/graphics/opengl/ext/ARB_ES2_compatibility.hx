package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_ES2_compatibility
{
	public var FIXED = 0x140C;
	public var IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A;
	public var IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
	public var LOW_FLOAT = 0x8DF0;
	public var MEDIUM_FLOAT = 0x8DF1;
	public var HIGH_FLOAT = 0x8DF2;
	public var LOW_INT = 0x8DF3;
	public var MEDIUM_INT = 0x8DF4;
	public var HIGH_INT = 0x8DF5;
	public var SHADER_COMPILER = 0x8DFA;
	public var SHADER_BINARY_FORMATS = 0x8DF8;
	public var NUM_SHADER_BINARY_FORMATS = 0x8DF9;
	public var MAX_VERTEX_UNIFORM_VECTORS = 0x8DFB;
	public var MAX_VARYING_VECTORS = 0x8DFC;
	public var MAX_FRAGMENT_UNIFORM_VECTORS = 0x8DFD;
	public var RGB565 = 0x8D62;

	@:noCompletion private function new() {}

	// void glReleaseShaderCompiler ()
	// void glShaderBinary (GLsizei count, const GLuint *shaders, GLenum binaryFormat, const void *binary, GLsizei length)
	// void glGetShaderPrecisionFormat (GLenum shadertype, GLenum precisiontype, GLint *range, GLint *precision)
	// void glDepthRangef (GLfloat n, GLfloat f)
	// void glClearDepthf (GLfloat d)
}
