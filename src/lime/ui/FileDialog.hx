package lime.ui;

import haxe.io.Path;
import lime.system.CFFI;
import lime._internal.backend.native.NativeCFFI;

/**
	File dialog for opening files, saving files, and selecting directories.

	Example usage:
	```haxe
		FileDialog.openFile(Application.current.window, (files, filter) -> {
			if (files.length > 0) {
				trace('Selected file: ' + files[0]);
				if (filter != null)
					trace('Filter used: ' + filter.name);
			}
		}, [
			new FileDialogFilter("PNG images", "png"),
			new FileDialogFilter("All files", "*")
		], Sys.getCwd());
	```
**/
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.ui.Window)
class FileDialog
{
	/**
		Opens a directory selection dialog. If successful, `callback` will be called with the selected directory paths.
		@param window        The parent window for the dialog.
		@param callback      Called with the list of selected directories when the dialog is confirmed, or an empty array if the user cancelled.
		@param defaultPath   The default folder or file to start the dialog at. Defaults to `Sys.getCwd()`.
		@param allowMultiple Whether the user can select multiple directories.
	**/
	public static function openDirectory(window:Window = null, callback:Array<String>->Void = null, defaultPath:String = null, allowMultiple:Bool = false):Void
	{
		#if (lime_cffi && !macro)
		if (defaultPath == null)
		{
			defaultPath = Sys.getCwd();
		}

		#if hl
		var dialogCallback = function(list:hl.NativeArray<hl.Bytes>):Void
		{
			if (callback != null)
			{
				callback([for (i in 0...list.length) CFFI.stringValue(list[i])]);
			}
		}
		#else
		var dialogCallback = function(list:Array<String>):Void
		{
			if (callback != null)
			{
				callback(list);
			}
		}
		#end

		NativeCFFI.lime_file_dialog_open_directory(window.__backend.handle, dialogCallback, defaultPath, allowMultiple);
		#end
	}

	/**
		Opens a file selection dialog. If successful, `callback` will be called with the selected file paths and the filter that was active when the user confirmed.
		@param window        The parent window for the dialog.
		@param callback      Called with the list of selected files and the active `FileDialogFilter` when the dialog is confirmed, or an empty array and `null` if the user cancelled.
		@param filters       A list of `FileDialogFilter` to show in the dialog's filter dropdown. If `null`, no filter is applied.
		@param defaultPath   The default folder or file to start the dialog at. Defaults to `Sys.getCwd()`.
		@param allowMultiple Whether the user can select multiple files.
	**/
	public static function openFile(window:Window, callback:Array<String>->FileDialogFilter->Void = null, filters:Array<FileDialogFilter> = null,
			defaultPath:String = null, ?allowMultiple:Bool = false):Void
	{
		#if (lime_cffi && !macro)
		if (defaultPath == null)
		{
			defaultPath = Sys.getCwd();
		}

		var count = filters != null ? filters.length : 0;

		#if hl
		var names = new hl.NativeArray<String>(count);
		var patterns = new hl.NativeArray<String>(count);

		for (i in 0...count)
		{
			names[i] = filters[i].name;
			patterns[i] = filters[i].pattern;
		}

		var dialogCallback = function(list:hl.NativeArray<hl.Bytes>, filterIndex:Int):Void
		{
			if (callback != null)
			{
				callback([for (i in 0...list.length) CFFI.stringValue(list[i])], filters != null ? filters[filterIndex] : null);
			}
		}
		#else
		var names = filters != null ? filters.map(f -> f.name) : [];
		var patterns = filters != null ? filters.map(f -> f.pattern) : [];

		var dialogCallback = function(filelist:Array<String>, filterIndex:Int):Void
		{
			if (callback != null)
			{
				callback(filelist, filters != null ? filters[filterIndex] : null);
			}
		}
		#end

		NativeCFFI.lime_file_dialog_open_file(window.__backend.handle, dialogCallback, names, patterns, count, defaultPath, allowMultiple);
		#end
	}

	/**
		Opens a save file dialog. If successful, `callback` will be called with the selected path and the filter that was active when the user confirmed.
		@param window          The parent window for the dialog.
		@param callback        Called with the selected save path and the active `FileDialogFilter` when the dialog is confirmed, or `null` if the user cancelled.
		@param filters         A list of `FileDialogFilter` to show in the dialog's filter dropdown. If `null`, no filter is applied.
		@param defaultPath The default folder or file to start the dialog at. Defaults to `Sys.getCwd()`.
	**/
	public static function saveFile(window:Window = null, callback:String->FileDialogFilter->Void = null, filters:Array<FileDialogFilter> = null,
			defaultPath:String = null):Void
	{
		#if (lime_cffi && !macro)
		if (defaultPath == null)
		{
			defaultPath = Sys.getCwd();
		}

		var count = filters != null ? filters.length : 0;

		#if hl
		var names = new hl.NativeArray<String>(count);
		var patterns = new hl.NativeArray<String>(count);

		for (i in 0...count)
		{
			names[i] = filters[i].name;
			patterns[i] = filters[i].pattern;
		}

		var dialogCallback = function(filename:hl.Bytes, filterIndex:Int):Void
		{
			if (callback != null)
			{
				var filter = filters != null && filterIndex >= 0 ? filters[filterIndex] : null;

				callback(__applySaveFilterExtension(filename != null ? CFFI.stringValue(filename) : null, filter), filter);
			}
		}
		#else
		var names = filters != null ? filters.map(f -> f.name) : [];
		var patterns = filters != null ? filters.map(f -> f.pattern) : [];

		var dialogCallback = function(filename:String, filterIndex:Int):Void
		{
			if (callback != null)
			{
				var filter = filters != null && filterIndex >= 0 ? filters[filterIndex] : null;

				callback(__applySaveFilterExtension(filename, filter), filter);
			}
		}
		#end

		NativeCFFI.lime_file_dialog_save_file(window.__backend.handle, dialogCallback, names, patterns, count, defaultPath);
		#end
	}

	@:noCompletion
	private static function __applySaveFilterExtension(path:String, filter:FileDialogFilter):String
	{
		if (path == null)
		{
			return null;
		}

		if (!Path.isAbsolute(path)
			|| filter == null
			|| (filter.pattern == null || filter.pattern.length == 0)
			|| (filter.pattern != null && filter.pattern == '*'))
		{
			return path;
		}

		var extension:String = Path.extension(path);
		var patterns:Array<String> = filter.pattern.split(';');

		var extensionLower:String = extension.toLowerCase();
		var patternsLower:Array<String> = patterns.map(f -> f.toLowerCase());

		if (patterns.length == 1 || extension.length == 0 || !patternsLower.contains(extensionLower))
		{
			path = Path.withExtension(path, patterns[0]);
		}

		return path;
	}
}
