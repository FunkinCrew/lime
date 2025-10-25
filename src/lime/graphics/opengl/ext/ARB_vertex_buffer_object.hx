package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_vertex_buffer_object
{
	public var BUFFER_SIZE_ARB = 0x8764;
	public var BUFFER_USAGE_ARB = 0x8765;
	public var ARRAY_BUFFER_ARB = 0x8892;
	public var ELEMENT_ARRAY_BUFFER_ARB = 0x8893;
	public var ARRAY_BUFFER_BINDING_ARB = 0x8894;
	public var ELEMENT_ARRAY_BUFFER_BINDING_ARB = 0x8895;
	public var VERTEX_ARRAY_BUFFER_BINDING_ARB = 0x8896;
	public var NORMAL_ARRAY_BUFFER_BINDING_ARB = 0x8897;
	public var COLOR_ARRAY_BUFFER_BINDING_ARB = 0x8898;
	public var INDEX_ARRAY_BUFFER_BINDING_ARB = 0x8899;
	public var TEXTURE_COORD_ARRAY_BUFFER_BINDING_ARB = 0x889A;
	public var EDGE_FLAG_ARRAY_BUFFER_BINDING_ARB = 0x889B;
	public var SECONDARY_COLOR_ARRAY_BUFFER_BINDING_ARB = 0x889C;
	public var FOG_COORDINATE_ARRAY_BUFFER_BINDING_ARB = 0x889D;
	public var WEIGHT_ARRAY_BUFFER_BINDING_ARB = 0x889E;
	public var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING_ARB = 0x889F;
	public var READ_ONLY_ARB = 0x88B8;
	public var WRITE_ONLY_ARB = 0x88B9;
	public var READ_WRITE_ARB = 0x88BA;
	public var BUFFER_ACCESS_ARB = 0x88BB;
	public var BUFFER_MAPPED_ARB = 0x88BC;
	public var BUFFER_MAP_POINTER_ARB = 0x88BD;
	public var STREAM_DRAW_ARB = 0x88E0;
	public var STREAM_READ_ARB = 0x88E1;
	public var STREAM_COPY_ARB = 0x88E2;
	public var STATIC_DRAW_ARB = 0x88E4;
	public var STATIC_READ_ARB = 0x88E5;
	public var STATIC_COPY_ARB = 0x88E6;
	public var DYNAMIC_DRAW_ARB = 0x88E8;
	public var DYNAMIC_READ_ARB = 0x88E9;
	public var DYNAMIC_COPY_ARB = 0x88EA;

	@:noCompletion private function new() {}

	// void glBindBufferARB (GLenum target, GLuint buffer)
	// void glDeleteBuffersARB (GLsizei n, const GLuint *buffers)
	// void glGenBuffersARB (GLsizei n, GLuint *buffers)
	// GLboolean glIsBufferARB (GLuint buffer)
	// void glBufferDataARB (GLenum target, GLsizeiptrARB size, const void *data, GLenum usage)
	// void glBufferSubDataARB (GLenum target, GLintptrARB offset, GLsizeiptrARB size, const void *data)
	// void glGetBufferSubDataARB (GLenum target, GLintptrARB offset, GLsizeiptrARB size, void *data)
	// void * glMapBufferARB (GLenum target, GLenum access)
	// GLboolean glUnmapBufferARB (GLenum target)
	// void glGetBufferParameterivARB (GLenum target, GLenum pname, GLint *params)
	// void glGetBufferPointervARB (GLenum target, GLenum pname, void **params)
}
