package;

import lime.tools.HashlinkHelper;
import hxp.Haxelib;
import hxp.HXML;
import hxp.Log;
import hxp.Path;
import hxp.NDLL;
import hxp.System;
import lime.tools.Architecture;
import lime.tools.Asset;
import lime.tools.AssetHelper;
import lime.tools.AssetType;
import lime.tools.CPPHelper;
import lime.tools.DeploymentHelper;
import lime.tools.GUID;
import lime.tools.HTML5Helper;
import lime.tools.HXProject;
import lime.tools.Icon;
import lime.tools.IconHelper;
import lime.tools.ModuleHelper;
import lime.tools.NodeJSHelper;
import lime.tools.Orientation;
import lime.tools.Platform;
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;

class WindowsPlatform extends PlatformTarget
{
	private var applicationDirectory:String;
	private var executablePath:String;
	private var is64:Bool;
	private var targetType:String;
	private var outputFile:String;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults = new HXProject();

		defaults.meta =
			{
				title: "MyApplication",
				description: "",
				packageName: "com.example.myapp",
				version: "1.0.0",
				company: "",
				companyUrl: "",
				buildNumber: null,
				companyId: ""
			};

		defaults.app =
			{
				main: "Main",
				file: "MyApplication",
				path: "bin",
				preloader: "",
				swfVersion: 17,
				url: "",
				init: null
			};

		defaults.window =
			{
				width: 800,
				height: 600,
				parameters: "{}",
				background: 0xFFFFFF,
				fps: 30,
				hardware: true,
				display: 0,
				resizable: true,
				transparent: false,
				borderless: false,
				orientation: Orientation.AUTO,
				vsync: false,
				fullscreen: false,
				allowHighDPI: true,
				alwaysOnTop: false,
				antialiasing: 0,
				allowShaders: true,
				requireShaders: false,
				depthBuffer: true,
				stencilBuffer: true,
				colorDepth: 32,
				maximized: false,
				minimized: false,
				hidden: false,
				title: ""
			};

		switch (System.hostArchitecture)
		{
			case ARMV6:
				defaults.architectures = [ARMV6];
			case ARMV7:
				defaults.architectures = [ARMV7];
			case X86:
				defaults.architectures = [X86];
			case X64:
				defaults.architectures = [X64];
			default:
				defaults.architectures = [];
		}

		defaults.window.allowHighDPI = false;

		for (i in 1...project.windows.length)
		{
			defaults.windows.push(defaults.window);
		}

		defaults.merge(project);
		project = defaults;

		for (excludeArchitecture in project.excludeArchitectures)
		{
			project.architectures.remove(excludeArchitecture);
		}

		if (project.targetFlags.exists("hl") || targetFlags.exists("hlc"))
		{
			targetType = "hl";
			is64 = !project.flags.exists("32") && !project.flags.exists("x86_32");
			var hlVer = project.haxedefs.get("hl-ver");
			if (hlVer == null)
			{
				var hlPath = project.defines.get("HL_PATH");
				if (hlPath == null)
				{
					// Haxe's default target version for HashLink may be
					// different (newer even) than the build of HashLink that
					// is bundled with Lime. if using Lime's bundled HashLink,
					// set hl-ver to the correct version
					project.haxedefs.set("hl-ver", HashlinkHelper.BUNDLED_HL_VER);
				}
			}
		}
		else
		{
			targetType = "cpp";
		}

		for (architecture in project.architectures)
		{
			if (architecture == Architecture.X64)
			{
				if (targetType == "cpp")
				{
					is64 = true;
				}
			}
		}

		var defaultTargetDirectory = switch (targetType)
		{
			case "cpp": "windows";
			case "hl": project.targetFlags.exists("hlc") ? "hlc" : targetType;
			default: targetType;
		}
		targetDirectory = Path.combine(project.app.path, project.config.getString("windows.output-directory", defaultTargetDirectory));
		targetDirectory = StringTools.replace(targetDirectory, "arch64", is64 ? "64" : "");

