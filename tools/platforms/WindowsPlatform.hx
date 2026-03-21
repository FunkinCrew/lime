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
		else if (project.targetFlags.exists("cppia"))
		{
			targetType = "cppia";
			is64 = true;
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
				var fileName = Path.withoutDirectory(dependency.path);
				copyIfNewer(dependency.path, applicationDirectory + "/" + fileName);
			}
		}

		if (!project.targetFlags.exists("static") || targetType != "cpp")
		{
			var targetSuffix = (targetType == "hl") ? ".hdll" : null;

			for (ndll in project.ndlls)
			{
				// TODO: Support single binary for HashLink
				if (targetType == "hl")
				{
					ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".hdll", applicationDirectory, project.debug,
						targetSuffix);
					ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".lib", applicationDirectory, project.debug,
						".lib");
				}
				else
				{
					ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "",
						(ndll.haxelib != null && (ndll.haxelib.name == "hxcpp" || ndll.haxelib.name == "hxlibc")) ? ".dll" : ".ndll",
						applicationDirectory, project.debug, targetSuffix);
				}
			}
		}

		// IconHelper.createIcon (project.icons, 32, 32, Path.combine (applicationDirectory, "icon.png"));

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
					var vcvarsallCommand = [vcvarsallPath, "x64"].map(arg -> ~/([&|\(\)<>\^ ])/g.replace(arg, "^$1"));
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
					clCommand = clCommand.map(arg -> ~/([&|\(\)<>\^ ])/g.replace(arg, "^$1"));
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
		else if (targetType == "cppia")
		{
			System.runCommand("", "haxe", [hxml]);

			if (noOutput) return;

			System.copyFile(Path.combine(Haxelib.getPath(new Haxelib("hxcpp")), "bin/Windows64/Cppia.exe"), executablePath);
			System.copyFile(targetDirectory + "/obj/ApplicationMain.cppia", Path.combine(applicationDirectory, "script.cppia"));

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
				flags.push("-DHXCPP_M32");
			}

			if (!project.environment.exists("SHOW_CONSOLE"))
			{
				haxeArgs.push("-D");
				haxeArgs.push("no_console");
				flags.push("-Dno_console");
			}

			if (!project.targetFlags.exists("static"))
			{
				System.runCommand("", "haxe", haxeArgs);

				if (noOutput) return;

				IconHelper.createWindowsIcon(icons, Path.combine(targetDirectory + "/obj", "ApplicationMain.ico"));

				CPPHelper.compile(project, targetDirectory + "/obj", flags);

				System.copyFile(targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : "") + ".exe", executablePath);

				if (project.defines.exists("mingw"))
				{
					var libraries = ["libwinpthread-1.dll", "libstdc++-6.dll"];
					if (is64)
					{
						libraries.push("libgcc_s_seh-1.dll");
					}
					else
					{
						libraries.push("libgcc_s_dw2-1.dll");
					}

					for (library in libraries)
					{
						System.copyIfNewer(targetDirectory + "/obj/" + library, Path.combine(applicationDirectory, library));
					}
				}
			}
			else
			{
				System.runCommand("", "haxe", haxeArgs.concat(["-D", "static_link"]));

				if (noOutput) return;

				IconHelper.createWindowsIcon(icons, Path.combine(targetDirectory + "/obj", "ApplicationMain.ico"));

				CPPHelper.compile(project, targetDirectory + "/obj", flags.concat(["-Dstatic_link"]));

				CPPHelper.compile(project, targetDirectory + "/obj", flags, "BuildMain.xml");

				System.copyFile(targetDirectory + "/obj/Main" + (project.debug ? "-debug" : "") + ".exe", executablePath);
			}
		}
	}

	public override function clean():Void
	{
		if (FileSystem.exists(targetDirectory))
		{
			System.removeDirectory(targetDirectory);
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
		context.CPPIA_FILE = targetDirectory + "/obj/ApplicationMain.cppia";
		context.CPP_DIR = targetDirectory + "/obj";
		context.BUILD_DIR = project.app.path + "/windows" + (is64 ? "64" : "");

		return context;
	}

	private function getDisplayHXML():HXML
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
				case "cppia":
					hxml.cppia = "_.cppia";
				default:
					hxml.cpp = "_";
			}
			hxml.noOutput = true;
			return hxml;
		}
	}

	public override function rebuild():Void
	{
		// if (project.environment.exists ("VS110COMNTOOLS") && project.environment.exists ("VS100COMNTOOLS")) {

		// project.environment.set ("HXCPP_MSVC", project.environment.get ("VS100COMNTOOLS"));
		// Sys.putEnv ("HXCPP_MSVC", project.environment.get ("VS100COMNTOOLS"));

		// }

		var commands = [];
		if (targetType == "hl")
		{
			// default to 64 bit, just like upstream Hashlink releases
			if (!targetFlags.exists("32") && !targetFlags.exists("x86_32")
				&& (System.hostArchitecture == X64 || targetFlags.exists("64") || targetFlags.exists("x86_64")))
			{
				commands.push(["-Dwindows", "-DHXCPP_M64", "-Dhashlink"]);
			}
			else
			{
				commands.push(["-Dwindows", "-DHXCPP_M32", "-Dhashlink"]);
			}
		}
		else
		{
			if (!targetFlags.exists("64") && !targetFlags.exists("x86_64") && (command == "rebuild" || System.hostArchitecture == X86 || targetType != "cpp"))
			{
				commands.push(["-Dwindows", "-DHXCPP_M32"]);
			}

			// TODO: Compiling with -Dfulldebug overwrites the same "-debug.pdb"
			// as previous Windows builds. For now, force -64 to be done last
			// so that it can be debugged in a default "rebuild"

			if (!targetFlags.exists("32") && !targetFlags.exists("x86_32") && System.hostArchitecture == X64 && (command != "rebuild" || targetType == "cpp"))
			{
				commands.push(["-Dwindows", "-DHXCPP_M64"]);
			}
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

		if (targetType == "cppia")
		{
			// arguments = arguments.concat(["-livereload"]);
			arguments = ["script.cppia"]; // .concat(arguments);
			System.runCommand(applicationDirectory, Path.withoutDirectory(executablePath), arguments);
		}
		else if (project.target == System.hostPlatform)
		{
			arguments = arguments.concat(["-livereload"]);
			System.runCommand(applicationDirectory, Path.withoutDirectory(executablePath), arguments);
		}
	}

	public override function update():Void
	{
		AssetHelper.processLibraries(project, targetDirectory);

		// project = project.clone ();

		if (project.targetFlags.exists("xml"))
		{
			project.haxeflags.push("-xml " + targetDirectory + "/types.xml");
		}

		for (asset in project.assets)
		{
			if (asset.embed && asset.sourcePath == "")
			{
				var path = Path.combine(targetDirectory + "/obj/tmp", asset.targetPath);
				System.mkdir(Path.directory(path));
				AssetHelper.copyAsset(asset, path);
				asset.sourcePath = path;
			}
		}

		var context = generateContext();
		context.OUTPUT_DIR = targetDirectory;

		if (targetType == "cpp" && project.targetFlags.exists("static"))
		{
			var programFiles = project.environment.get("ProgramFiles(x86)");
			var hasVSCommunity = (programFiles != null
				&& FileSystem.exists(Path.combine(programFiles, "Microsoft Visual Studio/Installer/vswhere.exe")));
			var hxcppMSVC = project.environment.get("HXCPP_MSVC");
			var vs140 = project.environment.get("VS140COMNTOOLS");

			var msvc19 = true;

			if ((!hasVSCommunity && vs140 == null) || (hxcppMSVC != null && hxcppMSVC != vs140))
			{
				msvc19 = false;
			}

			var suffix = (msvc19 ? "-19.lib" : ".lib");

			for (i in 0...project.ndlls.length)
			{
				var ndll = project.ndlls[i];

				if (ndll.path == null || ndll.path == "")
				{
					context.ndlls[i].path = NDLL.getLibraryPath(ndll, "Windows" + (is64 ? "64" : ""), "lib", suffix, project.debug);
				}
			}
		}

		System.mkdir(targetDirectory);
		System.mkdir(targetDirectory + "/obj");
		System.mkdir(targetDirectory + "/haxe");
		System.mkdir(applicationDirectory);

		// SWFHelper.generateSWFClasses (project, targetDirectory + "/haxe");

		ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, targetType + "/hxml", targetDirectory + "/haxe", context);

		if (targetType == "cpp")
		{
			ProjectHelper.recursiveSmartCopyTemplate(project, "windows/resource", targetDirectory + "/obj", context);

			if (project.targetFlags.exists("static"))
			{
				ProjectHelper.recursiveSmartCopyTemplate(project, "cpp/static", targetDirectory + "/obj", context);
			}
		}

		/*if (IconHelper.createIcon (project.icons, 32, 32, Path.combine (applicationDirectory, "icon.png"))) {

			context.HAS_ICON = true;
			context.WIN_ICON = "icon.png";

		}*/

		for (asset in project.assets)
		{
			if (asset.embed != true)
			{
				var path = Path.combine(applicationDirectory, asset.targetPath);

				if (asset.type != AssetType.TEMPLATE)
				{
					System.mkdir(Path.directory(path));
					AssetHelper.copyAssetIfNewer(asset, path);
				}
				else
				{
					System.mkdir(Path.directory(path));
					AssetHelper.copyAsset(asset, path, context);
				}
			}
		}
	}

	public override function watch():Void
	{
		var hxml = getDisplayHXML();
		var dirs = hxml.getClassPaths(true);

		var outputPath = Path.combine(Sys.getCwd(), project.app.path);
		dirs = dirs.filter(function(dir)
		{
			return (!Path.startsWith(dir, outputPath));
		});

		var command = ProjectHelper.getCurrentCommand();
		System.watch(command, dirs);
	}

	@ignore public override function install ():Void {}

	@ignore public override function trace():Void {}

	@ignore public override function uninstall ():Void {}
}
