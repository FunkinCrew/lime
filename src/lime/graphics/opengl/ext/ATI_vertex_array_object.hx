package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_vertex_array_object
{
	public var STATIC_ATI = 0x8760;
	public var DYNAMIC_ATI = 0x8761;
	public var PRESERVE_ATI = 0x8762;
	public var DISCARD_ATI = 0x8763;
	public var OBJECT_BUFFER_SIZE_ATI = 0x8764;
	public var OBJECT_BUFFER_USAGE_ATI = 0x8765;
	public var ARRAY_OBJECT_BUFFER_ATI = 0x8766;
	public var ARRAY_OBJECT_OFFSET_ATI = 0x8767;

	@:noCompletion private function new() {}

	// GLuint glNewObjectBufferATI (GLsizei size, const void *pointer, GLenum usage)
	// GLboolean glIsObjectBufferATI (GLuint buffer)
	// void glUpdateObjectBufferATI (GLuint buffer, GLuint offset, GLsizei size, const void *pointer, GLenum preserve)
	// void glGetObjectBufferfvATI (GLuint buffer, GLenum pname, GLfloat *params)
	// void glGetObjectBufferivATI (GLuint buffer, GLenum pname, GLint *params)
	// void glFreeObjectBufferATI (GLuint buffer)
	// void glArrayObjectATI (GLenum array, GLint size, GLenum type, GLsizei stride, GLuint buffer, GLuint offset)
	// void glGetArrayObjectfvATI (GLenum array, GLenum pname, GLfloat *params)
	// void glGetArrayObjectivATI (GLenum array, GLenum pname, GLint *params)
	// void glVariantArrayObjectATI (GLuint id, GLenum type, GLsizei stride, GLuint buffer, GLuint offset)
	// void glGetVariantArrayObjectfvATI (GLuint id, GLenum pname, GLfloat *params)
	// void glGetVariantArrayObjectivATI (GLuint id, GLenum pname, GLint *params)
}
