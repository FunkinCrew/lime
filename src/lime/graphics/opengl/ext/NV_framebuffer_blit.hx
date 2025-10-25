package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_framebuffer_blit
{
	public var READ_FRAMEBUFFER_NV = 0x8CA8;
	public var DRAW_FRAMEBUFFER_NV = 0x8CA9;
	public var DRAW_FRAMEBUFFER_BINDING_NV = 0x8CA6;
	public var READ_FRAMEBUFFER_BINDING_NV = 0x8CAA;

	@:noCompletion private function new() {}

	// void glBlitFramebufferNV (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter)
}
