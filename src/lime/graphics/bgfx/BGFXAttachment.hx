package lime.graphics.bgfx;

typedef BGFXAttachment =
{
	var handle:BGFXTexture;
	var ?access:BGFXAccess;
	var ?layer:Int;
	var ?numLayers:Int;
	var ?mip:Int;
	var ?flags:Int;
}
