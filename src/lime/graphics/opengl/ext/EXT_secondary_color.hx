package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_secondary_color
{
	public var COLOR_SUM_EXT = 0x8458;
	public var CURRENT_SECONDARY_COLOR_EXT = 0x8459;
	public var SECONDARY_COLOR_ARRAY_SIZE_EXT = 0x845A;
	public var SECONDARY_COLOR_ARRAY_TYPE_EXT = 0x845B;
	public var SECONDARY_COLOR_ARRAY_STRIDE_EXT = 0x845C;
	public var SECONDARY_COLOR_ARRAY_POINTER_EXT = 0x845D;
	public var SECONDARY_COLOR_ARRAY_EXT = 0x845E;

	@:noCompletion private function new() {}

	// void glSecondaryColor3bEXT (GLbyte red, GLbyte green, GLbyte blue)
	// void glSecondaryColor3bvEXT (const GLbyte *v)
	// void glSecondaryColor3dEXT (GLdouble red, GLdouble green, GLdouble blue)
	// void glSecondaryColor3dvEXT (const GLdouble *v)
	// void glSecondaryColor3fEXT (GLfloat red, GLfloat green, GLfloat blue)
	// void glSecondaryColor3fvEXT (const GLfloat *v)
	// void glSecondaryColor3iEXT (GLint red, GLint green, GLint blue)
	// void glSecondaryColor3ivEXT (const GLint *v)
	// void glSecondaryColor3sEXT (GLshort red, GLshort green, GLshort blue)
	// void glSecondaryColor3svEXT (const GLshort *v)
	// void glSecondaryColor3ubEXT (GLubyte red, GLubyte green, GLubyte blue)
	// void glSecondaryColor3ubvEXT (const GLubyte *v)
	// void glSecondaryColor3uiEXT (GLuint red, GLuint green, GLuint blue)
	// void glSecondaryColor3uivEXT (const GLuint *v)
	// void glSecondaryColor3usEXT (GLushort red, GLushort green, GLushort blue)
	// void glSecondaryColor3usvEXT (const GLushort *v)
	// void glSecondaryColorPointerEXT (GLint size, GLenum type, GLsizei stride, const void *pointer)
}
