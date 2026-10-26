package;

import hxp.HXML;
import hxp.Log;
import hxp.Path;
import hxp.System;

import lime.text.Font;
import lime.tools.AssetHelper;
import lime.tools.AssetType;
import lime.tools.DeploymentHelper;
import lime.tools.ElectronHelper;
import lime.tools.HTML5Helper;
import lime.tools.HXProject;
import lime.tools.Icon;
import lime.tools.IconHelper;
import lime.tools.ModuleHelper;
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;

import sys.FileSystem;
import sys.io.File;

class HTML5Platform extends PlatformTarget
{
	private var dependencyPath:String;
	private var npm:Bool;
	private var outputFile:String;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults:HXProject = createDefaultProject();
		defaults.window.width = 0;
		defaults.window.height = 0;
		defaults.window.allowHighDPI = true;
		defaults.window.requireShaders = true;
		defaults.merge(project);

		project = defaults;

		initialize(command, project);
	}

	public override function build():Void
	{
		if (npm)
		{
			if (command == "build")
			{
				var buildCommand = "build:" + (project.targetFlags.exists("final") ? "prod" : "dev");
				System.runCommand(targetDirectory + "/bin", "npm", ["run", buildCommand, "-s"]);
			}
			else
			{
				return;
			}
		}

		ModuleHelper.buildModules(project, targetDirectory + "/obj", targetDirectory + "/bin");

		if (project.app.main != null)
		{
			var type = "release";

			if (project.debug)
			{
				type = "debug";
			}
			else if (project.targetFlags.exists("final"))
			{
				type = "final";
			}

			var hxml = targetDirectory + "/haxe/" + type + ".hxml";
			System.runCommand("", "haxe", [hxml]);

			if (noOutput)
				return;

			HTML5Helper.encodeSourceMappingURL(targetDirectory + "/bin/" + project.app.file + ".js");

			if (project.targetFlags.exists("webgl"))
			{
				System.copyFile(targetDirectory + "/obj/ApplicationMain.js", outputFile);
			}

			if (project.modules.iterator().hasNext())
			{
				ModuleHelper.patchFile(outputFile);
			}

			if (FileSystem.exists(outputFile))
			{
				var context = project.templateContext;
				context.embeddedLibraries = [];

				for (dependency in project.dependencies)
				{
					if (dependency.embed && StringTools.endsWith(dependency.path, ".js") && FileSystem.exists(dependency.path))
					{
						var script = File.getContent(dependency.path);
						if (!dependency.allowWebWorkers)
						{
							script = 'if(typeof self === "undefined" || !self.constructor.name.includes("Worker")) { $script }';
						}
						context.embeddedLibraries.push(script);
					}
				}

				if (FileSystem.stat(outputFile).size > STREAMED_SOURCE_THRESHOLD)
				{
					wrapLargeOutputFile(context);
				}
				else
				{
					context.SOURCE_FILE = File.getContent(outputFile);
					System.copyFileTemplate(project.templatePaths, "html5/output.js", outputFile, context);
				}
			}
		}
	}

	public override function deploy():Void
	{
		var name = "HTML5";

		if (targetFlags.exists("electron"))
		{
			name = "Electron";
		}

		DeploymentHelper.deploy(project, targetFlags, targetDirectory, name);
	}

	public override function display():Void
	{
		if (project.targetFlags.exists("output-file"))
		{
			Sys.println(outputFile);
		}
		else
		{
			Sys.println(getDisplayHXML().toString());
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
			hxml.js = "_";
			hxml.define("html");
			if (targetFlags.exists("electron"))
			{
				hxml.define("electron");
			}
			hxml.noOutput = true;
			return hxml;
		}
	}

	private static inline var STREAMED_SOURCE_THRESHOLD:Int = 32 * 1024 * 1024;
	private static inline var STREAM_BUFFER_SIZE:Int = 1024 * 1024;

	private function wrapLargeOutputFile(context:Dynamic):Void
	{
		var sourceMarker = "__LIME_STREAMED_SOURCE_FILE_6F1A94C2__";
		var markerBytes = haxe.io.Bytes.ofString(sourceMarker);
		var renderedTemplatePath = outputFile + ".lime-template.tmp";
		var mergedOutputPath = outputFile + ".lime-merged.tmp";

		context.SOURCE_FILE = sourceMarker;
		System.copyFileTemplate(project.templatePaths, "html5/output.js", renderedTemplatePath, context);

		var markerIndex = findUniqueMarker(renderedTemplatePath, markerBytes);
		if (markerIndex < 0)
		{
			if (FileSystem.exists(renderedTemplatePath)) FileSystem.deleteFile(renderedTemplatePath);
			context.SOURCE_FILE = null;
			throw "Unable to stream the large HTML5 output: html5/output.js must resolve to exactly one SOURCE_FILE placeholder.";
		}

		context.SOURCE_FILE = null;
		var sourceSize = FileSystem.stat(outputFile).size;
		var templateSize = FileSystem.stat(renderedTemplatePath).size;
		var merged = File.write(mergedOutputPath, true);

		try
		{
			copyFileRange(renderedTemplatePath, merged, 0, markerIndex);
			copyFileRange(outputFile, merged, 0, sourceSize);
			copyFileRange(renderedTemplatePath, merged, markerIndex + markerBytes.length,
				templateSize - markerIndex - markerBytes.length);
			merged.close();
		}
		catch (error:Dynamic)
		{
			merged.close();
			if (FileSystem.exists(mergedOutputPath)) FileSystem.deleteFile(mergedOutputPath);
			if (FileSystem.exists(renderedTemplatePath)) FileSystem.deleteFile(renderedTemplatePath);
			throw error;
		}

		var mergedSize = FileSystem.stat(mergedOutputPath).size;
		var finalOutput = File.write(outputFile, true);
		try
		{
			copyFileRange(mergedOutputPath, finalOutput, 0, mergedSize);
			finalOutput.close();
		}
		catch (error:Dynamic)
		{
			finalOutput.close();
			if (FileSystem.exists(mergedOutputPath)) FileSystem.deleteFile(mergedOutputPath);
			if (FileSystem.exists(renderedTemplatePath)) FileSystem.deleteFile(renderedTemplatePath);
			throw error;
		}

		FileSystem.deleteFile(mergedOutputPath);
		FileSystem.deleteFile(renderedTemplatePath);
	}

	private function findUniqueMarker(path:String, marker:haxe.io.Bytes):Int
	{
		var fileSize = FileSystem.stat(path).size;
		var input = File.read(path, true);
		var buffer = haxe.io.Bytes.alloc(STREAM_BUFFER_SIZE);
		var carry = haxe.io.Bytes.alloc(marker.length - 1);
		var carryLength = 0;
		var remaining = fileSize;
		var totalRead = 0;
		var found = -1;
		var matches = 0;

		try
		{
			while (remaining > 0)
			{
				var chunkLength = remaining > buffer.length ? buffer.length : remaining;
				readBytesExactly(input, buffer, chunkLength);
				var combined = haxe.io.Bytes.alloc(carryLength + chunkLength);
				if (carryLength > 0) combined.blit(0, carry, 0, carryLength);
				combined.blit(carryLength, buffer, 0, chunkLength);

				var lastStart = combined.length - marker.length;
				var index = 0;
				while (index <= lastStart)
				{
					if (bytesMatchAt(combined, index, marker))
					{
						matches++;
						if (matches > 1)
						{
							input.close();
							return -1;
						}
						found = totalRead - carryLength + index;
					}
					index++;
				}

				carryLength = combined.length < marker.length - 1 ? combined.length : marker.length - 1;
				carry = haxe.io.Bytes.alloc(marker.length - 1);
				if (carryLength > 0) carry.blit(0, combined, combined.length - carryLength, carryLength);
				totalRead += chunkLength;
				remaining -= chunkLength;
			}
		}
		catch (error:Dynamic)
		{
			input.close();
			throw error;
		}

		input.close();
		return matches == 1 ? found : -1;
	}

	private function bytesMatchAt(source:haxe.io.Bytes, offset:Int, target:haxe.io.Bytes):Bool
	{
		if (offset < 0 || offset + target.length > source.length) return false;
		var index = 0;
		while (index < target.length)
		{
			if (source.get(offset + index) != target.get(index)) return false;
			index++;
		}
		return true;
	}

	private function readBytesExactly(input:haxe.io.Input, buffer:haxe.io.Bytes, length:Int):Void
	{
		var total = 0;
		while (total < length)
		{
			var count = input.readBytes(buffer, total, length - total);
			if (count <= 0) throw "Unexpected end of file while streaming the HTML5 output.";
			total += count;
		}
	}

	private function copyFileRange(path:String, output:haxe.io.Output, start:Int, length:Int):Void
	{
		var input = File.read(path, true);
		var buffer = haxe.io.Bytes.alloc(STREAM_BUFFER_SIZE);
		var skipRemaining = start;
		var copyRemaining = length;

		try
		{
			while (skipRemaining > 0)
			{
				var chunkLength = skipRemaining > buffer.length ? buffer.length : skipRemaining;
				readBytesExactly(input, buffer, chunkLength);
				skipRemaining -= chunkLength;
			}

			while (copyRemaining > 0)
			{
				var chunkLength = copyRemaining > buffer.length ? buffer.length : copyRemaining;
				readBytesExactly(input, buffer, chunkLength);
				output.writeBytes(buffer, 0, chunkLength);
				copyRemaining -= chunkLength;
			}
		}
		catch (error:Dynamic)
		{
			input.close();
			throw error;
		}

		input.close();
	}

	private function initialize(command:String, project:HXProject):Void
	{
		if (targetFlags.exists("electron"))
		{
			targetDirectory = Path.combine(project.app.path, project.config.getString("electron.output-directory", "electron"));
		}
		else
		{
			targetDirectory = Path.combine(project.app.path, project.config.getString("html5.output-directory", "html5"));
		}

		dependencyPath = project.config.getString("html5.dependency-path", "lib");
		outputFile = targetDirectory + "/bin/" + project.app.file + ".js";

		try
		{
			if (targetFlags.exists("npm") || (FileSystem.exists(targetDirectory + "/bin/package.json") && !targetFlags.exists("electron")))
			{
				npm = true;
				outputFile = project.app.file + ".js";
			}
		}
		catch (e:Dynamic) {}
	}

	public override function run():Void
	{
		if (npm)
		{
			var runCommand = "start:" + (project.targetFlags.exists("final") ? "prod" : "dev");
			System.runCommand(targetDirectory + "/bin", "npm", ["run", runCommand, "-s"]);
		}
		else if (targetFlags.exists("electron"))
		{
			var npx = targetFlags.exists("npx");
			ElectronHelper.launch(project, targetDirectory + "/bin", npx);
		}
		else
		{
			HTML5Helper.launch(project, targetDirectory + "/bin");
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

		var destination = targetDirectory + "/bin/";
		if (npm)
			destination += "dist/";
		System.mkdir(destination);

		var fontPath:String;

		if (Log.verbose)
		{
			project.haxedefs.set("verbose", 1);
		}

		ModuleHelper.updateProject(project);

		var libraryNames = new Map<String, Bool>();

		for (asset in project.assets)
		{
			if (asset.library != null && !libraryNames.exists(asset.library))
			{
				libraryNames[asset.library] = true;
			}
		}

		if (npm)
		{
			var path:String;
			for (i in 0...project.sources.length)
			{
				path = project.sources[i];
				if (StringTools.startsWith(path, targetDirectory) && !FileSystem.exists(Path.directory(path)))
				{
					System.mkdir(Path.directory(path));
				}
				project.sources[i] = Path.tryFullPath(path);
			}
		}

		var context = project.templateContext;

		context.WIN_FLASHBACKGROUND = project.window.background != null ? StringTools.hex(project.window.background, 6) : "";
		context.OUTPUT_DIR = npm ? Path.tryFullPath(targetDirectory) : targetDirectory;
		context.OUTPUT_FILE = outputFile;

		if (project.targetFlags.exists("webgl"))
		{
			context.CPP_DIR = targetDirectory + "/obj";
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

		context.linkedLibraries = [];

		for (dependency in project.dependencies)
		{
			if (!dependency.embed || npm)
			{
				if (StringTools.endsWith(dependency.name, ".js"))
				{
					context.linkedLibraries.push(dependency.name);
				}
				else if (StringTools.endsWith(dependency.path, ".js") && FileSystem.exists(dependency.path))
				{
					var name = Path.withoutDirectory(dependency.path);

					context.linkedLibraries.push("./" + dependencyPath + "/" + name);
					copyIfNewer(dependency.path, Path.combine(destination, Path.combine(dependencyPath, name)));
				}
			}
		}

		var createdDirectories = new Map<String, Bool>();

		for (asset in project.assets)
		{
			var path = Path.combine(destination, asset.targetPath);

			if (asset.type != AssetType.TEMPLATE)
			{
				var dir:String = Path.directory(path);

				if (!createdDirectories.exists(dir))
				{
					System.mkdir(dir);

					createdDirectories.set(dir, true);
				}

				if (asset.type != AssetType.FONT)
				{
					AssetHelper.copyAssetIfNewer(asset, path);
				}
				else
				{
					System.copyIfNewer(asset.sourcePath, path);
				}
			}
		}

		// For some reason it seems to crash in here if the shutdown runs, should be figured out later but it shouldn't cause any issues for now ig
		// Font.shutdown();

		ProjectHelper.recursiveSmartCopyTemplate(project, "html5/template", destination, context);

		if (project.app.main != null)
		{
			ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
			ProjectHelper.recursiveSmartCopyTemplate(project, "html5/haxe", targetDirectory + "/haxe", context, true, false);
			ProjectHelper.recursiveSmartCopyTemplate(project, "html5/hxml", targetDirectory + "/haxe", context);
		}

		if (npm)
		{
			ProjectHelper.recursiveSmartCopyTemplate(project, "html5/npm", targetDirectory + "/bin", context);
			if (!FileSystem.exists(targetDirectory + "/bin/node_modules"))
			{
				System.runCommand(targetDirectory + "/bin", "npm", ["install", "-s"]);
			}
		}

		if (targetFlags.exists("electron"))
		{
			ProjectHelper.recursiveSmartCopyTemplate(project, "electron/template", destination, context);

			if (project.app.main != null)
			{
				ProjectHelper.recursiveSmartCopyTemplate(project, "electron/haxe", targetDirectory + "/haxe", context, true, false);
				ProjectHelper.recursiveSmartCopyTemplate(project, "electron/hxml", targetDirectory + "/haxe", context);
			}
		}

		for (asset in project.assets)
		{
			var path = Path.combine(destination, asset.targetPath);

			if (asset.type == AssetType.TEMPLATE)
			{
				System.mkdir(Path.directory(path));
				AssetHelper.copyAsset(asset, path, context);
			}
		}
	}

	public override function watch():Void {}

	public override function install():Void {}

	public override function rebuild():Void {}

	public override function trace():Void {}

	public override function uninstall():Void {}
}
