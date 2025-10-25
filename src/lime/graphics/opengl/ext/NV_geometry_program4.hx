package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_geometry_program4
{
	public var LINES_ADJACENCY_EXT = 0x000A;
	public var LINE_STRIP_ADJACENCY_EXT = 0x000B;
	public var TRIANGLES_ADJACENCY_EXT = 0x000C;
	public var TRIANGLE_STRIP_ADJACENCY_EXT = 0x000D;
	public var GEOMETRY_PROGRAM_NV = 0x8C26;
	public var MAX_PROGRAM_OUTPUT_VERTICES_NV = 0x8C27;
	public var MAX_PROGRAM_TOTAL_OUTPUT_COMPONENTS_NV = 0x8C28;
	public var GEOMETRY_VERTICES_OUT_EXT = 0x8DDA;
	public var GEOMETRY_INPUT_TYPE_EXT = 0x8DDB;
	public var GEOMETRY_OUTPUT_TYPE_EXT = 0x8DDC;
	public var MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_EXT = 0x8C29;
	public var FRAMEBUFFER_ATTACHMENT_LAYERED_EXT = 0x8DA7;
	public var FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_EXT = 0x8DA8;
	public var FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_EXT = 0x8DA9;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT = 0x8CD4;
	public var PROGRAM_POINT_SIZE_EXT = 0x8642;

	@:noCompletion private function new() {}

	// void glProgramVertexLimitNV (GLenum target, GLint limit)
	// void glFramebufferTextureEXT (GLenum target, GLenum attachment, GLuint texture, GLint level)
	// void glFramebufferTextureLayerEXT (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer)
	// void glFramebufferTextureFaceEXT (GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face)
}
