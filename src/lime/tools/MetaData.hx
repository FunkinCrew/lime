package lime.tools;

@:forward
abstract MetaData({
	@:optional var buildNumber:String;
	@:optional var company:String;
	@:optional var description:String;
	@:optional var packageName:String;
	@:optional var title:String;
	@:optional var version:String;
	@:optional var copyrightYears:String;
}) from Dynamic
{
	@:noCompletion
	public static var expectedFields:MetaData = {
		buildNumber: "",
		company: "",
		description: "",
		packageName: "",
		title: "",
		version: "",
		copyrightYears: ""
	};
}
