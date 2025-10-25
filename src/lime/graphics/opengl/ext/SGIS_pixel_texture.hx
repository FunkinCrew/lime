package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIS_pixel_texture
{
	public var PIXEL_TEXTURE_SGIS = 0x8353;
	public var PIXEL_FRAGMENT_RGB_SOURCE_SGIS = 0x8354;
	public var PIXEL_FRAGMENT_ALPHA_SOURCE_SGIS = 0x8355;
	public var PIXEL_GROUP_COLOR_SGIS = 0x8356;

	@:noCompletion private function new() {}

	// void glPixelTexGenParameteriSGIS (GLenum pname, GLint param)
	// void glPixelTexGenParameterivSGIS (GLenum pname, const GLint *params)
	// void glPixelTexGenParameterfSGIS (GLenum pname, GLfloat param)
	// void glPixelTexGenParameterfvSGIS (GLenum pname, const GLfloat *params)
	// void glGetPixelTexGenParameterivSGIS (GLenum pname, GLint *params)
	// void glGetPixelTexGenParameterfvSGIS (GLenum pname, GLfloat *params)
}
