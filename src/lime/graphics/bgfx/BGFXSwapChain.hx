package lime.graphics.bgfx;

import lime.ui.Window;

@:structInit
class BGFXSwapChain
{
	public var window:Window = null;
	public var width:Int = 0;
	public var height:Int = 0;
	public var flags:Int = 0;
	public var formatColor:BGFXTextureFormat = BGFXTextureFormat.Count;
	public var formatDepthStencil:BGFXTextureFormat = BGFXTextureFormat.Count;
	public var depth:BGFXTexture = null;
	public var numBackBuffers:Int = 0;
	public var maxFrameLatency:Int = 0;
}
