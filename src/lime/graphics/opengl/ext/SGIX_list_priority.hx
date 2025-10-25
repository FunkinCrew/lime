package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_list_priority
{
	public var LIST_PRIORITY_SGIX = 0x8182;

	@:noCompletion private function new() {}

	// void glGetListParameterfvSGIX (GLuint list, GLenum pname, GLfloat *params)
	// void glGetListParameterivSGIX (GLuint list, GLenum pname, GLint *params)
	// void glListParameterfSGIX (GLuint list, GLenum pname, GLfloat param)
	// void glListParameterfvSGIX (GLuint list, GLenum pname, const GLfloat *params)
	// void glListParameteriSGIX (GLuint list, GLenum pname, GLint param)
	// void glListParameterivSGIX (GLuint list, GLenum pname, const GLint *params)
}
