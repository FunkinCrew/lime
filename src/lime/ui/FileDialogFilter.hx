package lime.ui;

/**
	Represents a file filter for use in file dialogs, consisting of a display name and a pattern.
	Patterns use semicolons to separate multiple extensions, for example `"png;jpg;jpeg"`.
**/
@:structInit
class FileDialogFilter
{
	/**
		The display name of the filter, shown in the dialog's filter dropdown.
		For example, `"PNG images"`.
	**/
	public var name:String;

	/**
		The pattern used to match files.
		Use semicolons to separate multiple extensions.
		For example, `"png;jpg;jpeg"` or `"*"` for all files.
	**/
	public var pattern:String;

	/**
		Creates a new `FileDialogFilter` with the given display name and pattern.
		@param name    The display name of the filter, shown in the dialog's filter dropdown.
		@param pattern The pattern used to match files. Use semicolons to separate multiple extensions, for example `"png;jpg;jpeg"`.
	**/
	public function new(name:String, pattern:String)
	{
		this.name = name;
		this.pattern = pattern;
	}
}
