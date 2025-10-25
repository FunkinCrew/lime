package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_envmap_bumpmap
{
	public var BUMP_ROT_MATRIX_ATI = 0x8775;
	public var BUMP_ROT_MATRIX_SIZE_ATI = 0x8776;
	public var BUMP_NUM_TEX_UNITS_ATI = 0x8777;
	public var BUMP_TEX_UNITS_ATI = 0x8778;
	public var DUDV_ATI = 0x8779;
	public var DU8DV8_ATI = 0x877A;
	public var BUMP_ENVMAP_ATI = 0x877B;
	public var BUMP_TARGET_ATI = 0x877C;

	@:noCompletion private function new() {}

	// void glTexBumpParameterivATI (GLenum pname, const GLint *param)
	// void glTexBumpParameterfvATI (GLenum pname, const GLfloat *param)
	// void glGetTexBumpParameterivATI (GLenum pname, GLint *param)
	// void glGetTexBumpParameterfvATI (GLenum pname, GLfloat *param)
}
