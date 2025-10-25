package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_vertex_buffer_unified_memory
{
	public var VERTEX_ATTRIB_ARRAY_UNIFIED_NV = 0x8F1E;
	public var ELEMENT_ARRAY_UNIFIED_NV = 0x8F1F;
	public var VERTEX_ATTRIB_ARRAY_ADDRESS_NV = 0x8F20;
	public var VERTEX_ARRAY_ADDRESS_NV = 0x8F21;
	public var NORMAL_ARRAY_ADDRESS_NV = 0x8F22;
	public var COLOR_ARRAY_ADDRESS_NV = 0x8F23;
	public var INDEX_ARRAY_ADDRESS_NV = 0x8F24;
	public var TEXTURE_COORD_ARRAY_ADDRESS_NV = 0x8F25;
	public var EDGE_FLAG_ARRAY_ADDRESS_NV = 0x8F26;
	public var SECONDARY_COLOR_ARRAY_ADDRESS_NV = 0x8F27;
	public var FOG_COORD_ARRAY_ADDRESS_NV = 0x8F28;
	public var ELEMENT_ARRAY_ADDRESS_NV = 0x8F29;
	public var VERTEX_ATTRIB_ARRAY_LENGTH_NV = 0x8F2A;
	public var VERTEX_ARRAY_LENGTH_NV = 0x8F2B;
	public var NORMAL_ARRAY_LENGTH_NV = 0x8F2C;
	public var COLOR_ARRAY_LENGTH_NV = 0x8F2D;
	public var INDEX_ARRAY_LENGTH_NV = 0x8F2E;
	public var TEXTURE_COORD_ARRAY_LENGTH_NV = 0x8F2F;
	public var EDGE_FLAG_ARRAY_LENGTH_NV = 0x8F30;
	public var SECONDARY_COLOR_ARRAY_LENGTH_NV = 0x8F31;
	public var FOG_COORD_ARRAY_LENGTH_NV = 0x8F32;
	public var ELEMENT_ARRAY_LENGTH_NV = 0x8F33;
	public var DRAW_INDIRECT_UNIFIED_NV = 0x8F40;
	public var DRAW_INDIRECT_ADDRESS_NV = 0x8F41;
	public var DRAW_INDIRECT_LENGTH_NV = 0x8F42;

	@:noCompletion private function new() {}

	// void glBufferAddressRangeNV (GLenum pname, GLuint index, GLuint64EXT address, GLsizeiptr length)
	// void glVertexFormatNV (GLint size, GLenum type, GLsizei stride)
	// void glNormalFormatNV (GLenum type, GLsizei stride)
	// void glColorFormatNV (GLint size, GLenum type, GLsizei stride)
	// void glIndexFormatNV (GLenum type, GLsizei stride)
	// void glTexCoordFormatNV (GLint size, GLenum type, GLsizei stride)
	// void glEdgeFlagFormatNV (GLsizei stride)
	// void glSecondaryColorFormatNV (GLint size, GLenum type, GLsizei stride)
	// void glFogCoordFormatNV (GLenum type, GLsizei stride)
	// void glVertexAttribFormatNV (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride)
	// void glVertexAttribIFormatNV (GLuint index, GLint size, GLenum type, GLsizei stride)
	// void glGetIntegerui64i_vNV (GLenum value, GLuint index, GLuint64EXT *result)
}
