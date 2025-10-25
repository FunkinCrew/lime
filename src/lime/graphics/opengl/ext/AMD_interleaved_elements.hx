package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_interleaved_elements
{
	public var VERTEX_ELEMENT_SWIZZLE_AMD = 0x91A4;
	public var VERTEX_ID_SWIZZLE_AMD = 0x91A5;
	public var RED = 0x1903;
	public var GREEN = 0x1904;
	public var BLUE = 0x1905;
	public var ALPHA = 0x1906;
	public var RG8UI = 0x8238;
	public var RG16UI = 0x823A;
	public var RGBA8UI = 0x8D7C;

	@:noCompletion private function new() {}

	// void glVertexAttribParameteriAMD (GLuint index, GLenum pname, GLint param)
}
