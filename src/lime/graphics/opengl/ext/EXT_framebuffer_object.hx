package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_framebuffer_object
{
	public var INVALID_FRAMEBUFFER_OPERATION_EXT = 0x0506;
	public var MAX_RENDERBUFFER_SIZE_EXT = 0x84E8;
	public var FRAMEBUFFER_BINDING_EXT = 0x8CA6;
	public var RENDERBUFFER_BINDING_EXT = 0x8CA7;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_EXT = 0x8CD0;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT = 0x8CD1;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT = 0x8CD2;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT = 0x8CD3;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_EXT = 0x8CD4;
	public var FRAMEBUFFER_COMPLETE_EXT = 0x8CD5;
	public var FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT = 0x8CD6;
	public var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT = 0x8CD7;
	public var FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT = 0x8CD9;
	public var FRAMEBUFFER_INCOMPLETE_FORMATS_EXT = 0x8CDA;
	public var FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT = 0x8CDB;
	public var FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT = 0x8CDC;
	public var FRAMEBUFFER_UNSUPPORTED_EXT = 0x8CDD;
	public var MAX_COLOR_ATTACHMENTS_EXT = 0x8CDF;
	public var COLOR_ATTACHMENT0_EXT = 0x8CE0;
	public var COLOR_ATTACHMENT1_EXT = 0x8CE1;
	public var COLOR_ATTACHMENT2_EXT = 0x8CE2;
	public var COLOR_ATTACHMENT3_EXT = 0x8CE3;
	public var COLOR_ATTACHMENT4_EXT = 0x8CE4;
	public var COLOR_ATTACHMENT5_EXT = 0x8CE5;
	public var COLOR_ATTACHMENT6_EXT = 0x8CE6;
	public var COLOR_ATTACHMENT7_EXT = 0x8CE7;
	public var COLOR_ATTACHMENT8_EXT = 0x8CE8;
	public var COLOR_ATTACHMENT9_EXT = 0x8CE9;
	public var COLOR_ATTACHMENT10_EXT = 0x8CEA;
	public var COLOR_ATTACHMENT11_EXT = 0x8CEB;
	public var COLOR_ATTACHMENT12_EXT = 0x8CEC;
	public var COLOR_ATTACHMENT13_EXT = 0x8CED;
	public var COLOR_ATTACHMENT14_EXT = 0x8CEE;
	public var COLOR_ATTACHMENT15_EXT = 0x8CEF;
	public var DEPTH_ATTACHMENT_EXT = 0x8D00;
	public var STENCIL_ATTACHMENT_EXT = 0x8D20;
	public var FRAMEBUFFER_EXT = 0x8D40;
	public var RENDERBUFFER_EXT = 0x8D41;
	public var RENDERBUFFER_WIDTH_EXT = 0x8D42;
	public var RENDERBUFFER_HEIGHT_EXT = 0x8D43;
	public var RENDERBUFFER_INTERNAL_FORMAT_EXT = 0x8D44;
	public var STENCIL_INDEX1_EXT = 0x8D46;
	public var STENCIL_INDEX4_EXT = 0x8D47;
	public var STENCIL_INDEX8_EXT = 0x8D48;
	public var STENCIL_INDEX16_EXT = 0x8D49;
	public var RENDERBUFFER_RED_SIZE_EXT = 0x8D50;
	public var RENDERBUFFER_GREEN_SIZE_EXT = 0x8D51;
	public var RENDERBUFFER_BLUE_SIZE_EXT = 0x8D52;
	public var RENDERBUFFER_ALPHA_SIZE_EXT = 0x8D53;
	public var RENDERBUFFER_DEPTH_SIZE_EXT = 0x8D54;
	public var RENDERBUFFER_STENCIL_SIZE_EXT = 0x8D55;

	@:noCompletion private function new() {}

	// GLboolean glIsRenderbufferEXT (GLuint renderbuffer)
	// void glBindRenderbufferEXT (GLenum target, GLuint renderbuffer)
	// void glDeleteRenderbuffersEXT (GLsizei n, const GLuint *renderbuffers)
	// void glGenRenderbuffersEXT (GLsizei n, GLuint *renderbuffers)
	// void glRenderbufferStorageEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height)
	// void glGetRenderbufferParameterivEXT (GLenum target, GLenum pname, GLint *params)
	// GLboolean glIsFramebufferEXT (GLuint framebuffer)
	// void glBindFramebufferEXT (GLenum target, GLuint framebuffer)
	// void glDeleteFramebuffersEXT (GLsizei n, const GLuint *framebuffers)
	// void glGenFramebuffersEXT (GLsizei n, GLuint *framebuffers)
	// GLenum glCheckFramebufferStatusEXT (GLenum target)
	// void glFramebufferTexture1DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)
	// void glFramebufferTexture2DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)
	// void glFramebufferTexture3DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset)
	// void glFramebufferRenderbufferEXT (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)
	// void glGetFramebufferAttachmentParameterivEXT (GLenum target, GLenum attachment, GLenum pname, GLint *params)
	// void glGenerateMipmapEXT (GLenum target)
}
