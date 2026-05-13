package lime.graphics.bgfx;

enum abstract BGFXAttribType(Int) from Int to Int
{
	var INT8 = 0;
	var UINT8 = 1;
	var UINT10 = 2;
	var INT16 = 3;
	var UINT16 = 4;
	var HALF = 5;
	var FLOAT = 6;
}
