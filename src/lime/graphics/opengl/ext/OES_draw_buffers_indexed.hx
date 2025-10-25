package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OES_draw_buffers_indexed
{
	public var BLEND_EQUATION_RGB = 0x8009;
	public var BLEND_EQUATION_ALPHA = 0x883D;
	public var BLEND_SRC_RGB = 0x80C9;
	public var BLEND_SRC_ALPHA = 0x80CB;
	public var BLEND_DST_RGB = 0x80C8;
	public var BLEND_DST_ALPHA = 0x80CA;
	public var COLOR_WRITEMASK = 0x0C23;
	public var BLEND = 0x0BE2;
	public var FUNC_ADD = 0x8006;
	public var FUNC_SUBTRACT = 0x800A;
	public var FUNC_REVERSE_SUBTRACT = 0x800B;
	public var MIN = 0x8007;
	public var MAX = 0x8008;
	public var ZERO = 0;
	public var ONE = 1;
	public var SRC_COLOR = 0x0300;
	public var ONE_MINUS_SRC_COLOR = 0x0301;
	public var DST_COLOR = 0x0306;
	public var ONE_MINUS_DST_COLOR = 0x0307;
	public var SRC_ALPHA = 0x0302;
	public var ONE_MINUS_SRC_ALPHA = 0x0303;
	public var DST_ALPHA = 0x0304;
	public var ONE_MINUS_DST_ALPHA = 0x0305;
	public var CONSTANT_COLOR = 0x8001;
	public var ONE_MINUS_CONSTANT_COLOR = 0x8002;
	public var CONSTANT_ALPHA = 0x8003;
	public var ONE_MINUS_CONSTANT_ALPHA = 0x8004;
	public var SRC_ALPHA_SATURATE = 0x0308;

	@:noCompletion private function new() {}

	// void glEnableiOES (GLenum target, GLuint index)
	// void glDisableiOES (GLenum target, GLuint index)
	// void glBlendEquationiOES (GLuint buf, GLenum mode)
	// void glBlendEquationSeparateiOES (GLuint buf, GLenum modeRGB, GLenum modeAlpha)
	// void glBlendFunciOES (GLuint buf, GLenum src, GLenum dst)
	// void glBlendFuncSeparateiOES (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha)
	// void glColorMaskiOES (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a)
	// GLboolean glIsEnablediOES (GLenum target, GLuint index)
}
