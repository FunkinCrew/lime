package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_mapbuffer
{
	public var WRITE_ONLY_OES = 0x88B9;
	public var BUFFER_ACCESS_OES = 0x88BB;
	public var BUFFER_MAPPED_OES = 0x88BC;
	public var BUFFER_MAP_POINTER_OES = 0x88BD;

	@:noCompletion private function new() {}

	// void * glMapBufferOES (GLenum target, GLenum access)
	// GLboolean glUnmapBufferOES (GLenum target)
	// void glGetBufferPointervOES (GLenum target, GLenum pname, void **params)
}
