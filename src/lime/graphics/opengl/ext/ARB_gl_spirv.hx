package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_gl_spirv
{
	public var SHADER_BINARY_FORMAT_SPIR_V_ARB = 0x9551;
	public var SPIR_V_BINARY_ARB = 0x9552;

	@:noCompletion private function new() {}

	// void glSpecializeShaderARB (GLuint shader, const GLchar *pEntryPoint, GLuint numSpecializationConstants, const GLuint *pConstantIndex, const GLuint *pConstantValue)
}
