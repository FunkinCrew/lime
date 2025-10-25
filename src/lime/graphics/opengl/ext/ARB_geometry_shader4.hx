package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_geometry_shader4
{
	public var LINES_ADJACENCY_ARB = 0x000A;
	public var LINE_STRIP_ADJACENCY_ARB = 0x000B;
	public var TRIANGLES_ADJACENCY_ARB = 0x000C;
	public var TRIANGLE_STRIP_ADJACENCY_ARB = 0x000D;
	public var PROGRAM_POINT_SIZE_ARB = 0x8642;
	public var MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_ARB = 0x8C29;
	public var FRAMEBUFFER_ATTACHMENT_LAYERED_ARB = 0x8DA7;
	public var FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_ARB = 0x8DA8;
	public var FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_ARB = 0x8DA9;
	public var GEOMETRY_SHADER_ARB = 0x8DD9;
	public var GEOMETRY_VERTICES_OUT_ARB = 0x8DDA;
	public var GEOMETRY_INPUT_TYPE_ARB = 0x8DDB;
	public var GEOMETRY_OUTPUT_TYPE_ARB = 0x8DDC;
	public var MAX_GEOMETRY_VARYING_COMPONENTS_ARB = 0x8DDD;
	public var MAX_VERTEX_VARYING_COMPONENTS_ARB = 0x8DDE;
	public var MAX_GEOMETRY_UNIFORM_COMPONENTS_ARB = 0x8DDF;
	public var MAX_GEOMETRY_OUTPUT_VERTICES_ARB = 0x8DE0;
	public var MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_ARB = 0x8DE1;
	public var MAX_VARYING_COMPONENTS = 0x8B4B;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;

	@:noCompletion private function new() {}

	// void glProgramParameteriARB (GLuint program, GLenum pname, GLint value)
	// void glFramebufferTextureARB (GLenum target, GLenum attachment, GLuint texture, GLint level)
	// void glFramebufferTextureLayerARB (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer)
	// void glFramebufferTextureFaceARB (GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face)
}
