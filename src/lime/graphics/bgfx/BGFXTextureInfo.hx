package lime.graphics.bgfx;

typedef BGFXTextureInfo =
{
	var format:BGFXTextureFormat;
	var storageSize:Int;
	var width:Int;
	var height:Int;
	var depth:Int;
	var numLayers:Int;
	var numMips:Int;
	var bitsPerPixel:Int;
	var cubeMap:Bool;
}
