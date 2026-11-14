package lime.graphics.bgfx;

import haxe.io.Bytes;

typedef BGFXScreenShot =
{
	var filePath:String;
	var width:Int;
	var height:Int;
	var pitch:Int;
	var format:BGFXTextureFormat;
	var data:Bytes;
	var yflip:Bool;
}
