package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_polynomial_ffd
{
	public var TEXTURE_DEFORMATION_BIT_SGIX = 0x00000001;
	public var GEOMETRY_DEFORMATION_BIT_SGIX = 0x00000002;
	public var GEOMETRY_DEFORMATION_SGIX = 0x8194;
	public var TEXTURE_DEFORMATION_SGIX = 0x8195;
	public var DEFORMATIONS_MASK_SGIX = 0x8196;
	public var MAX_DEFORMATION_ORDER_SGIX = 0x8197;

	@:noCompletion private function new() {}

	// void glDeformationMap3dSGIX (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble w1, GLdouble w2, GLint wstride, GLint worder, const GLdouble *points)
	// void glDeformationMap3fSGIX (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat w1, GLfloat w2, GLint wstride, GLint worder, const GLfloat *points)
	// void glDeformSGIX (GLbitfield mask)
	// void glLoadIdentityDeformationMapSGIX (GLbitfield mask)
}
