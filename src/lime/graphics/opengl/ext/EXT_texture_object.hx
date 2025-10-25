package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_texture_object
{
	public var TEXTURE_PRIORITY_EXT = 0x8066;
	public var TEXTURE_RESIDENT_EXT = 0x8067;
	public var TEXTURE_1D_BINDING_EXT = 0x8068;
	public var TEXTURE_2D_BINDING_EXT = 0x8069;
	public var TEXTURE_3D_BINDING_EXT = 0x806A;

	@:noCompletion private function new() {}

	// GLboolean glAreTexturesResidentEXT (GLsizei n, const GLuint *textures, GLboolean *residences)
	// void glBindTextureEXT (GLenum target, GLuint texture)
	// void glDeleteTexturesEXT (GLsizei n, const GLuint *textures)
	// void glGenTexturesEXT (GLsizei n, GLuint *textures)
	// GLboolean glIsTextureEXT (GLuint texture)
	// void glPrioritizeTexturesEXT (GLsizei n, const GLuint *textures, const GLclampf *priorities)
}
