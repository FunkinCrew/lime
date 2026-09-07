package lime.graphics.bgfx;

typedef BGFXStats =
{
	var cpuTimeFrame:Float;
	var cpuTimeBegin:Float;
	var cpuTimeEnd:Float;
	var cpuTimerFreq:Float;
	var gpuTimeBegin:Float;
	var gpuTimeEnd:Float;
	var gpuTimerFreq:Float;
	var waitRender:Float;
	var waitSubmit:Float;
	var numDraw:Int;
	var numCompute:Int;
	var numBlit:Int;
	var maxGpuLatency:Int;
	var gpuFrameNum:Int;
	var numDynamicIndexBuffers:Int;
	var numDynamicVertexBuffers:Int;
	var numFrameBuffers:Int;
	var numIndexBuffers:Int;
	var numOcclusionQueries:Int;
	var numPrograms:Int;
	var numShaders:Int;
	var numTextures:Int;
	var numUniforms:Int;
	var numVertexBuffers:Int;
	var numVertexLayouts:Int;
	var textureMemoryUsed:Float;
	var rtMemoryUsed:Float;
	var transientVbUsed:Int;
	var transientIbUsed:Int;
	var numPrims:Array<Int>;
	var gpuMemoryMax:Float;
	var gpuMemoryUsed:Float;
	var width:Int;
	var height:Int;
	var textWidth:Int;
	var textHeight:Int;
	var numViews:Int;
	var numEncoders:Int;
}
