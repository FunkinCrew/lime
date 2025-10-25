package lime.graphics.opengl.ext;

@:keep
@:noCompletion class APPLE_object_purgeable
{
	public var BUFFER_OBJECT_APPLE = 0x85B3;
	public var RELEASED_APPLE = 0x8A19;
	public var VOLATILE_APPLE = 0x8A1A;
	public var RETAINED_APPLE = 0x8A1B;
	public var UNDEFINED_APPLE = 0x8A1C;
	public var PURGEABLE_APPLE = 0x8A1D;

	@:noCompletion private function new() {}

	// GLenum glObjectPurgeableAPPLE (GLenum objectType, GLuint name, GLenum option)
	// GLenum glObjectUnpurgeableAPPLE (GLenum objectType, GLuint name, GLenum option)
	// void glGetObjectParameterivAPPLE (GLenum objectType, GLuint name, GLenum pname, GLint *params)
}
