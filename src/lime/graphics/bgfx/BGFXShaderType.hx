package lime.graphics.bgfx;

enum abstract BGFXShaderType(Int) from Int to Int
{
	var VERTEX = 0;
	var FRAGMENT = 1;
	var COMPUTE = 2;
}
