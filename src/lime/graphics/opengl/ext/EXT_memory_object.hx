package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_memory_object
{
	public var TEXTURE_TILING_EXT = 0x9580;
	public var DEDICATED_MEMORY_OBJECT_EXT = 0x9581;
	public var PROTECTED_MEMORY_OBJECT_EXT = 0x959B;
	public var NUM_TILING_TYPES_EXT = 0x9582;
	public var TILING_TYPES_EXT = 0x9583;
	public var OPTIMAL_TILING_EXT = 0x9584;
	public var LINEAR_TILING_EXT = 0x9585;
	public var NUM_DEVICE_UUIDS_EXT = 0x9596;
	public var DEVICE_UUID_EXT = 0x9597;
	public var DRIVER_UUID_EXT = 0x9598;
	public var UUID_SIZE_EXT = 16;

	@:noCompletion private function new() {}

	// void glGetUnsignedBytevEXT (GLenum pname, GLubyte *data)
	// void glGetUnsignedBytei_vEXT (GLenum target, GLuint index, GLubyte *data)
	// void glDeleteMemoryObjectsEXT (GLsizei n, const GLuint *memoryObjects)
	// GLboolean glIsMemoryObjectEXT (GLuint memoryObject)
	// void glCreateMemoryObjectsEXT (GLsizei n, GLuint *memoryObjects)
	// void glMemoryObjectParameterivEXT (GLuint memoryObject, GLenum pname, const GLint *params)
	// void glGetMemoryObjectParameterivEXT (GLuint memoryObject, GLenum pname, GLint *params)
	// void glTexStorageMem2DEXT (GLenum target, GLsizei levels, GLenum internalFormat, GLsizei width, GLsizei height, GLuint memory, GLuint64 offset)
	// void glTexStorageMem2DMultisampleEXT (GLenum target, GLsizei samples, GLenum internalFormat, GLsizei width, GLsizei height, GLboolean fixedSampleLocations, GLuint memory, GLuint64 offset)
	// void glTexStorageMem3DEXT (GLenum target, GLsizei levels, GLenum internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLuint memory, GLuint64 offset)
	// void glTexStorageMem3DMultisampleEXT (GLenum target, GLsizei samples, GLenum internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedSampleLocations, GLuint memory, GLuint64 offset)
	// void glBufferStorageMemEXT (GLenum target, GLsizeiptr size, GLuint memory, GLuint64 offset)
}
