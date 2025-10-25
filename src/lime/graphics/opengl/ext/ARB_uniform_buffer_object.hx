package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_uniform_buffer_object
{
	public var UNIFORM_BUFFER = 0x8A11;
	public var UNIFORM_BUFFER_BINDING = 0x8A28;
	public var UNIFORM_BUFFER_START = 0x8A29;
	public var UNIFORM_BUFFER_SIZE = 0x8A2A;
	public var MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;
	public var MAX_GEOMETRY_UNIFORM_BLOCKS = 0x8A2C;
	public var MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;
	public var MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;
	public var MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;
	public var MAX_UNIFORM_BLOCK_SIZE = 0x8A30;
	public var MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
	public var MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32;
	public var MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
	public var UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
	public var ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35;
	public var ACTIVE_UNIFORM_BLOCKS = 0x8A36;
	public var UNIFORM_TYPE = 0x8A37;
	public var UNIFORM_SIZE = 0x8A38;
	public var UNIFORM_NAME_LENGTH = 0x8A39;
	public var UNIFORM_BLOCK_INDEX = 0x8A3A;
	public var UNIFORM_OFFSET = 0x8A3B;
	public var UNIFORM_ARRAY_STRIDE = 0x8A3C;
	public var UNIFORM_MATRIX_STRIDE = 0x8A3D;
	public var UNIFORM_IS_ROW_MAJOR = 0x8A3E;
	public var UNIFORM_BLOCK_BINDING = 0x8A3F;
	public var UNIFORM_BLOCK_DATA_SIZE = 0x8A40;
	public var UNIFORM_BLOCK_NAME_LENGTH = 0x8A41;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
	public var UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
	public var UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45;
	public var UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
	public var INVALID_INDEX = 0xFFFFFFFF;

	@:noCompletion private function new() {}

	// void glGetUniformIndices (GLuint program, GLsizei uniformCount, const GLchar *const*uniformNames, GLuint *uniformIndices)
	// void glGetActiveUniformsiv (GLuint program, GLsizei uniformCount, const GLuint *uniformIndices, GLenum pname, GLint *params)
	// void glGetActiveUniformName (GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformName)
	// GLuint glGetUniformBlockIndex (GLuint program, const GLchar *uniformBlockName)
	// void glGetActiveUniformBlockiv (GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint *params)
	// void glGetActiveUniformBlockName (GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformBlockName)
	// void glUniformBlockBinding (GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding)
	// void glBindBufferRange (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size)
	// void glBindBufferBase (GLenum target, GLuint index, GLuint buffer)
	// void glGetIntegeri_v (GLenum target, GLuint index, GLint *data)
}
