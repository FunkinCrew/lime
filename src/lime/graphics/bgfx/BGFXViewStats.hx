package lime.graphics.bgfx;

typedef BGFXViewStats =
{
	var name:String;
	var view:Int;
	var cpuTimeBegin:Float;
	var cpuTimeEnd:Float;
	var gpuTimeBegin:Float;
	var gpuTimeEnd:Float;
	var gpuFrameNum:Int;
}
