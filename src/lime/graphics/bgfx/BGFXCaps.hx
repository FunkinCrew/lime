package lime.graphics.bgfx;

import haxe.Int64;

@:structInit
class BGFXCaps
{
	public var rendererType(default, null):BGFXRendererType;
	public var supported(get, never):Int64;
	public var vendorId(default, null):Int;
	public var deviceId(default, null):Int;
	public var homogeneousDepth(default, null):Bool;
	public var originBottomLeft(default, null):Bool;
	public var numGPUs(default, null):Int;
	public var gpus(default, null):Array<BGFXCapsGPU>;
	public var limits(default, null):BGFXCapsLimits;
	public var formats(default, null):Array<BGFXTextureFormat>;

	@:noCompletion
	private var __supportedHigh(default, null):Int;

	@:noCompletion
	private var __supportedLow(default, null):Int;

	@:noCompletion
	private function get_supported():Int64
	{
		return Int64.make(__supportedHigh, __supportedLow);
	}

	@:noCompletion
	private static function fromCFFI(struct:Dynamic):BGFXCaps
	{
		if (struct == null) return null;

		return {
			rendererType: struct.rendererType,
			vendorId: struct.vendorId,
			deviceId: struct.deviceId,
			homogeneousDepth: struct.homogeneousDepth,
			originBottomLeft: struct.originBottomLeft,
			numGPUs: struct.numGPUs,
			gpus: struct.gpus,
			limits: struct.limits,
			formats: struct.formats,
			__supportedHigh: struct.__supportedHigh,
			__supportedLow: struct.__supportedLow
		};
	}
}

typedef BGFXCapsGPU =
{
	var vendorId:Int;
	var deviceId:Int;
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
