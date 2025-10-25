package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ARB_framebuffer_object
{
	public var INVALID_FRAMEBUFFER_OPERATION = 0x0506;
	public var FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
	public var FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
	public var FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
	public var FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
	public var FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
	public var FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
	public var FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
	public var FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
	public var FRAMEBUFFER_DEFAULT = 0x8218;
	public var FRAMEBUFFER_UNDEFINED = 0x8219;
	public var DEPTH_STENCIL_ATTACHMENT = 0x821A;
	public var MAX_RENDERBUFFER_SIZE = 0x84E8;
	public var DEPTH_STENCIL = 0x84F9;
	public var UNSIGNED_INT_24_8 = 0x84FA;
	public var DEPTH24_STENCIL8 = 0x88F0;
	public var TEXTURE_STENCIL_SIZE = 0x88F1;
	public var UNSIGNED_NORMALIZED = 0x8C17;
	public var FRAMEBUFFER_BINDING = 0x8CA6;
	public var DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
	public var RENDERBUFFER_BINDING = 0x8CA7;
	public var READ_FRAMEBUFFER = 0x8CA8;
	public var DRAW_FRAMEBUFFER = 0x8CA9;
	public var READ_FRAMEBUFFER_BINDING = 0x8CAA;
	public var RENDERBUFFER_SAMPLES = 0x8CAB;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
	public var FRAMEBUFFER_COMPLETE = 0x8CD5;
	public var FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
	public var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	public var FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDB;
	public var FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDC;
	public var FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
	public var MAX_COLOR_ATTACHMENTS = 0x8CDF;
	public var COLOR_ATTACHMENT0 = 0x8CE0;
	public var COLOR_ATTACHMENT1 = 0x8CE1;
	public var COLOR_ATTACHMENT2 = 0x8CE2;
	public var COLOR_ATTACHMENT3 = 0x8CE3;
	public var COLOR_ATTACHMENT4 = 0x8CE4;
	public var COLOR_ATTACHMENT5 = 0x8CE5;
	public var COLOR_ATTACHMENT6 = 0x8CE6;
	public var COLOR_ATTACHMENT7 = 0x8CE7;
	public var COLOR_ATTACHMENT8 = 0x8CE8;
	public var COLOR_ATTACHMENT9 = 0x8CE9;
	public var COLOR_ATTACHMENT10 = 0x8CEA;
	public var COLOR_ATTACHMENT11 = 0x8CEB;
	public var COLOR_ATTACHMENT12 = 0x8CEC;
	public var COLOR_ATTACHMENT13 = 0x8CED;
	public var COLOR_ATTACHMENT14 = 0x8CEE;
	public var COLOR_ATTACHMENT15 = 0x8CEF;
	public var DEPTH_ATTACHMENT = 0x8D00;
	public var STENCIL_ATTACHMENT = 0x8D20;
	public var FRAMEBUFFER = 0x8D40;
	public var RENDERBUFFER = 0x8D41;
	public var RENDERBUFFER_WIDTH = 0x8D42;
	public var RENDERBUFFER_HEIGHT = 0x8D43;
	public var RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;
	public var STENCIL_INDEX1 = 0x8D46;
	public var STENCIL_INDEX4 = 0x8D47;
	public var STENCIL_INDEX8 = 0x8D48;
	public var STENCIL_INDEX16 = 0x8D49;
	public var RENDERBUFFER_RED_SIZE = 0x8D50;
	public var RENDERBUFFER_GREEN_SIZE = 0x8D51;
	public var RENDERBUFFER_BLUE_SIZE = 0x8D52;
	public var RENDERBUFFER_ALPHA_SIZE = 0x8D53;
	public var RENDERBUFFER_DEPTH_SIZE = 0x8D54;
	public var RENDERBUFFER_STENCIL_SIZE = 0x8D55;
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
	public var MAX_SAMPLES = 0x8D57;

	@:noCompletion private function new() {}

	// GLboolean glIsRenderbuffer (GLuint renderbuffer)
	// void glBindRenderbuffer (GLenum target, GLuint renderbuffer)
	// void glDeleteRenderbuffers (GLsizei n, const GLuint *renderbuffers)
	// void glGenRenderbuffers (GLsizei n, GLuint *renderbuffers)
	// void glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height)
	// void glGetRenderbufferParameteriv (GLenum target, GLenum pname, GLint *params)
	// GLboolean glIsFramebuffer (GLuint framebuffer)
	// void glBindFramebuffer (GLenum target, GLuint framebuffer)
	// void glDeleteFramebuffers (GLsizei n, const GLuint *framebuffers)
	// void glGenFramebuffers (GLsizei n, GLuint *framebuffers)
	// GLenum glCheckFramebufferStatus (GLenum target)
	// void glFramebufferTexture1D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)
	// void glFramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)
	// void glFramebufferTexture3D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset)
	// void glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)
	// void glGetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint *params)
	// void glGenerateMipmap (GLenum target)
	// void glBlitFramebuffer (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter)
	// void glRenderbufferStorageMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height)
	// void glFramebufferTextureLayer (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer)
}
