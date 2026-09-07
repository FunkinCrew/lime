package lime.graphics.bgfx;

typedef BGFXAttachment =
{
	var texture:BGFXTexture;
	var ?access:BGFXAccess;
	var ?layer:Int;
	var ?numLayers:Int;
	var ?mip:Int;
	var ?resolve:Int;
}
