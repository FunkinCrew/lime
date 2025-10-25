package lime.graphics.opengl.ext;

@:keep
@:noCompletion class OVR_multiview
{
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_NUM_VIEWS_OVR = 0x9630;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_BASE_VIEW_INDEX_OVR = 0x9632;
	public var MAX_VIEWS_OVR = 0x9631;
	public var FRAMEBUFFER_INCOMPLETE_VIEW_TARGETS_OVR = 0x9633;

	@:noCompletion private function new() {}

	// void glFramebufferTextureMultiviewOVR (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint baseViewIndex, GLsizei numViews)
}
