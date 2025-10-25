package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_bindable_uniform
{
	public var MAX_VERTEX_BINDABLE_UNIFORMS_EXT = 0x8DE2;
	public var MAX_FRAGMENT_BINDABLE_UNIFORMS_EXT = 0x8DE3;
	public var MAX_GEOMETRY_BINDABLE_UNIFORMS_EXT = 0x8DE4;
	public var MAX_BINDABLE_UNIFORM_SIZE_EXT = 0x8DED;
	public var UNIFORM_BUFFER_EXT = 0x8DEE;
	public var UNIFORM_BUFFER_BINDING_EXT = 0x8DEF;

	@:noCompletion private function new() {}

	// void glUniformBufferEXT (GLuint program, GLint location, GLuint buffer)
	// GLint glGetUniformBufferSizeEXT (GLuint program, GLint location)
	// GLintptr glGetUniformOffsetEXT (GLuint program, GLint location)
}
