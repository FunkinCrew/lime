package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_cull_vertex
{
	public var CULL_VERTEX_EXT = 0x81AA;
	public var CULL_VERTEX_EYE_POSITION_EXT = 0x81AB;
	public var CULL_VERTEX_OBJECT_POSITION_EXT = 0x81AC;

	@:noCompletion private function new() {}

	// void glCullParameterdvEXT (GLenum pname, GLdouble *params)
	// void glCullParameterfvEXT (GLenum pname, GLfloat *params)
}
