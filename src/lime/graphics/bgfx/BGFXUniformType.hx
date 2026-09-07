package lime.graphics.bgfx;

enum abstract BGFXUniformType(Int) from Int to Int
{
	var SAMPLER = 0;
	var END = 1;
	var VEC4 = 2;
	var MAT3 = 3;
	var MAT4 = 4;
}
