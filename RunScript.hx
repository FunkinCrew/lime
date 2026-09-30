package;

import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.System;

import sys.FileSystem;
import sys.io.File;

class RunScript
{
	private static function rebuildTools(limeDirectory:String, toolsDirectory:String):Void
	{
		System.runCommand(limeDirectory, "haxe", ["run.hxml"]);
		System.runCommand(toolsDirectory, "haxe", ["tools.hxml"]);
	}

	private static function rebuildAlias(limeDirectory:String, aliasDirectory:String):Void
	{
		var aliasTargetDirectory:String = Path.combine(limeDirectory, "templates/bin/alias/");

		System.makeDirectory(aliasTargetDirectory);

		function rebuildAliasExecutable(directoryName:String, architectureDefine:String, ?executableExtension:String):Void
		{
			var aliasTargetOutputDirectory:String = Path.combine(aliasTargetDirectory, directoryName);

			System.makeDirectory(aliasTargetOutputDirectory);

			var aliasTargetOutputFile:String = Path.combine(aliasTargetOutputDirectory, haxe.io.Path.withExtension('lime', executableExtension));

			// Always clean rebuild it!
			System.removeDirectory(Path.combine(aliasDirectory, 'obj'));

			// -Dno-compilation so its doesnt print the command itself, stupid haxe
			System.runCommand(aliasDirectory, "haxe", ["alias.hxml", "-D", architectureDefine, '-D', 'no-compilation']);

			// We need to run this manually now!
			System.runCommand(Path.combine(aliasDirectory, 'obj'), 'haxelib', ['run', 'hxcpp', 'Build.xml', '-options', 'Options.txt']);

			var aliasOutput:String = Path.combine(aliasDirectory, haxe.io.Path.withExtension("obj/Alias", executableExtension));

			if (FileSystem.exists(aliasOutput))
			{
				System.copyFile(Path.combine(aliasDirectory, haxe.io.Path.withExtension("obj/Alias", executableExtension)), aliasTargetOutputFile);
			}
		}

		switch (System.hostPlatform)
		{
			case WINDOWS:
				if (System.hostArchitecture == X64)
				{
					rebuildAliasExecutable('Windows64', 'HXCPP_M64', 'exe');
				}
				else if (System.hostArchitecture == X86)
				{
					rebuildAliasExecutable('Windows', 'HXCPP_M32', 'exe');
				}
			case MAC:
				if (System.hostArchitecture == X64)
				{
					rebuildAliasExecutable('Mac64', 'HXCPP_M64');
				}
				else if (System.hostArchitecture == ARM64)
				{
					rebuildAliasExecutable('MacArm64', 'HXCPP_ARM64');
				}
			case LINUX:
				if (System.hostArchitecture == ARMV7)
				{
					rebuildAliasExecutable('LinuxArm', 'HXCPP_ARMV7');
				}
				else if (System.hostArchitecture == ARM64)
				{
					rebuildAliasExecutable('LinuxArm64', 'HXCPP_ARM64');
				}
				else if (System.hostArchitecture == X64)
				{
					rebuildAliasExecutable('Linux64', 'HXCPP_M64');
				}
		}
	}

	public static function runCommand(path:String, command:String, args:Array<String>, throwErrors:Bool = true):Int
	{
		var oldPath:String = "";

		if (path != null && path != "")
		{
			oldPath = Sys.getCwd();

			try
			{
				Sys.setCwd(path);
			}
			catch (e:Dynamic)
			{
				Log.error("Cannot set current working directory to \"" + path + "\"");
			}
		}

		final result:Int = Sys.command(command, args);

		if (oldPath != "")
		{
			Sys.setCwd(oldPath);
		}

		if (throwErrors && result != 0)
		{
			Sys.exit(1);
		}

		return result;
	}

	public static function main()
	{
		final args:Array<String> = Sys.args();

		if (args.length > 0)
		{
			var lastArgument:String = new Path(args[args.length - 1]).toString();

			if (((StringTools.endsWith(lastArgument, "/") && lastArgument != "/") || StringTools.endsWith(lastArgument, "\\"))
				&& !StringTools.endsWith(lastArgument, ":\\"))
			{
				lastArgument = lastArgument.substr(0, lastArgument.length - 1);
			}

			if (FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument))
			{
				Haxelib.workingDirectory = lastArgument;
			}
		}

		var limeDirectory:String = Haxelib.getPath(new Haxelib("lime"), true);
		var toolsDirectory:String = Path.combine(limeDirectory, "tools");

		if (!FileSystem.exists(toolsDirectory))
		{
			limeDirectory = Path.combine(limeDirectory, "..");
			toolsDirectory = Path.combine(limeDirectory, "tools");
		}

		if (args.length > 2 && args[0] == "rebuild" && (args[1] == "tools" || args[1] == "alias"))
		{
			final cacheDirectory:String = Sys.getCwd();

			Sys.setCwd(Haxelib.workingDirectory);

			for (arg in args)
			{
				final equals:Int = arg.indexOf("=");

				if (equals > -1 && StringTools.startsWith(arg, "--"))
				{
					final argValue:String = arg.substr(equals + 1);
					final field:String = arg.substr(2, equals - 2);

					if (StringTools.startsWith(field, "haxelib-"))
					{
						Haxelib.pathOverrides.set(field.substr(8), Path.tryFullPath(argValue));
					}
				}
				else if (StringTools.startsWith(arg, "-"))
				{
					switch (arg)
					{
						case "-v", "-verbose":
							Log.verbose = true;

						case "-nocolor":
							Log.enableColor = false;

						default:
					}
				}
			}

			if (args[1] == "alias")
			{
				rebuildAlias(limeDirectory, Path.combine(toolsDirectory, 'alias'));
			}
			else
			{
				rebuildTools(limeDirectory, toolsDirectory);
			}

			if (args.indexOf("-openfl") > -1)
			{
				Sys.setCwd(cacheDirectory);
			}
			else
			{
				Sys.exit(0);
			}
		}

		final tools_n:String = Path.combine(toolsDirectory, "tools.n");

		if (!FileSystem.exists(tools_n) || args.indexOf("-rebuild") > -1)
		{
			rebuildTools(limeDirectory, toolsDirectory);
		}

		Sys.exit(runCommand("", "neko", [tools_n].concat(args)));
	}
}
