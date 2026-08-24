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

class MacPlatform extends PlatformTarget
{
	private var applicationDirectory:String;
	private var contentDirectory:String;
	private var executableDirectory:String;
	private var executablePath:String;
	private var targetArchitecture:Architecture;

	private var dirSuffix(get, never):String;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults:HXProject = createDefaultProject();

		defaults.merge(project);

		project = defaults;

		for (excludeArchitecture in project.excludeArchitectures)
		{
			project.architectures.remove(excludeArchitecture);
		}

		targetArchitecture = System.hostArchitecture;

		for (architecture in project.architectures)
		{
			if (architecture.isARM() || architecture.isX())
			{
				targetArchitecture = architecture;
				break;
			}
		}

		targetDirectory = Path.combine(project.app.path, project.config.getString("mac.output-directory", "macos"));
		targetDirectory = StringTools.replace(targetDirectory, "arch64", dirSuffix);
		applicationDirectory = targetDirectory + "/bin/" + project.app.file + ".app";
		contentDirectory = applicationDirectory + "/Contents/Resources";
		executableDirectory = applicationDirectory + "/Contents/MacOS";
		executablePath = executableDirectory + "/" + project.app.file;
	}

	public override function build():Void
	{
		var hxml = targetDirectory + "/haxe/" + buildType + ".hxml";

		System.mkdir(targetDirectory);

		for (dependency in project.dependencies)
		{
			if (StringTools.endsWith(dependency.path, ".dylib"))
			{
				copyIfNewer(dependency.path, executableDirectory + "/" + Path.withoutDirectory(dependency.path));
			}
			else
			{
				copyIfNewer(Path.combine(dependency.path, "Mac" + dirSuffix + "/" + dependency.name + ".dylib"),
					executableDirectory
					+ "/"
					+ dependency.name
					+ ".dylib");
			}
		}

		for (ndll in project.ndlls)
		{
			ProjectHelper.copyLibrary(project, ndll, "Mac" + dirSuffix, "", ".ndll", executableDirectory, project.debug);
		}

		var haxeArgs = [hxml, "-D", "HXCPP_CLANG"];
		var flags = ["-DHXCPP_CLANG"];

		if (targetArchitecture == X64)
		{
			haxeArgs.push("-D");
			haxeArgs.push("HXCPP_M64");
			flags.push("-DHXCPP_M64");
		}
		else if (targetArchitecture == ARM64)
		{
			haxeArgs.push("-D");
			haxeArgs.push("HXCPP_ARM64");
			flags.push("-DHXCPP_ARM64");
		}

		System.runCommand("", "haxe", haxeArgs);

		if (noOutput)
			return;

		CPPHelper.compile(project, targetDirectory + "/obj", flags);

		System.copyFile(targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : ""), executablePath);

		if (System.hostPlatform != WINDOWS && sys.FileSystem.exists(executablePath))
		{
			System.runCommand("", "chmod", ["755", executablePath]);
		}
	}

	public override function deploy():Void
	{
		DeploymentHelper.deploy(project, targetFlags, targetDirectory, "Mac");
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

		switch (System.hostArchitecture)
		{
			case X64:
				if (targetFlags.exists("arm64"))
				{
					commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_ARM64"]);
				}
				else if (!targetFlags.exists("32") && !targetFlags.exists("x86_32"))
				{
					commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_M64"]);
				}
				else
				{
					commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_M32"]);
				}
			case X86:
				commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_M32"]);
			case ARM64:
				if (targetFlags.exists("64") || targetFlags.exists("x86_64"))
				{
					commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_ARCH=x86_64"]);
				}
				else
				{
					commands.push(["-Dmac", "-DHXCPP_CLANG", "-DHXCPP_ARM64"]);
				}
			default:
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
			System.runCommand(executableDirectory, "./" + Path.withoutDirectory(executablePath), arguments);
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
		System.mkdir(contentDirectory);

		ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "cpp/hxml", targetDirectory + "/haxe", context);

		System.copyFileTemplate(project.templatePaths, "mac/Info.plist", targetDirectory + "/bin/" + project.app.file + ".app/Contents/Info.plist", context);
		System.copyFileTemplate(project.templatePaths, "mac/Entitlements.plist",
			targetDirectory
			+ "/bin/"
			+ project.app.file
			+ ".app/Contents/Entitlements.plist", context);

		// We use some technique to generate the .icns file for legacy macOS versions (before macOS 26) from the Icon Composer file
		if ((project.adaptiveIcon != null && project.adaptiveIcon.iconComposerFile) && System.hostPlatform == MAC)
		{
			try
			{
				System.runProcess("", "xcrun", [
					"actool", project.adaptiveIcon.path,
					"--compile", contentDirectory,
					"--app-icon", "icon",
					"--include-all-app-icons",
					"--output-partial-info-plist", "/dev/null",
					"--minimum-deployment-target", "11.0",
					"--platform", "macosx",
					"--target-device", "mac",
				], false, false);
			}
			catch (e:Dynamic)
			{
				Log.warn("Failed to compile adaptive icon via actool");
			}
		} else {
			var icons = project.icons;

			if (icons.length == 0)
			{
				icons = [new Icon(System.findTemplate(project.templatePaths, "default/icon.svg"))];
			}

			IconHelper.createMacIcon(icons, Path.combine(contentDirectory, "icon.icns"));
		}

		copyProjectAssets(targetDirectory, contentDirectory);


	}

	public override function install():Void {}

	public override function trace():Void {}

	public override function uninstall():Void {}

	// Getters & Setters

	private inline function get_dirSuffix():String
	{
		return targetArchitecture == X64 ? "64" : targetArchitecture == ARM64 ? "Arm64" : "";
	}
}
