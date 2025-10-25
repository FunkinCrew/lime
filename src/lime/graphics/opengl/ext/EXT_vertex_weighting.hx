package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_vertex_weighting
{
	public var MODELVIEW0_STACK_DEPTH_EXT = 0x0BA3;
	public var MODELVIEW1_STACK_DEPTH_EXT = 0x8502;
	public var MODELVIEW0_MATRIX_EXT = 0x0BA6;
	public var MODELVIEW1_MATRIX_EXT = 0x8506;
	public var VERTEX_WEIGHTING_EXT = 0x8509;
	public var MODELVIEW0_EXT = 0x1700;
	public var MODELVIEW1_EXT = 0x850A;
	public var CURRENT_VERTEX_WEIGHT_EXT = 0x850B;
	public var VERTEX_WEIGHT_ARRAY_EXT = 0x850C;
	public var VERTEX_WEIGHT_ARRAY_SIZE_EXT = 0x850D;
	public var VERTEX_WEIGHT_ARRAY_TYPE_EXT = 0x850E;
	public var VERTEX_WEIGHT_ARRAY_STRIDE_EXT = 0x850F;
	public var VERTEX_WEIGHT_ARRAY_POINTER_EXT = 0x8510;

	@:noCompletion private function new() {}

	// void glVertexWeightfEXT (GLfloat weight)
	// void glVertexWeightfvEXT (const GLfloat *weight)
	// void glVertexWeightPointerEXT (GLint size, GLenum type, GLsizei stride, const void *pointer)
}
