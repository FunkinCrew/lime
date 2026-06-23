package lime.graphics.bgfx;

enum abstract BGFXTopologyConvert(Int) from Int to Int
{
	var TRI_LIST_FLIP_WINDING = 0;
	var TRI_STRIP_FLIP_WINDING = 1;
	var TRI_LIST_TO_LINE_LIST = 2;
	var TRI_STRIP_TO_TRI_LIST = 3;
	var LINE_STRIP_TO_LINE_LIST = 4;
}
