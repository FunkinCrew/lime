package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_memory_attachment
{
	public var ATTACHED_MEMORY_OBJECT_NV = 0x95A4;
	public var ATTACHED_MEMORY_OFFSET_NV = 0x95A5;
	public var MEMORY_ATTACHABLE_ALIGNMENT_NV = 0x95A6;
	public var MEMORY_ATTACHABLE_SIZE_NV = 0x95A7;
	public var MEMORY_ATTACHABLE_NV = 0x95A8;
	public var DETACHED_MEMORY_INCARNATION_NV = 0x95A9;
	public var DETACHED_TEXTURES_NV = 0x95AA;
	public var DETACHED_BUFFERS_NV = 0x95AB;
	public var MAX_DETACHED_TEXTURES_NV = 0x95AC;
	public var MAX_DETACHED_BUFFERS_NV = 0x95AD;

	@:noCompletion private function new() {}

	// void glGetMemoryObjectDetachedResourcesuivNV (GLuint memory, GLenum pname, GLint first, GLsizei count, GLuint *params)
	// void glResetMemoryObjectParameterNV (GLuint memory, GLenum pname)
	// void glTexAttachMemoryNV (GLenum target, GLuint memory, GLuint64 offset)
	// void glBufferAttachMemoryNV (GLenum target, GLuint memory, GLuint64 offset)
}
