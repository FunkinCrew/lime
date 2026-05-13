package lime.graphics.bgfx;

typedef BGFXCaps =
{
	var rendererType:BGFXBackend;
	var supported:Float;
	var vendorId:Int;
	var deviceId:Int;
	var homogeneousDepth:Bool;
	var originBottomLeft:Bool;
	var numGPUs:Int;
	var limits:BGFXCapsLimits;
	var formats:Array<Int>;
}

typedef BGFXCapsLimits =
{
	var maxDrawCalls:Int;
	var maxBlits:Int;
	var maxTextureSize:Int;
	var maxTextureLayers:Int;
	var maxViews:Int;
	var maxFrameBuffers:Int;
	var maxFBAttachments:Int;
	var maxPrograms:Int;
	var maxShaders:Int;
	var maxTextures:Int;
	var maxTextureSamplers:Int;
	var maxComputeBindings:Int;
	var maxVertexLayouts:Int;
	var maxVertexStreams:Int;
	var maxIndexBuffers:Int;
	var maxVertexBuffers:Int;
	var maxDynamicIndexBuffers:Int;
	var maxDynamicVertexBuffers:Int;
	var maxUniforms:Int;
	var maxOcclusionQueries:Int;
	var maxEncoders:Int;
	var minResourceCbSize:Int;
	var maxTransientVbSize:Int;
	var maxTransientIbSize:Int;
	var minUniformBufferSize:Int;
}
