package lime.tools;

import sys.FileSystem;
import haxe.io.Path;

/**
	This file is a wrapper to save to path and some properties about the AdaptiveIcon format from Android
	It is also used to store Apple's Icon Composer .icon file for Apple Platforms as it is also a dynamic icon file
**/
class AdaptiveIcon
{
	public var path:String;
  	public var hasRoundIcon:Bool; // No use on iOS
	public var iconComposerFile:Bool; // No use on Android

	public function new(path:String, hasRoundIcon:Bool)
	{
		this.path = path;
    	this.hasRoundIcon = hasRoundIcon;

		// Some macOS files are actually folders with a file extension and the icon composer file is one of them
		this.iconComposerFile = Path.extension(path) == "icon" && FileSystem.isDirectory(path);
	}

	public function clone():AdaptiveIcon
	{
		return new AdaptiveIcon(path, hasRoundIcon);
	}
}
