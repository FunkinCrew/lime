package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_coordinate_frame
{
	public var TANGENT_ARRAY_EXT = 0x8439;
	public var BINORMAL_ARRAY_EXT = 0x843A;
	public var CURRENT_TANGENT_EXT = 0x843B;
	public var CURRENT_BINORMAL_EXT = 0x843C;
	public var TANGENT_ARRAY_TYPE_EXT = 0x843E;
	public var TANGENT_ARRAY_STRIDE_EXT = 0x843F;
	public var BINORMAL_ARRAY_TYPE_EXT = 0x8440;
	public var BINORMAL_ARRAY_STRIDE_EXT = 0x8441;
	public var TANGENT_ARRAY_POINTER_EXT = 0x8442;
	public var BINORMAL_ARRAY_POINTER_EXT = 0x8443;
	public var MAP1_TANGENT_EXT = 0x8444;
	public var MAP2_TANGENT_EXT = 0x8445;
	public var MAP1_BINORMAL_EXT = 0x8446;
	public var MAP2_BINORMAL_EXT = 0x8447;

	@:noCompletion private function new() {}

	// void glTangent3bEXT (GLbyte tx, GLbyte ty, GLbyte tz)
	// void glTangent3bvEXT (const GLbyte *v)
	// void glTangent3dEXT (GLdouble tx, GLdouble ty, GLdouble tz)
	// void glTangent3dvEXT (const GLdouble *v)
	// void glTangent3fEXT (GLfloat tx, GLfloat ty, GLfloat tz)
	// void glTangent3fvEXT (const GLfloat *v)
	// void glTangent3iEXT (GLint tx, GLint ty, GLint tz)
	// void glTangent3ivEXT (const GLint *v)
	// void glTangent3sEXT (GLshort tx, GLshort ty, GLshort tz)
	// void glTangent3svEXT (const GLshort *v)
	// void glBinormal3bEXT (GLbyte bx, GLbyte by, GLbyte bz)
	// void glBinormal3bvEXT (const GLbyte *v)
	// void glBinormal3dEXT (GLdouble bx, GLdouble by, GLdouble bz)
	// void glBinormal3dvEXT (const GLdouble *v)
	// void glBinormal3fEXT (GLfloat bx, GLfloat by, GLfloat bz)
	// void glBinormal3fvEXT (const GLfloat *v)
	// void glBinormal3iEXT (GLint bx, GLint by, GLint bz)
	// void glBinormal3ivEXT (const GLint *v)
	// void glBinormal3sEXT (GLshort bx, GLshort by, GLshort bz)
	// void glBinormal3svEXT (const GLshort *v)
	// void glTangentPointerEXT (GLenum type, GLsizei stride, const void *pointer)
	// void glBinormalPointerEXT (GLenum type, GLsizei stride, const void *pointer)
}
