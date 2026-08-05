package lime.tools;

import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.System;
import hxp.Version;

import lime.tools.Asset;
import lime.tools.HXProject;

import sys.FileSystem;

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

	public static function launch(project:HXProject, path:String, port:Int = 0):Void
	{
		if (project.app.url != null && project.app.url != "")
		{
			System.openURL(project.app.url);
		}
		else
		{
			var templatePaths = [Path.combine(Haxelib.getPath(new Haxelib("lime")), "templates")].concat(project.templatePaths);
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