		applicationDirectory = targetDirectory + "/bin/";
		executablePath = applicationDirectory + project.app.file + ".exe";
	}

	public override function build():Void
	{
		var hxml = targetDirectory + "/haxe/" + buildType + ".hxml";

		System.mkdir(targetDirectory);

		var icons = project.icons;

		if (icons.length == 0)
		{
			icons = [new Icon(System.findTemplate(project.templatePaths, "default/icon.svg"))];
		}

		for (dependency in project.dependencies)
		{
			if (StringTools.endsWith(dependency.path, ".dll"))
			{
				copyIfNewer(dependency.path, applicationDirectory + "/" + Path.withoutDirectory(dependency.path));
			}
		}

		for (ndll in project.ndlls)
		{
			if (targetType == "hl")
			{
				ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".hdll", applicationDirectory, project.debug,
					".hdll");
				ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".lib", applicationDirectory, project.debug,
					".lib");
			}
			else
			{
				ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".ndll", applicationDirectory, project.debug);
			}
		}

		if (targetType == "hl")
		{
			System.runCommand("", "haxe", [hxml]);

			if (noOutput) return;

			HashlinkHelper.copyHashlink(project, targetDirectory, applicationDirectory, executablePath, is64);

			if (project.targetFlags.exists("hlc"))
			{
				var command:Array<String> = null;
				if (project.targetFlags.exists("gcc"))
				{
					command = ["gcc", "-O3", "-o", executablePath, "-std=c11", "-Wl,-subsystem,windows", "-I", Path.combine(targetDirectory, "obj"), Path.combine(targetDirectory, "obj/ApplicationMain.c"), "C:/Windows/System32/dbghelp.dll"];
					for (file in System.readDirectory(applicationDirectory))
					{
						switch Path.extension(file)
						{
							case "dll", "hdll":
								// ensure the executable knows about every library
								command.push(file);
							default:
						}
					}
				}
				else
				{
					// start by finding visual studio
					var programFilesX86 = Sys.getEnv("ProgramFiles(x86)");
					var vswhereCommand = programFilesX86 + "\\Microsoft Visual Studio\\Installer\\vswhere.exe";
					var vswhereOutput = System.runProcess("", vswhereCommand, ["-latest", "-products", "*", "-requires", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath"]);
					var visualStudioPath = StringTools.trim(vswhereOutput);
					var vcvarsallPath = visualStudioPath + "\\VC\\Auxiliary\\Build\\vcvarsall.bat";
					// this command sets up the environment variables and things that visual studio requires
					var vcvarsallCommand = [vcvarsallPath, "x64"].map(function(arg:String):String { return ~/([&|\(\)<>\^ ])/g.replace(arg, "^$1"); });
					// this command runs the cl.exe c compiler from visual studio
					var clCommand = ["cl.exe", "/Ox", "/Fe:" + executablePath, "-I", Path.combine(targetDirectory, "obj"), Path.combine(targetDirectory, "obj/ApplicationMain.c")];
					for (file in System.readDirectory(applicationDirectory))
					{
						switch Path.extension(file)
						{
							case "lib":
								// ensure the executable knows about every library
								clCommand.push(file);
							default:
						}
					}
					clCommand.push("/link");
					clCommand.push("/subsystem:windows");
					clCommand = clCommand.map(function(arg:String):String { return ~/([&|\(\)<>\^ ])/g.replace(arg, "^$1"); });
					// combine both commands into one
					command = ["cmd.exe", "/s", "/c", vcvarsallCommand.join(" ") + " && " + clCommand.join(" ")];
				}
				System.runCommand("", command.shift(), command);
			}

			for (file in System.readDirectory(applicationDirectory))
			{
				switch Path.extension(file)
				{
					case "lib":
						// lib files required only for hlc compilation
						System.deleteFile(file);
					default:
				}
			}

			var iconPath = Path.combine(applicationDirectory, "icon.ico");

			if (IconHelper.createWindowsIcon(icons, iconPath) && System.hostPlatform == WINDOWS)
			{
				var templates = [Haxelib.getPath(new Haxelib(#if lime "lime" #else "hxp" #end)) + "/templates"].concat(project.templatePaths);
				System.runCommand("", System.findTemplate(templates, "bin/ReplaceVistaIcon.exe"), [executablePath, iconPath, "1"], true, true);
			}
		}
		else
		{
			var haxeArgs = [hxml, "-D", "resourceFile=ApplicationMain.rc"];
			var flags = ["-DresourceFile=ApplicationMain.rc"];

			if (is64)
			{
				haxeArgs.push("-D");
				haxeArgs.push("HXCPP_M64");
				flags.push("-DHXCPP_M64");
			}
			else
			{
				haxeArgs.push("-D");
				haxeArgs.push("HXCPP_M32");
				flags.push("-DHXCPP_M32");
			}

			if (project.targetFlags.exists("mingw"))
			{
				haxeArgs.push("-D");
				haxeArgs.push("mingw");
				flags.push("-Dmingw");

				// For some reason `MinGW` uses the shared deps by default, which we dont really want do we?
				haxeArgs.push("-D");
				haxeArgs.push("no_shared_libs");
				flags.push("-Dno_shared_libs");
			}

			if (!project.environment.exists("SHOW_CONSOLE"))
			{
				haxeArgs.push("-D");
				haxeArgs.push("no_console");
				flags.push("-Dno_console");
			}

			System.runCommand("", "haxe", haxeArgs);

			if (noOutput) return;

			IconHelper.createWindowsIcon(icons, Path.combine(targetDirectory + "/obj", "ApplicationMain.ico"));

			CPPHelper.compile(project, targetDirectory + "/obj", flags);

			System.copyFile(targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : "") + ".exe", executablePath);
		}
	}

	public override function deploy():Void
	{
		DeploymentHelper.deploy(project, targetFlags, targetDirectory, "Windows" + (is64 ? "64" : ""));
	}

	public override function display():Void
	{
		if (project.targetFlags.exists("output-file"))
		{
			Sys.println(executablePath);
		}
		else
		{
			Sys.println(getDisplayHXML().toString());
		}
	}

	private function generateContext():Dynamic
	{
		var context = project.templateContext;

		if (targetType == "cpp")
		{
			if (context.APP_DESCRIPTION == null || context.APP_DESCRIPTION == "")
			{
				context.APP_DESCRIPTION = project.meta.title;
			}

			if (context.APP_COPYRIGHT_YEARS == null || context.APP_COPYRIGHT_YEARS == "")
			{
				context.APP_COPYRIGHT_YEARS = Std.string(Date.now().getFullYear());
			}

			var versionParts = project.meta.version.split(".");

			if (versionParts.length == 3)
			{
				versionParts.push("0");
			}

			context.FILE_VERSION = versionParts.join(".");
			context.VERSION_NUMBER = versionParts.join(",");
		}

		context.NEKO_FILE = targetDirectory + "/obj/ApplicationMain.n";
		context.NODE_FILE = targetDirectory + "/bin/ApplicationMain.js";
		context.HL_FILE = targetDirectory + "/obj/ApplicationMain" + (project.defines.exists("hlc") ? ".c" : ".hl");
		context.CPP_DIR = targetDirectory + "/obj";
		context.BUILD_DIR = project.app.path + "/windows" + (is64 ? "64" : "");

		return context;
	}

	private override function getDisplayHXML():HXML
	{
		var path = targetDirectory + "/haxe/" + buildType + ".hxml";

		// try to use the existing .hxml file. however, if the project file was
		// modified more recently than the .hxml, then the .hxml cannot be
		// considered valid anymore. it may cause errors in editors like vscode.
		if (FileSystem.exists(path)
			&& (project.projectFilePath == null || !FileSystem.exists(project.projectFilePath)
				|| (FileSystem.stat(path).mtime.getTime() > FileSystem.stat(project.projectFilePath).mtime.getTime())))
		{
			return File.getContent(path);
		}
		else
		{
			var context = project.templateContext;
			var hxml = HXML.fromString(context.HAXE_FLAGS);
			hxml.addClassName(context.APP_MAIN);
			switch (targetType)
			{
				case "hl":
					hxml.hl = "_.hl";
				default:
					hxml.cpp = "_";
			}
			hxml.noOutput = true;
			return hxml;
		}
	}

	public override function rebuild():Void
	{
		var commands:Array<Array<String>> = [];

		if (!targetFlags.exists("32") && !targetFlags.exists("x86_32") && System.hostArchitecture == X64)
		{
			var args:Array<String> = ["-Dwindows", "-DHXCPP_M64"];

			if (project.targetFlags.exists("mingw"))
			{
				args.push("-Dmingw");

				// For some reason `MinGW` uses the shared deps by default, which we dont really want do we?
				args.push("-Dno_shared_libs");
			}

			if (targetType == "hl")
			{
				args.push("-Dhashlink");
			}

			commands.push(args);
		}

		if (!targetFlags.exists("64") && !targetFlags.exists("x86_64") && System.hostArchitecture == X86)
		{
			var args:Array<String> = ["-Dwindows", "-DHXCPP_M32"];

			if (project.targetFlags.exists("mingw"))
			{
				args.push("-Dmingw");

				// For some reason `MinGW` uses the shared deps by default, which we dont really want do we?
				args.push("-Dno_shared_libs");
			}

			if (targetType == "hl")
			{
				args.push("-Dhashlink");
			}

			commands.push(args);
		}

		if (targetFlags.exists("hl"))
		{
			CPPHelper.rebuild(project, commands, null, "BuildHashlink.xml");
		}

		CPPHelper.rebuild(project, commands);
	}

	public override function run():Void
	{
		var arguments = additionalArguments.copy();

		if (Log.verbose)
		{
			arguments.push("-verbose");
		}

		if (project.target == System.hostPlatform)
		{
			arguments = arguments.concat(["-livereload"]);
			System.runCommand(applicationDirectory, Path.withoutDirectory(executablePath), arguments);
		}
	}

	public override function update():Void
	{
		AssetHelper.processLibraries(project, targetDirectory);

		if (project.targetFlags.exists("xml"))
		{
			project.haxeflags.push("--xml " + targetDirectory + "/types.xml");
		}

		if (project.targetFlags.exists("json"))
		{
			project.haxeflags.push("--json " + targetDirectory + "/types.json");
		}

		var context = generateContext();
		context.OUTPUT_DIR = targetDirectory;

		System.mkdir(targetDirectory);
		System.mkdir(targetDirectory + "/obj");
		System.mkdir(targetDirectory + "/haxe");
		System.mkdir(applicationDirectory);

		ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, targetType + "/hxml", targetDirectory + "/haxe", context);

		if (targetType == "cpp")
		{
			ProjectHelper.recursiveSmartCopyTemplate(project, "windows/resource", targetDirectory + "/obj", context);
		}

		copyProjectAssets(applicationDirectory);
	}

	@ignore public override function install():Void {}

	@ignore public override function trace():Void {}

	@ignore public override function uninstall():Void {}
}
