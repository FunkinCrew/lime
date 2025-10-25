package lime.graphics.opengl.ext;

@:keep
@:noCompletion class INTEL_map_texture
{
	public var TEXTURE_MEMORY_LAYOUT_INTEL = 0x83FF;
	public var LAYOUT_DEFAULT_INTEL = 0;
	public var LAYOUT_LINEAR_INTEL = 1;
	public var LAYOUT_LINEAR_CPU_CACHED_INTEL = 2;

	@:noCompletion private function new() {}

	// void glSyncTextureINTEL (GLuint texture)
	// void glUnmapTexture2DINTEL (GLuint texture, GLint level)
	// void * glMapTexture2DINTEL (GLuint texture, GLint level, GLbitfield access, GLint *stride, GLenum *layout)
}
