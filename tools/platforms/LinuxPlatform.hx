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
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;

import sys.FileSystem;
import sys.io.File;

class LinuxPlatform extends PlatformTarget
{
	private var applicationDirectory:String;
	private var executablePath:String;
	private var is64:Bool;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults:HXProject = createDefaultProject();

		switch (System.hostArchitecture)
		{
			case ARMV7:
				defaults.architectures = [ARMV7];
			case ARM64:
				defaults.architectures = [ARM64];
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
			if (!targetFlags.exists("32")
				&& !targetFlags.exists("x86_32")
				&& (architecture == Architecture.X64 || architecture == Architecture.ARM64))
			{
				is64 = true;
			}
			else if (architecture == Architecture.ARMV7)
			{
				is64 = false;
			}
		}

		targetDirectory = Path.combine(project.app.path, project.config.getString("linux.output-directory", "linux"));
		targetDirectory = StringTools.replace(targetDirectory, "arch64", is64 ? "64" : "");
		applicationDirectory = targetDirectory + "/bin/";
		executablePath = Path.combine(applicationDirectory, project.app.file);
	}

	public override function build():Void
	{
		var hxml = targetDirectory + "/haxe/" + buildType + ".hxml";

		System.mkdir(targetDirectory);

		for (dependency in project.dependencies)
		{
			if (StringTools.endsWith(dependency.path, ".so"))
			{
				copyIfNewer(dependency.path, applicationDirectory + "/" + Path.withoutDirectory(dependency.path));
			}
			else
			{
				copyIfNewer(Path.combine(dependency.path,
					"Linux"
					+ ((System.hostArchitecture == ARMV7 || System.hostArchitecture == ARM64) ? "Arm" : "")
					+ (is64 ? "64" : "")
					+ "/"
					+ dependency.name
					+ ".so"),
					applicationDirectory
					+ "/"
					+ dependency.name
					+ ".so");
			}
		}

		for (ndll in project.ndlls)
		{
			ProjectHelper.copyLibrary(project, ndll,
				"Linux" + ((System.hostArchitecture == ARMV7 || System.hostArchitecture == ARM64) ? "Arm" : "") + (is64 ? "64" : ""), "", ".ndll",
				applicationDirectory, project.debug);
		}

		var haxeArgs:Array<String> = [hxml];
		var flags:Array<String> = [];

		if (is64)
		{
			if (System.hostArchitecture == ARM64)
			{
				haxeArgs.push("-D");
				haxeArgs.push("HXCPP_ARM64");
				flags.push("-DHXCPP_ARM64");
			}
			else
			{
				haxeArgs.push("-D");
				haxeArgs.push("HXCPP_M64");
				flags.push("-DHXCPP_M64");
			}
		}
		else
		{
			haxeArgs.push("-D");
			haxeArgs.push("HXCPP_M32");
			flags.push("-DHXCPP_M32");
		}

		if (project.target != System.hostPlatform)
		{
			var hxcpp_xlinux64_cxx = project.defines.get("HXCPP_XLINUX64_CXX");
			if (hxcpp_xlinux64_cxx == null)
			{
				hxcpp_xlinux64_cxx = "x86_64-unknown-linux-gnu-g++";
			}
			var hxcpp_xlinux64_strip = project.defines.get("HXCPP_XLINUX64_STRIP");
			if (hxcpp_xlinux64_strip == null)
			{
				hxcpp_xlinux64_strip = "x86_64-unknown-linux-gnu-strip";
			}
			var hxcpp_xlinux64_ranlib = project.defines.get("HXCPP_XLINUX64_RANLIB");
			if (hxcpp_xlinux64_ranlib == null)
			{
				hxcpp_xlinux64_ranlib = "x86_64-unknown-linux-gnu-ranlib";
			}
			var hxcpp_xlinux64_ar = project.defines.get("HXCPP_XLINUX64_AR");
			if (hxcpp_xlinux64_ar == null)
			{
				hxcpp_xlinux64_ar = "x86_64-unknown-linux-gnu-ar";
			}
			flags.push('-DHXCPP_XLINUX64_CXX=$hxcpp_xlinux64_cxx');
			flags.push('-DHXCPP_XLINUX64_STRIP=$hxcpp_xlinux64_strip');
			flags.push('-DHXCPP_XLINUX64_RANLIB=$hxcpp_xlinux64_ranlib');
			flags.push('-DHXCPP_XLINUX64_AR=$hxcpp_xlinux64_ar');

			var hxcpp_xlinux32_cxx = project.defines.get("HXCPP_XLINUX32_CXX");
			if (hxcpp_xlinux32_cxx == null)
			{
				hxcpp_xlinux32_cxx = "i686-unknown-linux-gnu-g++";
			}
			var hxcpp_xlinux32_strip = project.defines.get("HXCPP_XLINUX32_STRIP");
			if (hxcpp_xlinux32_strip == null)
			{
				hxcpp_xlinux32_strip = "i686-unknown-linux-gnu-strip";
			}
			var hxcpp_xlinux32_ranlib = project.defines.get("HXCPP_XLINUX32_RANLIB");
			if (hxcpp_xlinux32_ranlib == null)
			{
				hxcpp_xlinux32_ranlib = "i686-unknown-linux-gnu-ranlib";
			}
			var hxcpp_xlinux32_ar = project.defines.get("HXCPP_XLINUX32AR");
			if (hxcpp_xlinux32_ar == null)
			{
				hxcpp_xlinux32_ar = "i686-unknown-linux-gnu-ar";
			}
			flags.push('-DHXCPP_XLINUX32_CXX=$hxcpp_xlinux32_cxx');
			flags.push('-DHXCPP_XLINUX32_STRIP=$hxcpp_xlinux32_strip');
			flags.push('-DHXCPP_XLINUX32_RANLIB=$hxcpp_xlinux32_ranlib');
			flags.push('-DHXCPP_XLINUX32_AR=$hxcpp_xlinux32_ar');
		}

		System.runCommand("", "haxe", haxeArgs);

		if (noOutput)
			return;

		CPPHelper.compile(project, targetDirectory + "/obj", flags);

		System.copyFile(targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : ""), executablePath);

		if (System.hostPlatform != WINDOWS)
		{
			System.runCommand("", "chmod", ["755", executablePath]);
		}
	}

	public override function deploy():Void
	{
		DeploymentHelper.deploy(project, targetFlags, targetDirectory, "Linux " + (is64 ? "64" : "32") + "-bit");
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

	private function generateWaylandProtocols():Void
	{
		var projectPath:String = project.config.get("project.rebuild.path");
		var waylandOutputPath:String = Path.combine(projectPath, "lib/sdl/wayland-generated-protocols");
		var waylandProtocolsPath:String = Path.combine(projectPath, "lib/sdl/wayland-protocols");

		if (project.targetFlags.exists("clean"))
		{
			// If we're doing a clean build,
			// remove the generated Wayland protocol files so they get regenerated
			System.removeDirectory(waylandOutputPath);
		}

		if (!FileSystem.exists(waylandOutputPath))
		{
			FileSystem.createDirectory(waylandOutputPath);
		}

		if (FileSystem.exists(waylandProtocolsPath))
		{
			var xmls:Array<String> = FileSystem.readDirectory(waylandProtocolsPath);

			xmls = xmls.filter(function(xml:String):Bool
			{
				if (haxe.io.Path.extension(xml) != "xml")
				{
					return false;
				}

				var output:String = Path.combine(waylandOutputPath, '${haxe.io.Path.withoutExtension(xml)}-client-protocol');

				if (FileSystem.exists(haxe.io.Path.withExtension(output, "h"))
					&& FileSystem.exists(haxe.io.Path.withExtension(output, "c")))
				{
					return false;
				}

				return true;
			});

			if (xmls.length > 0)
			{
				Log.println('\x1b[1;33mGenerating Wayland Protocols (${xmls.length > 1 ? xmls.length + " files" : "1 file"})\x1b[0m');

				for (xml in xmls)
				{
					var output:String = Path.combine(waylandOutputPath, '${haxe.io.Path.withoutExtension(xml)}-client-protocol');

					if (FileSystem.exists(haxe.io.Path.withExtension(output, "h"))
						&& FileSystem.exists(haxe.io.Path.withExtension(output, "c")))
					{
						continue;
					}

					var file:String = Path.combine(StringTools.replace(waylandOutputPath, haxe.io.Path.addTrailingSlash(projectPath), ''), xml);

					Log.println(' - \x1b[1;33m$file\x1b[0m');

					System.runCommand("", "wayland-scanner", [
						"client-header",
						Path.combine(waylandProtocolsPath, xml),
						haxe.io.Path.withExtension(output, "h")
					]);

					System.runCommand("", "wayland-scanner", [
						"private-code",
						Path.combine(waylandProtocolsPath, xml),
						haxe.io.Path.withExtension(output, "c")
					]);
				}
			}
		}
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
		if (project.haxelibs.length == 0)
		{
			// If there are no haxelibs, we know it's only lime that is being rebuilt (weird hack but works),
			// Wayland shouldn't be rebuilt for anything else other than lime!
			generateWaylandProtocols();
		}

		var commands:Array<Array<String>> = [];

		var arm64:Bool = targetFlags.exists("arm64");
		var x86_64:Bool = targetFlags.exists("64") || targetFlags.exists("x86_64");
		var x86_32:Bool = targetFlags.exists("32") || targetFlags.exists("x86_32");

		if (!arm64 && !x86_64 && !x86_32)
		{
			arm64 = System.hostArchitecture == ARM64;
			x86_64 = System.hostArchitecture == X64;
			x86_32 = System.hostArchitecture == X86;
		}

		if (arm64)
		{
			commands.push(["-Dlinux", "-DHXCPP_ARM64"]);
		}

		if (x86_64)
		{
			commands.push(["-Dlinux", "-DHXCPP_M64"]);
		}

		if (x86_32)
		{
			commands.push(["-Dlinux", "-DHXCPP_M32"]);
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
			System.runCommand(applicationDirectory, "./" + Path.withoutDirectory(executablePath), arguments);
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

		copyProjectAssets(applicationDirectory);
	}

	public override function install():Void {}

	public override function trace():Void {}

	public override function uninstall():Void {}
}
