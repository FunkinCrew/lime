package;

import haxe.io.Eof;

import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.StringTools;
import hxp.System;
import hxp.Version;

import lime.tools.CLIHelper;
import lime.tools.ConfigHelper;
import lime.tools.HXProject;

import sys.FileSystem;
import sys.io.File;

class PlatformSetup
{
	private static var appleXcodeURL = "https://developer.apple.com/xcode/download/";
	private static var linuxAptPackages = "gcc-multilib g++-multilib";
	private static var linuxUbuntuSaucyPackages = "gcc-multilib g++-multilib libxext-dev";
	private static var linuxYumPackages = "gcc gcc-c++";
	private static var linuxDnfPackages = "gcc gcc-c++";
	private static var linuxEquoPackages = "media-libs/mesa sys-devel/gcc";
	private static var linuxEmergePackages = "media-libs/mesa sys-devel/gcc";
	private static var linuxPacman32Packages = "multilib-devel mesa mesa-libgl glu";
	private static var linuxPacman64Packages = "multilib-devel lib32-mesa lib32-mesa-libgl lib32-glu";
	private static var visualStudioURL = "https://www.visualstudio.com/downloads/";
	private static var triedSudo:Bool = false;
	private static var userDefines:Map<String, Dynamic>;
	private static var targetFlags:Map<String, Dynamic>;
	private static var setupHaxelibs = new Map<String, Bool>();

	public static function getDefineValue(name:String, description:String):Void
	{
		var value = ConfigHelper.getConfigValue(name);

		if (value == null && Sys.getEnv(name) != null)
		{
			value = Sys.getEnv(name);
		}

		var inputValue = unescapePath(CLIHelper.param(Log.accentColor + description + "\x1b[0m \x1b[37;3m[" + (value != null ? value : "") + "]\x1b[0m"));

		if (inputValue != "" && inputValue != value)
		{
			ConfigHelper.writeConfigValue(name, inputValue);
		}
		else if (inputValue == Sys.getEnv(inputValue))
		{
			ConfigHelper.removeConfigValue(name);
		}
	}

	public static function installHaxelib(haxelib:Haxelib):Void
	{
		var name = haxelib.name;
		var version = haxelib.version;

		if (version != null && version.indexOf("*") > -1)
		{
			var regexp = new EReg("^.+[0-9]+-[0-9]+-[0-9]+ +[0-9]+:[0-9]+:[0-9]+ +([a-z0-9.-]+) +", "gi");
			var output = Haxelib.runProcess("", ["info", haxelib.name]);
			var lines = output.split("\n");

			var versions = new Array<Version>();
			var ver:Version;

			for (line in lines)
			{
				if (regexp.match(line))
				{
					try
					{
						ver = regexp.matched(1);
						versions.push(ver);
					}
					catch (e:Dynamic) {}
				}
			}

			var match = Haxelib.findMatch(haxelib, versions);

			if (match != null)
			{
				version = match;
			}
			else
			{
				Log.error("Could not find version \"" + haxelib.version + "\" for haxelib \"" + haxelib.name + "\"");
			}
		}

		var args = ["install", name];

		if (version != null && version != "" && version.indexOf("*") == -1)
		{
			args.push(version);
		}

		Haxelib.runCommand("", args);
	}

	private static function link(dir:String, file:String, dest:String):Void
	{
		Sys.command("rm -rf " + dest + "/" + file);
		Sys.command("ln -s " + "/usr/lib" + "/" + dir + "/" + file + " " + dest + "/" + file);
	}

	private static function openURL(url:String):Void
	{
		if (System.hostPlatform == WINDOWS)
		{
			Sys.command("explorer", [url]);
		}
		else if (System.hostPlatform == LINUX)
		{
			System.runCommand("", "xdg-open", [url], false);
		}
		else
		{
			System.runCommand("", "open", [url], false);
		}
	}

