package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_vdpau_interop
{
	public var SURFACE_STATE_NV = 0x86EB;
	public var SURFACE_REGISTERED_NV = 0x86FD;
	public var SURFACE_MAPPED_NV = 0x8700;
	public var WRITE_DISCARD_NV = 0x88BE;

	@:noCompletion private function new() {}

	// void glVDPAUInitNV (const void *vdpDevice, const void *getProcAddress)
	// void glVDPAUFiniNV ()
	// GLvdpauSurfaceNV glVDPAURegisterVideoSurfaceNV (const void *vdpSurface, GLenum target, GLsizei numTextureNames, const GLuint *textureNames)
	// GLvdpauSurfaceNV glVDPAURegisterOutputSurfaceNV (const void *vdpSurface, GLenum target, GLsizei numTextureNames, const GLuint *textureNames)
	// GLboolean glVDPAUIsSurfaceNV (GLvdpauSurfaceNV surface)
	// void glVDPAUUnregisterSurfaceNV (GLvdpauSurfaceNV surface)
	// void glVDPAUGetSurfaceivNV (GLvdpauSurfaceNV surface, GLenum pname, GLsizei count, GLsizei *length, GLint *values)
	// void glVDPAUSurfaceAccessNV (GLvdpauSurfaceNV surface, GLenum access)
	// void glVDPAUMapSurfacesNV (GLsizei numSurfaces, const GLvdpauSurfaceNV *surfaces)
	// void glVDPAUUnmapSurfacesNV (GLsizei numSurface, const GLvdpauSurfaceNV *surfaces)
}
