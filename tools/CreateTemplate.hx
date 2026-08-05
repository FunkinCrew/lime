package;

import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.System;

import lime.tools.HXProject;

import sys.FileSystem;

@:access(lime.tools.HXProject)
class CreateTemplate
{
	public static function createSample(words:Array<String>, userDefines:Map<String, Dynamic>)
	{
		var colonIndex = words[0].indexOf(":");

		var projectName:String = null;
		var sampleName:String = null;
		var outputPath:String = null;

		if (colonIndex == -1 && words.length > 1)
		{
			projectName = words[0];
			sampleName = words[1];

			if (words.length > 2)
			{
				outputPath = words[2];
			}
		}
		else
		{
			projectName = words[0].substring(0, colonIndex);
			sampleName = words[0].substr(colonIndex + 1);

			if (words.length > 1)
			{
				outputPath = words[1];
			}
		}

		if (projectName == null || projectName == "")
		{
			projectName = CommandLineTools.defaultLibrary;
		}

		if (sampleName == null || sampleName == "")
		{
			Log.error("You must specify a sample name to copy when using \"" + CommandLineTools.commandName + " create\"");
			return;
		}

		var defines = new Map<String, Dynamic>();
		defines.set("create", 1);
		var project = HXProject.fromHaxelib(new Haxelib(projectName), defines);

		if (project == null && outputPath == null)
		{
			outputPath = sampleName;
			sampleName = projectName;
			projectName = CommandLineTools.defaultLibrary;
			project = HXProject.fromHaxelib(new Haxelib(projectName), defines);
		}

		if (project != null)
		{
			if (outputPath == null)
			{
				outputPath = sampleName;
			}

			var samplePaths = project.samplePaths.copy();
			samplePaths.reverse();

			for (samplePath in samplePaths)
			{
				var sourcePath = Path.combine(samplePath, sampleName);

				if (FileSystem.exists(sourcePath))
				{
					System.mkdir(outputPath);
					System.recursiveCopy(sourcePath, Path.tryFullPath(outputPath));
					return;
				}
			}
		}

		Log.error("Could not find sample \"" + sampleName + "\" in project \"" + projectName + "\"");
	}

	public static function listSamples(projectName:String, userDefines:Map<String, Dynamic>)
	{
		var templates:Array<String> = [];

		if (projectName != null && projectName != "")
		{
			var defines = new Map<String, Dynamic>();
			defines.set("create", 1);
			var project = HXProject.fromHaxelib(new Haxelib(projectName), defines);

			if (project != null)
			{
				var samplePaths = project.samplePaths.copy();

				if (samplePaths.length > 0)
				{
					samplePaths.reverse();

					for (samplePath in samplePaths)
					{
						var path = Path.tryFullPath(samplePath);
						if (!FileSystem.exists(path))
							continue;

						for (name in FileSystem.readDirectory(path))
						{
							if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(path + "/" + name))
							{
								templates.push(name);
							}
						}
					}
				}
			}
		}

		if (templates.length == 0)
		{
			projectName = CommandLineTools.defaultLibrary;
		}

		Log.println("\x1b[1mYou must specify a template when using the 'create' command.\x1b[0m");
		Log.println("");

		if (projectName == CommandLineTools.commandName)
		{
			Log.println(" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + CommandLineTools.commandName + "\x1b[0m create project (directory)");
			Log.println(" " + Log.accentColor + "Usage:\x1b[0m \x1b[1m" + CommandLineTools.commandName + "\x1b[0m create extension (directory)");
		}

		Log.println(" "
			+ Log.accentColor
			+ "Usage:\x1b[0m \x1b[1m"
			+ CommandLineTools.commandName
			+ "\x1b[0m create "
			+ (projectName != CommandLineTools.commandName ? projectName + " " : "")
			+ "<sample> (directory)");

		if (templates.length > 0)
		{
			Log.println("");
			Log.println(" " + Log.accentColor + "Available samples:\x1b[0m");
			Log.println("");

			for (template in templates)
			{
				Sys.println("  * " + template);
			}
		}

		Sys.println("");
	}
}
