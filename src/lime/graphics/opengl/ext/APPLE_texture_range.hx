package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_texture_range
{
	public var TEXTURE_RANGE_LENGTH_APPLE = 0x85B7;
	public var TEXTURE_RANGE_POINTER_APPLE = 0x85B8;
	public var TEXTURE_STORAGE_HINT_APPLE = 0x85BC;
	public var STORAGE_PRIVATE_APPLE = 0x85BD;
	public var STORAGE_CACHED_APPLE = 0x85BE;
	public var STORAGE_SHARED_APPLE = 0x85BF;

	@:noCompletion private function new() {}

	// void glTextureRangeAPPLE (GLenum target, GLsizei length, const void *pointer)
	// void glGetTexParameterPointervAPPLE (GLenum target, GLenum pname, void **params)
}
