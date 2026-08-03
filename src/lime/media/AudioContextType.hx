package lime.media;

enum abstract AudioContextType(String) from String to String
{
	var MINIAUDIO = "miniaudio";
	var OPENAL = "openal";
	var WEB = "web";
	var CUSTOM = "custom";
}
