package lime.system;

#if (!lime_doc_gen || lime_cffi)
import haxe.io.Path;
import lime._internal.macros.CFFIMacro;
#if (sys && !macro)
import sys.io.Process;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class CFFI
{
	@:noCompletion private static var __moduleNames:Map<String, String> = null;
	#if neko
	private static var __loadedNekoAPI:Bool;
	#end
	public static var available:Bool;
	public static var enabled:Bool;

	private static function __init__():Void
	{
		#if lime_cffi
		available = true;
		enabled = #if disable_cffi false; #else true; #end
		#else
		available = false;
		enabled = false;
		#end
	}

	#if macro
	public static function build(defaultLibrary:String = "lime")
	{
		return CFFIMacro.build(defaultLibrary);
	}
	#end

	/**
	 * Tries to load a native CFFI primitive on compatible platforms
	 * @param	library	The name of the native library (such as "lime")
	 * @param	method	The exported primitive method name
	 * @param	args	The number of arguments
	 * @param	lazy	Whether to load the symbol immediately, or to allow lazy loading
	 * @return	The loaded method
	 */
	public static function load(library:String, method:String, args:Int = 0, lazy:Bool = false):Dynamic
	{
		#if (disable_cffi || macro || hl)
		var enabled = false;
		#end

		#if optional_cffi
		if (library != "lime" || method != "neko_init")
		{
			lazy = true;
		}
		#end

		if (!enabled)
		{
			return Reflect.makeVarArgs(function(__) return {});
		}

		var result:Dynamic = null;

		#if (!disable_cffi && !macro)
		#if (sys && !html5)
		if (__moduleNames == null) __moduleNames = new Map<String, String>();

		if (lazy)
		{
			__moduleNames.set(library, library);

			try
			{
				#if neko
				result = neko.Lib.loadLazy(library, method, args);
				#elseif cpp
				result = cpp.Lib.loadLazy(library, method, args);
				#end
			}
			catch (e:Dynamic) {}
		}
		else
		{
			#if (cpp && (iphone || webassembly || android || static_link || tvos))
			return cpp.Lib.load(library, method, args);
			#end

			if (__moduleNames.exists(library))
			{
				#if cpp
				return cpp.Lib.load(__moduleNames.get(library), method, args);
				#elseif neko
				#if neko_cffi_trace
				var result:Dynamic = neko.Lib.load(__moduleNames.get(library), method, args);
				if (result == null) return null;

				return Reflect.makeVarArgs(function(args)
				{
					trace("Called " + library + "@" + method);
					return Reflect.callMethod(result, result, args);
				});
				#else
				return neko.Lib.load(__moduleNames.get(library), method, args);
				#end
				#else
				return null;
				#end
			}

			__moduleNames.set(library, library);

			var programPath:String = ".";
			#if sys
			programPath = Path.directory(Sys.programPath());
			#end

			result = __tryLoad(programPath + "/" + library, library, method, args);

			if (result == null)
			{
				result = __tryLoad(programPath + "\\" + library, library, method, args);
			}

			if (result == null)
			{
				result = __tryLoad(library, library, method, args);
			}

			if (result == null)
			{
				var ndllFolder = __findNDLLFolder();

				if (ndllFolder != "")
				{
					result = __tryLoad(ndllFolder + __sysName() + "/" + library, library, method, args);

					if (result == null)
					{
						result = __tryLoad(ndllFolder + __sysName() + "64/" + library, library, method, args);
					}

					if (result == null)
					{
						result = __tryLoad(ndllFolder + __sysName() + "Arm64/" + library, library, method, args);
					}
				}
			}

			__loaderTrace("Result : " + result);
		}

		#if neko
		if (library == "lime" && method != "neko_init")
		{
			__loadNekoAPI(lazy);
		}
		#end
		#end
		#else
		result = function(_, _, _, _, _, _)
		{
			return {};
		};
		#end

		return result;
	}

	public static macro function loadPrime(library:String, method:String, signature:String, lazy:Bool = false):Dynamic
	{
		#if (!display && !macro && cpp && !disable_cffi)
		return cpp.Prime.load(library, method, signature, lazy);
		#else
		var args = signature.length - 1;

		if (args > 5)
		{
			args = -1;
		}

		return {call: CFFI.load(library, method, args, lazy)};
		#end
	}

	@:dox(hide) #if !hl inline #end public static function stringValue(#if hl value:hl.Bytes #else value:String #end):String
	{
		#if hl
		return value != null ? @:privateAccess String.fromUTF8(value) : null;
		#else
		return value;
		#end
	}

	private static function __findNDLLFolder():String
	{
		#if (sys && !macro && !html5)
		var process = new Process("haxelib", ["path", "lime"]);

		try
		{
			while (true)
			{
				var line = StringTools.trim(process.stdout.readLine());

				if (StringTools.startsWith(line, "-L "))
				{
					process.close();
					return Path.addTrailingSlash(line.substr(3));
				}
			}
		}
		catch (e:Dynamic) {}

		process.close();
		#end

		return "";
	}

	private static function __loaderTrace(message:String)
	{
		#if (sys && !html5)
		// #if (haxe_ver < 3.4)
		// var get_env = cpp.Lib.load ("std", "get_env", 1);
		// var debug = (get_env ("OPENFL_LOAD_DEBUG") != null);
		// #else
		var debug = (Sys.getEnv("OPENFL_LOAD_DEBUG") != null);
		// #end

		if (debug)
		{
			Sys.println(message);
		}
		#end
	}

	#if neko
	private static function __loadNekoAPI(lazy:Bool):Void
	{
		if (!__loadedNekoAPI)
		{
			var init:Dynamic = null;
			try
			{
				init = load("lime", "neko_init", 5);
			}
			catch (e:Dynamic)
			{
			}

			if (init != null)
			{
				__loaderTrace("Found nekoapi @ " + __moduleNames.get("lime"));
				init(function(s) return new String(s), function(len:Int)
				{
					var r = [];
					if (len > 0) r[len - 1] = null;
					return r;
				}, null, true, false);

				__loadedNekoAPI = true;
			}
			else if (!lazy)
			{
				var ndllFolder = __findNDLLFolder() + __sysName();
				throw "Could not find lime.ndll. This file is provided with Lime's Haxelib releases, but not via Git. "
					+ "Please copy it from Lime's latest Haxelib release into either "
					+ ndllFolder + " or " + ndllFolder + "64, as appropriate for your system. "
					+ "Advanced users may run `lime rebuild cpp` instead.";
			}
		}
	}
	#end

	private static function __sysName():String
	{
		#if (sys && !html5)
		#if cpp
		var sys_string = cpp.Lib.load("std", "sys_string", 0);
		return sys_string();
		#else
		return Sys.systemName();
		#end
		#else
		return null;
		#end
	}

	private static function __tryLoad(name:String, library:String, func:String, args:Int):Dynamic
	{
		#if sys
		try
		{
			#if cpp
			var result = cpp.Lib.load(name, func, args);
			#elseif neko
			var result = neko.Lib.load(name, func, args);
			#else
			var result = null;
			#end

			if (result != null)
			{
				__loaderTrace("Got result " + name);
				__moduleNames.set(library, name);
				return result;
			}
		}
		catch (e:Dynamic)
		{
			__loaderTrace("Failed to load : " + name);
		}
		#end

		return null;
	}
}
#end
