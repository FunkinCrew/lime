package lime.graphics.bgfx;

enum abstract BGFXBackbufferRatio(Int) from Int to Int
{
	var EQUAL = 0;
	var HALF = 1;
	var QUARTER = 2;
	var EIGHTH = 3;
	var SIXTEENTH = 4;
	var DOUBLE = 5;
}