	public static function run(target:String = "", userDefines:Map<String, Dynamic> = null, targetFlags:Map<String, Dynamic> = null)
	{
		PlatformSetup.userDefines = userDefines;
		PlatformSetup.targetFlags = targetFlags;

		try
		{
			if (target == "cpp")
			{
				switch (System.hostPlatform)
				{
					case WINDOWS:
						target = "windows";
					case MAC:
						target = "mac";
					case LINUX:
						target = "linux";
					default:
				}
			}

			switch (target)
			{
				case "android":
					setupAndroid();

				case "html5":
					Log.println("\x1b[0;3mNo additional configuration is required.\x1b[0m");

				case "ios", "iphoneos", "iphonesim":
					if (System.hostPlatform == MAC)
					{
						setupIOS();
					}

				case "linux":
					if (System.hostPlatform == LINUX)
					{
						setupLinux();
					}

				case "mac", "macos":
					if (System.hostPlatform == MAC)
					{
						setupMac();
					}

				case "electron":
					setupElectron();

				case "windows":
					if (targetFlags.exists("mingw"))
					{
						setupMinGW();
					}
					else if (System.hostPlatform == WINDOWS)
					{
						setupWindows();
					}

				case "lime":
					setupLime();

				case "openfl":
					setupOpenFL();

				case "":
					switch (CommandLineTools.defaultLibrary)
					{
						case "lime": setupLime();
						case "openfl": setupOpenFL();
						default: setupHaxelib(new Haxelib(CommandLineTools.defaultLibrary));
					}

				default:
					setupHaxelib(new Haxelib(target));
			}
		}
		catch (e:Eof) {}
	}

	public static function setupAndroid():Void
	{
		Log.println("\x1b[1mIn order to build applications for Android, you must have recent");
		Log.println("versions of the Android SDK, Android NDK and Java JDK installed.");
		Log.println("");
		Log.println("You must also install the Android SDK Platform-tools and API 30 using");
		Log.println("the SDK manager from Android Studio.\x1b[0m");
		Log.println("");

		getDefineValue("ANDROID_SDK", "Absolute path to Android SDK");
		getDefineValue("ANDROID_NDK_ROOT", "Absolute path to Android NDK");

		if (System.hostPlatform != MAC)
		{
			getDefineValue("JAVA_HOME", "Absolute path to Java JDK");
		}

		if (ConfigHelper.getConfigValue("ANDROID_SETUP") == null)
		{
			ConfigHelper.writeConfigValue("ANDROID_SETUP", "true");
		}

		Log.println("");
		Log.println("Setup complete.");
	}

	public static function setupElectron():Void
	{
		Log.println("\x1b[1mIn order to run Electron applications, you must download");
		Log.println("and extract the Electron runtime on your system.");
		Log.println("");

		getDefineValue("ELECTRON_PATH", "Absolute path to Electron runtime");

		Log.println("");
		Haxelib.runCommand("", ["install", "electron"], true, true);

		Log.println("");
		Log.println("Setup complete.");
	}

	public static function setupHaxelib(haxelib:Haxelib, dependency:Bool = false):Void
	{
		setupHaxelibs.set(haxelib.name, true);

		var defines = new Map<String, Dynamic>();
		defines.set("setup", 1);

		var basePath = Haxelib.runProcess("", ["config"]);
		if (basePath != null)
		{
			basePath = StringTools.trim(basePath.split("\n")[0]);
		}
		var lib = Haxelib.getPath(haxelib, false, true);
		if (lib != null && !StringTools.startsWith(Path.standardize(lib), Path.standardize(basePath)))
		{
			defines.set("dev", 1);
		}

		var project = HXProject.fromHaxelib(haxelib, defines, true);

		if (project != null && project.haxelibs.length > 0)
		{
			for (lib in project.haxelibs)
			{
				if (setupHaxelibs.exists(lib.name))
					continue;

				var path = Haxelib.getPath(lib, false, true);

				if (path == null || path == "" || (lib.version != null && lib.version != ""))
				{
					if (defines.exists("dev"))
					{
						Log.error("Could not find dependency \"" + lib.name + "\" for library \"" + haxelib.name + "\"");
					}

					installHaxelib(lib);
				}
				else
					/*if (userDefines.exists ("upgrade"))*/
				{
					updateHaxelib(lib);
				}

				setupHaxelib(lib, true);
			}
		}
		else if (!dependency)
		{
			// Log.warn ("No setup is required for " + haxelib.name + ", or it is not a valid target");
		}
	}

