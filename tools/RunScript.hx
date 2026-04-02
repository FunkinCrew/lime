package;

import hxp.*;
import sys.FileSystem;

class RunScript
{
	private static function rebuildTools(limeDirectory:String, toolsDirectory:String):Void
	{
		System.runCommand(toolsDirectory, "haxe", ["tools.hxml"]);
		System.runCommand(toolsDirectory, "haxe", ["svg.hxml"]);
		System.runCommand(toolsDirectory, "haxe", ["run.hxml"]);
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

		var result:Dynamic = Sys.command(command, args);

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
		var args = Sys.args();

		if (args.length > 0)
		{
			var lastArgument = new Path(args[args.length - 1]).toString();

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

		var limeDirectory = Haxelib.getPath(new Haxelib("lime"), true);
		var toolsDirectory = Path.combine(limeDirectory, "tools");

		if (!FileSystem.exists(toolsDirectory))
		{
			limeDirectory = Path.combine(limeDirectory, "..");
			toolsDirectory = Path.combine(limeDirectory, "tools");
		}

		if (args.length > 2 && args[0] == "rebuild" && args[1] == "tools")
		{
			var cacheDirectory = Sys.getCwd();
			// used for Path.tryFullPath when setting overrides
			Sys.setCwd(Haxelib.workingDirectory);

			for (arg in args)
			{
				var equals = arg.indexOf("=");

				if (equals > -1 && StringTools.startsWith(arg, "--"))
				{
					var argValue = arg.substr(equals + 1);
					var field = arg.substr(2, equals - 2);

					if (StringTools.startsWith(field, "haxelib-"))
					{
						var name = field.substr(8);
						Haxelib.pathOverrides.set(name, Path.tryFullPath(argValue));
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

			rebuildTools(limeDirectory, toolsDirectory);

			if (args.indexOf("-openfl") > -1)
			{
				Sys.setCwd(cacheDirectory);
			}
			else
			{
				Sys.exit(0);
			}
		}

		if (args.indexOf("-eval") >= 0)
		{
			args.remove("-eval");
			Log.info("Experimental: executing `lime " + args.slice(0, args.length - 1).join(" ")
				+ "` using Eval (https://haxe.org/blog/eval/)");

			var args = [
				"-D", "lime",
				"-cp", toolsDirectory,
				"-cp", Path.combine(toolsDirectory, "platforms"),
				"-cp", Path.combine(limeDirectory, "src"),
				"-lib", "format",
				"-lib", "hxp",
				"--run", "CommandLineTools"].concat(args);
			Sys.exit(runCommand("", "haxe", args));
		}

		var tools_n = Path.combine(toolsDirectory, "tools.n");
		if (!FileSystem.exists(tools_n) || args.indexOf("-rebuild") > -1)
		{
			rebuildTools(limeDirectory, toolsDirectory);
		}

		var args = [tools_n].concat(args);
		Sys.exit(runCommand("", "neko", args));
	}
}
