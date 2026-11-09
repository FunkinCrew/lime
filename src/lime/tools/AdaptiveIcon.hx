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
		if (Path.extension(path) == "icon")
		{
			try
			{
				// Stupid workaround for Neko, this shouldve been `isDirectory` but some instaltions have it broken for some weird reason.
				FileSystem.readDirectory(path);

				this.iconComposerFile = true;

				return;
			}
			catch (e:Dynamic) {}
		}

		this.iconComposerFile = false;
	}

	public function clone():AdaptiveIcon
	{
		return new AdaptiveIcon(path, hasRoundIcon);
	}
}
