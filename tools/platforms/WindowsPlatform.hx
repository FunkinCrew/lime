package;

import hxp.HXML;
import hxp.Log;
import hxp.Path;
import hxp.System;

import lime.tools.Architecture;
import lime.tools.AssetHelper;
import lime.tools.CPPHelper;
import lime.tools.DeploymentHelper;
import lime.tools.HXProject;
import lime.tools.Icon;
import lime.tools.IconHelper;
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;

import sys.FileSystem;
import sys.io.File;

class WindowsPlatform extends PlatformTarget
{
	private var applicationDirectory:String;
	private var executablePath:String;
	private var is64:Bool;
	private var outputFile:String;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults:HXProject = createDefaultProject();

		switch (System.hostArchitecture)
		{
			case ARMV7:
				defaults.architectures = [ARMV7];
			case X86:
				defaults.architectures = [X86];
			case X64:
				defaults.architectures = [X64];
			default:
				defaults.architectures = [];
		}

		defaults.merge(project);

		project = defaults;

		for (excludeArchitecture in project.excludeArchitectures)
		{
			project.architectures.remove(excludeArchitecture);
		}

		for (architecture in project.architectures)
		{
			if (architecture == Architecture.X64)
			{
				is64 = true;
			}
		}

		targetDirectory = Path.combine(project.app.path, project.config.getString("windows.output-directory", "windows"));
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
			else
			{
				copyIfNewer(Path.combine(dependency.path, "Windows" + (is64 ? "64" : "") + "/" + dependency.name + ".dll"),
					applicationDirectory
					+ "/"
					+ dependency.name
					+ ".dll");
			}
		}

		for (ndll in project.ndlls)
		{
			ProjectHelper.copyLibrary(project, ndll, "Windows" + (is64 ? "64" : ""), "", ".ndll", applicationDirectory, project.debug);
		}

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

			// For some reason `MinGW` uses the shared deps by default, which we don't really want, do we?
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

		if (noOutput)
			return;

		IconHelper.createWindowsIcon(icons, Path.combine(targetDirectory + "/obj", "ApplicationMain.ico"));

		CPPHelper.compile(project, targetDirectory + "/obj", flags);

		System.copyFile(targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : "") + ".exe", executablePath);
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
		context.CPP_DIR = targetDirectory + "/obj";

		return context;
	}

	private override function getDisplayHXML():HXML
	{
		var path = targetDirectory + "/haxe/" + buildType + ".hxml";

		// try to use the existing .hxml file. however, if the project file was
		// modified more recently than the .hxml, then the .hxml cannot be
		// considered valid anymore. it may cause errors in editors like vscode.
		if (FileSystem.exists(path)
			&& (project.projectFilePath == null
				|| !FileSystem.exists(project.projectFilePath)
				|| (FileSystem.stat(path).mtime.getTime() > FileSystem.stat(project.projectFilePath).mtime.getTime())))
		{
			return File.getContent(path);
		}
		else
		{
			var context = project.templateContext;
			var hxml = HXML.fromString(context.HAXE_FLAGS);
			hxml.addClassName(context.APP_MAIN);
			hxml.cpp = "_";
			hxml.noOutput = true;
			return hxml;
		}
	}

	public override function rebuild():Void
	{
		var commands:Array<Array<String>> = [];

		var x86_64:Bool = targetFlags.exists("64") || targetFlags.exists("x86_64");
		var x86_32:Bool = targetFlags.exists("32") || targetFlags.exists("x86_32");

		if (!x86_64 && !x86_32)
		{
			x86_64 = System.hostArchitecture == X64;
			x86_32 = System.hostArchitecture == X86;
		}

		if (x86_64)
		{
			var args:Array<String> = ["-Dwindows", "-DHXCPP_M64"];

			if (project.targetFlags.exists("mingw"))
			{
				args.push("-Dmingw");

				// For some reason `MinGW` uses the shared deps by default, which we don't really want, do we?
				args.push("-Dno_shared_libs");
			}

			commands.push(args);
		}

		if (x86_32)
		{
			var args:Array<String> = ["-Dwindows", "-DHXCPP_M32"];

			if (project.targetFlags.exists("mingw"))
			{
				args.push("-Dmingw");

				// For some reason `MinGW` uses the shared deps by default, which we don't really want, do we?
				args.push("-Dno_shared_libs");
			}

			commands.push(args);
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
		else if (project.targetFlags.exists("mingw"))
		{
			arguments = arguments.concat(["-livereload"]);

			var winePath = project.defines.get("WINE_PATH");

			if (winePath == null || winePath.length == 0)
			{
				return;
			}

			var crossoverBottle = project.defines.get("CROSSOVER_BOTTLE");

			if (crossoverBottle != null && crossoverBottle.length > 0)
			{
				Sys.putEnv('CX_BOTTLE', crossoverBottle);
			}

			System.runCommand(applicationDirectory, winePath, [Path.withoutDirectory(executablePath)].concat(arguments));
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
		ProjectHelper.recursiveSmartCopyTemplate(project, "cpp/hxml", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "windows/resource", targetDirectory + "/obj", context);

		copyProjectAssets(applicationDirectory);
	}

	public override function install():Void {}

	public override function trace():Void {}

	public override function uninstall():Void {}
}
