package lime.media;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AudioContextType(String) from String to String
{
	var FLASH = "flash";
	var OPENAL = "openal";
	var WEB = "web";
	var CUSTOM = "custom";
}
