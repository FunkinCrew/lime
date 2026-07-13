package;

import hxp.HXML;
import hxp.NDLL;
import hxp.Path;
import hxp.System;
import lime.tools.AssetHelper;
import lime.tools.CPPHelper;
import lime.tools.HTML5Helper;
import lime.tools.HXProject;
import lime.tools.Icon;
import lime.tools.IconHelper;
import lime.tools.Orientation;
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;
import sys.FileSystem;
import sys.io.File;

class EmscriptenTarget extends PlatformTarget
{
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
				url: "",
				init: null
			};

		defaults.window =
			{
				width: 800,
				height: 600,
				parameters: "{}",
				background: 0xFFFFFF,
				fps: 60,
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

		for (i in 1...project.windows.length)
		{
			defaults.windows.push(defaults.window);
		}

		defaults.merge(project);

		project = defaults;

		targetDirectory = Path.combine(project.app.path, project.config.getString("emscripten.output-directory", "emscripten"));
	}

	public override function build():Void
	{
		var hxml = targetDirectory + "/haxe/" + buildType + ".hxml";

		System.mkdir(targetDirectory);

		System.runCommand("", "haxe", [hxml, "-D", "emscripten"]);

		if (noOutput) return;

		CPPHelper.compile(project, targetDirectory + "/obj", [
			"-Demscripten",
			"-DHXCPP_LINK_NO_EXCEPTIONS",
			"-DHXCPP_EMSCRIPTEN_LONGJUMP"
		]);

		var applicationMain:String = 'ApplicationMain' + (project.debug ? "-debug" : "");

		System.copyIfNewer(targetDirectory + '/obj/$applicationMain.html', targetDirectory + "/bin/index.html");

		System.copyIfNewer(targetDirectory + '/obj/$applicationMain.js', targetDirectory + '/bin/$applicationMain.js');

		System.copyIfNewer(targetDirectory + '/obj/$applicationMain.wasm', targetDirectory + '/bin/$applicationMain.wasm');

		if (FileSystem.exists(targetDirectory + '/obj/$applicationMain.data'))
		{
			System.copyIfNewer(targetDirectory + '/obj/$applicationMain.data', targetDirectory + '/bin/$applicationMain.data');
		}
	}

	public override function deploy():Void {}

	public override function display():Void
	{
		Sys.println(getDisplayHXML().toString());
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

	public override function install():Void {}

	public override function rebuild():Void
	{
		final commands:Array<Array<String>> = [];

		commands.push([
			"-Demscripten",
			"-Dstatic_link",
			"-DHXCPP_LINK_NO_EXCEPTIONS",
			"-DHXCPP_EMSCRIPTEN_LONGJUMP"
		]);

		CPPHelper.rebuild(project, commands);
	}

	public override function run():Void
	{
		HTML5Helper.launch(project, targetDirectory + "/bin");
	}

	public override function trace():Void {}

	public override function uninstall():Void {}

	public override function update():Void
	{
		AssetHelper.processLibraries(project, targetDirectory);

		var destination = targetDirectory + "/bin/";

		System.mkdir(destination);

		if (project.targetFlags.exists("xml"))
		{
			project.haxeflags.push("-xml " + targetDirectory + "/types.xml");
		}

		if (project.targetFlags.exists("json"))
		{
			project.haxeflags.push("-json " + targetDirectory + "/types.json");
		}

		var context = project.templateContext;

		context.WIN_FLASHBACKGROUND = project.window.background != null ? StringTools.hex(project.window.background, 6) : "";
		context.OUTPUT_DIR = targetDirectory;
		context.CPP_DIR = targetDirectory + "/obj";
		context.ASSETS_DIR = FileSystem.absolutePath(destination + "assets@/");

		context.LIB_PATHS = [];

		for (ndll in project.ndlls)
		{
			final libPath:String = NDLL.getLibraryPath(ndll, "Emscripten", "lib", ".a", project.debug);

			context.LIB_PATHS.push(libPath);
		}

		context.favicons = [];

		var icons = project.icons;

		if (icons.length == 0)
		{
			icons = [new Icon(System.findTemplate(project.templatePaths, "default/icon.svg"))];
		}

		if (IconHelper.createIcon(icons, 192, 192, Path.combine(destination, "favicon.png")))
		{
			context.favicons.push({rel: "shortcut icon", type: "image/png", href: "./favicon.png"});
		}

		ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "emscripten/hxml", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "emscripten/template", targetDirectory + "/obj", context);

		copyProjectAssets(destination + "assets");
	}
}
