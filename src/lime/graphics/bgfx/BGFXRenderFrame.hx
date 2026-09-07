package lime.graphics.bgfx;

enum abstract BGFXRenderFrame(Int) from Int to Int
{
	var NO_CONTEXT = 0;
	var RENDER = 1;
	var TIMEOUT = 2;
	var EXITING = 3;
}
