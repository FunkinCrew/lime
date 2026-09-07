package lime.graphics.bgfx;

enum abstract BGFXOcclusionQueryResult(Int) from Int to Int
{
	var INVISIBLE = 0;
	var VISIBLE = 1;
	var NORESULT = 2;
}
