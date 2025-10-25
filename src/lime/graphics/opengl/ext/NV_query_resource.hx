package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_query_resource
{
	public var QUERY_RESOURCE_TYPE_VIDMEM_ALLOC_NV = 0x9540;
	public var QUERY_RESOURCE_MEMTYPE_VIDMEM_NV = 0x9542;
	public var QUERY_RESOURCE_SYS_RESERVED_NV = 0x9544;
	public var QUERY_RESOURCE_TEXTURE_NV = 0x9545;
	public var QUERY_RESOURCE_RENDERBUFFER_NV = 0x9546;
	public var QUERY_RESOURCE_BUFFEROBJECT_NV = 0x9547;

	@:noCompletion private function new() {}

	// GLint glQueryResourceNV (GLenum queryType, GLint tagId, GLuint count, GLint *buffer)
}
