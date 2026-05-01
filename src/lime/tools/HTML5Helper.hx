package lime.tools;

import hxp.*;
import lime.tools.Architecture;
import lime.tools.Asset;
import lime.tools.HXProject;
import lime.tools.Platform;
import sys.FileSystem;
import sys.io.File;
#if cpp
import cpp.vm.Thread;
#end

class HTML5Helper
{
	public static function encodeSourceMappingURL(sourceFile:String)
	{
		// This is only required for projects with url-unsafe characters built with a Haxe version prior to 4.0.0

		var filename = Path.withoutDirectory(sourceFile);

		if (filename != StringTools.urlEncode(filename))
		{
			var output = System.runProcess("", "haxe", ["-version"], true, true, true, false, true);
			var haxeVer:Version = StringTools.trim(output);

			if (haxeVer < ("4.0.0":Version))
			{
				var replaceString = "//# sourceMappingURL=" + filename + ".map";
				var replacement = "//# sourceMappingURL=" + StringTools.urlEncode(filename) + ".map";

				System.replaceText(sourceFile, replaceString, replacement);
			}
		}
	}

	public static function generateWebfonts(project:HXProject, font:Asset):Void
	{
		var suffix = switch (System.hostPlatform)
		{
			case WINDOWS: "-windows.exe";
			case MAC: "-mac";
			case LINUX: "-linux";
			default: return;
		}

		if (suffix == "-linux")
		{
			if (System.hostArchitecture == X86)
			{
				suffix += "32";
			}
			else
			{
				suffix += "64";
			}
		}

		var templatePaths = [
			Path.combine(Haxelib.getPath(new Haxelib(#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end)
		].concat(project.templatePaths);
		var webify = System.findTemplate(templatePaths, "bin/webify" + suffix);
		if (System.hostPlatform != WINDOWS)
		{
			Sys.command("chmod", ["+x", webify]);
		}

		if (Log.verbose)
		{
			System.runCommand("", webify, [FileSystem.fullPath(font.sourcePath)]);
		}
		else
		{
			System.runProcess("", webify, [FileSystem.fullPath(font.sourcePath)], true, true, true);
		}
	}

	public static function launch(project:HXProject, path:String, port:Int = 0):Void
	{
		if (project.app.url != null && project.app.url != "")
		{
			System.openURL(project.app.url);
		}
		else
		{
			var templatePaths = [
				Path.combine(Haxelib.getPath(new Haxelib(#if lime "lime" #else "hxp" #end)), #if lime "templates" #else "" #end)
			].concat(project.templatePaths);
			var server = System.findTemplate(templatePaths, "bin/node/http-server/bin/http-server");

			var args = [server, path, "-c-1", "--cors"];

			if (project.targetFlags.exists("port"))
			{
				port = Std.parseInt(project.targetFlags.get("port"));
			}

			if (port != 0)
			{
				args.push("-p");
				args.push(Std.string(port));
				Log.info("", "\x1b[1mStarting local web server:\x1b[0m http://localhost:" + port);
			}
			else
			{
				Log.info("", "\x1b[1mStarting local web server:\x1b[0m http://localhost:[3000*]");
			}

			if (!project.targetFlags.exists("nolaunch"))
			{
				args.push("-o");
			}

			if (!Log.verbose)
			{
				args.push("--silent");
			}

			System.runCommand("", "node", args);
		}
	}
}
