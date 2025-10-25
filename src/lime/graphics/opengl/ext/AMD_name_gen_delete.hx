package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_name_gen_delete
{
	public var DATA_BUFFER_AMD = 0x9151;
	public var PERFORMANCE_MONITOR_AMD = 0x9152;
	public var QUERY_OBJECT_AMD = 0x9153;
	public var VERTEX_ARRAY_OBJECT_AMD = 0x9154;
	public var SAMPLER_OBJECT_AMD = 0x9155;

	@:noCompletion private function new() {}

	// void glGenNamesAMD (GLenum identifier, GLuint num, GLuint *names)
	// void glDeleteNamesAMD (GLenum identifier, GLuint num, const GLuint *names)
	// GLboolean glIsNameAMD (GLenum identifier, GLuint name)
}
