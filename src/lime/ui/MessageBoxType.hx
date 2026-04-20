package lime.ui;

/**
	An enum containing message box semantic types.
**/
enum abstract MessageBoxType(Int) from Int to Int
{
	/**
		Error dialog.
	**/
	public var ERROR = 0;

	/**
		Warning dialog.
	**/
	public var WARNING = 1;

	/**
		Informational dialog.
	**/
	public var INFORMATION = 2;
}