package lime.tools;

class AdaptiveIcon
{
	public var path:String;
	public var hasRoundIcon:Bool;

	public function new(path:String, hasRoundIcon:Bool)
	{
		this.path = path;
		this.hasRoundIcon = hasRoundIcon;
	}

	public function clone():AdaptiveIcon
	{
		return new AdaptiveIcon(path, hasRoundIcon);
	}
}
