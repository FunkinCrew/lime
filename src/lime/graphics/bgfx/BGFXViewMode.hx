package lime.graphics.bgfx;

enum abstract BGFXViewMode(Int) from Int to Int
{
	var DEFAULT = 0;
	var SEQUENTIAL = 1;
	var DEPTH_ASCENDING = 2;
	var DEPTH_DESCENDING = 3;
}