	public static function setupIOS():Void
	{
		Log.println("\x1b[1mIn order to build applications for iOS, you must have");
		Log.println("Xcode installed. Xcode is available from Apple as a free download.\x1b[0m");
		Log.println("");
		Log.println("\x1b[0;3mNo additional configuration is required.\x1b[0m");
		Log.println("");

		var answer = CLIHelper.ask("Would you like to visit the download page now?");

		if (answer == YES || answer == ALWAYS)
		{
			System.openURL(appleXcodeURL);
		}
	}

	public static function setupLime():Void
	{
		if (!targetFlags.exists("alias") && !targetFlags.exists("cli"))
		{
			setupHaxelib(new Haxelib("lime"));
		}

		if (targetFlags.exists("noalias"))
		{
			return;
		}

		var haxePathEnv = Sys.getEnv("HAXEPATH");
		var haxePath = haxePathEnv;

		if (System.hostPlatform == WINDOWS)
		{
			var usingDefaultHaxePath = false;
			if (haxePath == null || haxePath == "")
			{
				usingDefaultHaxePath = true;
				haxePath = "C:\\HaxeToolkit\\haxe\\";
			}

			var copyFailure = false;
			var batDestPath = haxePath + "\\lime.bat";
			try
			{
				// To remove the old lime behaviour
				if (FileSystem.exists(haxePath + "\\lime.exe"))
				{
					FileSystem.deleteFile(haxePath + "\\lime.exe");
				}

				File.copy(Haxelib.getPath(new Haxelib("lime")) + "\\templates\\\\bin\\lime.bat", batDestPath);
			}
			catch (e:Dynamic)
			{
				copyFailure = true;
				if (Log.verbose)
				{
					Log.warn("Failed to copy lime.bat alias to destination: " + batDestPath);
				}
			}
			if (Log.verbose && copyFailure && usingDefaultHaxePath && !FileSystem.exists(haxePath))
			{
				Log.warn("Did you install Haxe to a custom location? Set the HAXEPATH environment variable, and run Lime setup again.");
			}
		}
		else
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "/usr/lib/haxe";
			}

			var installedCommand = false;
			var answer = YES;

			if (!(targetFlags.exists("alias") || targetFlags.exists("cli")))
			{
				if (targetFlags.exists("y"))
				{
					Sys.println("Do you want to install the \"lime\" command? [y/n/a] y");
				}
				else
				{
					answer = CLIHelper.ask("Do you want to install the \"lime\" command?");
				}
			}

			if (answer == YES || answer == ALWAYS)
			{
				if (System.hostPlatform == MAC)
				{
					var aliasDestPath = "/usr/local/bin/lime";
					try
					{
						System.runCommand("", "cp", [
							"-f",
							Haxelib.getPath(new Haxelib("lime")) + "/templates/bin/lime.sh",
							aliasDestPath
						], false);
						System.runCommand("", "chmod", ["755", aliasDestPath], false);
						installedCommand = true;
					}
					catch (e:Dynamic)
					{
						if (Log.verbose)
						{
							Log.warn("Failed to copy Lime alias to destination: " + aliasDestPath);
						}
					}
				}
				else
				{
					var aliasDestPath = "/usr/local/bin/lime";
					try
					{
						System.runCommand("", "sudo", [
							"cp",
							"-f",
							Haxelib.getPath(new Haxelib("lime")) + "/templates/bin/lime.sh",
							aliasDestPath
						], false);
						System.runCommand("", "sudo", ["chmod", "755", aliasDestPath], false);
						installedCommand = true;
					}
					catch (e:Dynamic)
					{
						if (Log.verbose)
						{
							Log.warn("Failed to copy Lime alias to destination: " + aliasDestPath);
						}
					}
				}
			}

