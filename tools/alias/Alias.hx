package;

class Alias
{
	public static function main():Void
	{
		Sys.exit(Sys.command("haxelib", ["run", 'lime'].concat(Sys.args())));
	}
}
