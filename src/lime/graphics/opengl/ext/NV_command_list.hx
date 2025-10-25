package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_command_list
{
	public var TERMINATE_SEQUENCE_COMMAND_NV = 0x0000;
	public var NOP_COMMAND_NV = 0x0001;
	public var DRAW_ELEMENTS_COMMAND_NV = 0x0002;
	public var DRAW_ARRAYS_COMMAND_NV = 0x0003;
	public var DRAW_ELEMENTS_STRIP_COMMAND_NV = 0x0004;
	public var DRAW_ARRAYS_STRIP_COMMAND_NV = 0x0005;
	public var DRAW_ELEMENTS_INSTANCED_COMMAND_NV = 0x0006;
	public var DRAW_ARRAYS_INSTANCED_COMMAND_NV = 0x0007;
	public var ELEMENT_ADDRESS_COMMAND_NV = 0x0008;
	public var ATTRIBUTE_ADDRESS_COMMAND_NV = 0x0009;
	public var UNIFORM_ADDRESS_COMMAND_NV = 0x000A;
	public var BLEND_COLOR_COMMAND_NV = 0x000B;
	public var STENCIL_REF_COMMAND_NV = 0x000C;
	public var LINE_WIDTH_COMMAND_NV = 0x000D;
	public var POLYGON_OFFSET_COMMAND_NV = 0x000E;
	public var ALPHA_REF_COMMAND_NV = 0x000F;
	public var VIEWPORT_COMMAND_NV = 0x0010;
	public var SCISSOR_COMMAND_NV = 0x0011;
	public var FRONT_FACE_COMMAND_NV = 0x0012;

	@:noCompletion private function new() {}

	// void glCreateStatesNV (GLsizei n, GLuint *states)
	// void glDeleteStatesNV (GLsizei n, const GLuint *states)
	// GLboolean glIsStateNV (GLuint state)
	// void glStateCaptureNV (GLuint state, GLenum mode)
	// GLuint glGetCommandHeaderNV (GLenum tokenID, GLuint size)
	// GLushort glGetStageIndexNV (GLenum shadertype)
	// void glDrawCommandsNV (GLenum primitiveMode, GLuint buffer, const GLintptr *indirects, const GLsizei *sizes, GLuint count)
	// void glDrawCommandsAddressNV (GLenum primitiveMode, const GLuint64 *indirects, const GLsizei *sizes, GLuint count)
	// void glDrawCommandsStatesNV (GLuint buffer, const GLintptr *indirects, const GLsizei *sizes, const GLuint *states, const GLuint *fbos, GLuint count)
	// void glDrawCommandsStatesAddressNV (const GLuint64 *indirects, const GLsizei *sizes, const GLuint *states, const GLuint *fbos, GLuint count)
	// void glCreateCommandListsNV (GLsizei n, GLuint *lists)
	// void glDeleteCommandListsNV (GLsizei n, const GLuint *lists)
	// GLboolean glIsCommandListNV (GLuint list)
	// void glListDrawCommandsStatesClientNV (GLuint list, GLuint segment, const void **indirects, const GLsizei *sizes, const GLuint *states, const GLuint *fbos, GLuint count)
	// void glCommandListSegmentsNV (GLuint list, GLuint segments)
	// void glCompileCommandListNV (GLuint list)
	// void glCallCommandListNV (GLuint list)
}