			if (!installedCommand)
			{
				Sys.println("");
				Sys.println("To finish setup, we recommend you either...");
				Sys.println("");
				Sys.println(" a) Manually add an alias called \"lime\" to run \"haxelib run lime\"");
				Sys.println(" b) Run the following commands:");
				Sys.println("");
				Sys.println("sudo cp \"" + Path.combine(Haxelib.getPath(new Haxelib("lime")), "templates/bin/lime.sh") + "\" /usr/local/bin/lime");
				Sys.println("sudo chmod 755 /usr/local/bin/lime");
				Sys.println("");
			}
		}
	}

	public static function setupLinux():Void
	{
		var whichAptGet = System.runProcess("", "which", ["apt-get"], true, true, true);
		var hasApt = whichAptGet != null && whichAptGet != "";

		if (hasApt)
		{
			// check if this is Ubuntu Saucy 64-bit, which uses different packages.
			var lsbId = System.runProcess("", "lsb_release", ["-si"], true, true, true);
			var lsbRelease = System.runProcess("", "lsb_release", ["-sr"], true, true, true);
			var arch = System.runProcess("", "uname", ["-m"], true, true, true);
			var isSaucy = lsbId == "Ubuntu\n" && lsbRelease >= "13.10\n" && arch == "x86_64\n";

			var packages = isSaucy ? linuxUbuntuSaucyPackages : linuxAptPackages;

			var parameters = ["apt-get", "install"].concat(packages.split(" "));
			System.runCommand("", "sudo", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		var whichYum = System.runProcess("", "which", ["yum"], true, true, true);
		var hasYum = whichYum != null && whichYum != "";

		if (hasYum)
		{
			var parameters = ["yum", "install"].concat(linuxYumPackages.split(" "));
			System.runCommand("", "sudo", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		var whichDnf = System.runProcess("", "which", ["dnf"], true, true, true);
		var hasDnf = whichDnf != null && whichDnf != "";

		if (hasDnf)
		{
			var parameters = ["dnf", "install"].concat(linuxDnfPackages.split(" "));
			System.runCommand("", "sudo", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		var whichEquo = System.runProcess("", "which", ["equo"], true, true, true);
		var hasEquo = whichEquo != null && whichEquo != "";

		if (hasEquo)
		{
			// Sabayon docs recommend not using sudo with equo, and instead using a root login shell
			var parameters = ["-l", "-c", "equo", "i", "-av"].concat(linuxEquoPackages.split(" "));
			System.runCommand("", "su", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		var whichEmerge = System.runProcess("", "which", ["emerge"], true, true, true);
		var hasEmerge = whichEmerge != null && whichEmerge != "";

		if (hasEmerge)
		{
			var parameters = ["emerge", "-av"].concat(linuxEmergePackages.split(" "));
			System.runCommand("", "sudo", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		var whichPacman = System.runProcess("", "which", ["pacman"], true, true, true);
		var hasPacman = whichPacman != null && whichPacman != "";

		if (hasPacman)
		{
			var parameters = ["pacman", "-S", "--needed"];

			if (System.hostArchitecture == X64)
			{
				parameters = parameters.concat(linuxPacman64Packages.split(" "));
			}
			else
			{
				parameters = parameters.concat(linuxPacman32Packages.split(" "));
			}

			System.runCommand("", "sudo", parameters, false);

			Log.println("");
			Log.println("Setup complete.");
			return;
		}

		Log.println("Unable to find a supported package manager on your Linux distribution.");
		Log.println("Currently apt-get, yum, dnf, equo, emerge, and pacman are supported.");

		Sys.exit(1);
	}

	public static function setupMac():Void
	{
		Log.println("\x1b[1mIn order to build native executables for macOS, you must have");
		Log.println("Xcode installed. Xcode is available from Apple as a free download.\x1b[0m");
		Log.println("");
		Log.println("\x1b[0;3mNo additional configuration is required.\x1b[0m");
		Log.println("");

		var answer = CLIHelper.ask("Would you like to visit the download page now?");

		if (answer == YES || answer == ALWAYS)
		{
			System.openURL(appleXcodeURL);
		}
	}

	public static function setupOpenFL():Void
	{
		if (!targetFlags.exists("alias") && !targetFlags.exists("cli"))
		{
			setupHaxelib(new Haxelib("openfl"));
		}

		if (targetFlags.exists("noalias"))
		{
			return;
		}

		var haxePath = Sys.getEnv("HAXEPATH");
		var project:HXProject = null;

		try
		{
			project = HXProject.fromHaxelib(new Haxelib("openfl"));
		}
		catch (e:Dynamic) {}

		if (System.hostPlatform == WINDOWS)
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "C:\\HaxeToolkit\\haxe\\";
			}

			try
			{
				// To remove the old lime behaviour
				if (FileSystem.exists(haxePath + "\\lime.exe"))
				{
					FileSystem.deleteFile(haxePath + "\\lime.exe");
				}

				File.copy(Haxelib.getPath(new Haxelib("lime")) + "\\templates\\\\bin\\lime.bat", haxePath + "\\lime.bat");
			}
			catch (e:Dynamic) {}

			try
			{
				// To remove the old lime behaviour
				if (FileSystem.exists(haxePath + "\\openfl.exe"))
				{
					FileSystem.deleteFile(haxePath + "\\openfl.exe");
				}

				System.copyFileTemplate(project.templatePaths, "bin/openfl.bat", haxePath + "\\openfl.bat");
			}
			catch (e:Dynamic) {}
		}
		else
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "/usr/lib/haxe";
			}

			var installedCommand = false;
			var answer = YES;

			if (!(targetFlags.exists("alias") || targetFlags.exists("cli")))
			{
				if (targetFlags.exists("y"))
				{
					Sys.println("Do you want to install the \"openfl\" command? [y/n/a] y");
				}
				else
				{
					answer = CLIHelper.ask("Do you want to install the \"openfl\" command?");
				}
			}

			if (answer == YES || answer == ALWAYS)
			{
				if (System.hostPlatform == MAC)
				{
					try
					{
						System.runCommand("", "cp", [
							"-f",
							Haxelib.getPath(new Haxelib("lime")) + "/templates/bin/lime.sh",
							"/usr/local/bin/lime"
						], false);
						System.runCommand("", "chmod", ["755", "/usr/local/bin/lime"], false);
						System.runCommand("", "cp", [
							"-f",
							System.findTemplate(project.templatePaths, "bin/openfl.sh"),
							"/usr/local/bin/openfl"
						], false);
						System.runCommand("", "chmod", ["755", "/usr/local/bin/openfl"], false);
						installedCommand = true;
					}
					catch (e:Dynamic) {}
				}
				else
				{
					try
					{
						System.runCommand("", "sudo", [
							"cp",
							"-f",
							Haxelib.getPath(new Haxelib("lime")) + "/templates/bin/lime.sh",
							"/usr/local/bin/lime"
						], false);
						System.runCommand("", "sudo", ["chmod", "755", "/usr/local/bin/lime"], false);
						System.runCommand("", "sudo", [
							"cp",
							"-f",
							System.findTemplate(project.templatePaths, "bin/openfl.sh"),
							"/usr/local/bin/openfl"
						], false);
						System.runCommand("", "sudo", ["chmod", "755", "/usr/local/bin/openfl"], false);
						installedCommand = true;
					}
					catch (e:Dynamic) {}
				}
			}

			if (!installedCommand)
			{
				Sys.println("");
				Sys.println("To finish setup, we recommend you either...");
				Sys.println("");
				Sys.println(" a) Manually add an alias called \"openfl\" to run \"haxelib run openfl\"");
				Sys.println(" b) Run the following commands:");
				Sys.println("");
				Sys.println("sudo cp \"" + Path.combine(Haxelib.getPath(new Haxelib("lime")), "templates/bin/lime.sh") + "\" /usr/local/bin/lime");
				Sys.println("sudo chmod 755 /usr/local/bin/lime");
				Sys.println("sudo cp \"" + System.findTemplate(project.templatePaths, "bin/openfl.sh") + "\" /usr/local/bin/openfl");
				Sys.println("sudo chmod 755 /usr/local/bin/openfl");
				Sys.println("");
			}
		}
	}

	public static function setupWindows():Void
	{
		Log.println("\x1b[1mIn order to build native executables for Windows, you must have a");
		Log.println("Visual Studio C++ compiler with \"Windows Desktop\" (Win32) support");
		Log.println("installed. We recommend using Visual Studio Community, which is");
		Log.println("available as a free download from Microsoft.\x1b[0m");
		Log.println("");
		Log.println("\x1b[0;3mNo additional configuration is required.\x1b[0m");
		Log.println("");

		var answer = CLIHelper.ask("Would you like to visit the download page now?");

		if (answer == YES || answer == ALWAYS)
		{
			System.openURL(visualStudioURL);
		}
	}

	public static function setupMinGW():Void
	{
		Log.println("\x1b[1mIn order to compile Windows applications with MinGW, you must download");
		Log.println("and extract the MinGW toolchain on your system.");
		Log.println("");

		getDefineValue("MINGW_ROOT", "Absolute path to MinGW");

		Log.println("");

		Log.println("\x1b[1mWINE_PATH\x1b[0m");
		Log.println("Absolute path to the Wine executable.");
		Log.println("This is used to run the Windows application for testing.");
		Log.println("");

		getDefineValue("WINE_PATH", "Absolute path to Wine");

		Log.println("");

		Log.println("\x1b[1mCROSSOVER_BOTTLE\x1b[0m");
		Log.println("Name or Absolute Path of the CrossOver bottle used to run the Windows application for testing.");
		Log.println("This can be left empty if you are not using CrossOver.");
		Log.println("");

		getDefineValue("CROSSOVER_BOTTLE", "CrossOver bottle name");

		Log.println("");
		Log.println("Setup complete.");
	}

	private static function throwPermissionsError()
	{
		if (System.hostPlatform == WINDOWS)
		{
			Log.println("Unable to access directory. Perhaps you need to run \"setup\" with administrative privileges?");
		}
		else
		{
			Log.println("Unable to access directory. Perhaps you should run \"setup\" again using \"sudo\"");
		}

		Sys.exit(1);
	}

	private static function unescapePath(path:String):String
	{
		if (path == null)
		{
			path = "";
		}

		path = StringTools.replace(path, "\\ ", " ");

		if (System.hostPlatform != WINDOWS && StringTools.startsWith(path, "~/"))
		{
			path = Sys.getEnv("HOME") + "/" + path.substr(2);
		}

		return path;
	}

	public static function updateHaxelib(haxelib:Haxelib):Void
	{
		var basePath = Haxelib.runProcess("", ["config"]);

		if (basePath != null)
		{
			basePath = StringTools.trim(basePath.split("\n")[0]);
		}

		var lib = Haxelib.getPath(haxelib, false, true);

		if (StringTools.startsWith(Path.standardize(lib), Path.standardize(basePath)))
		{
			Haxelib.runCommand("", ["update", haxelib.name]);
		}
		else
		{
			var git = Path.combine(lib, ".git");

			if (FileSystem.exists(git))
			{
				Log.info(Log.accentColor + "Updating \"" + haxelib.name + "\"" + Log.resetColor);

				if (System.hostPlatform == WINDOWS)
				{
					var path = Sys.getEnv("PATH");

					if (path.indexOf("Git") == -1)
					{
						Sys.putEnv("PATH", "C:\\Program Files (x86)\\Git\\bin;" + path);
					}
				}

				System.runCommand(lib, "git", ["pull"]);
				System.runCommand(lib, "git", ["submodule", "init"]);
				System.runCommand(lib, "git", ["submodule", "update"]);
			}
		}
	}
}
