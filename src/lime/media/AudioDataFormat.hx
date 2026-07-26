package lime.media;

enum abstract AudioDataFormat(Int)
{
	var UNKNOWN = -1;
	var U8 = 0;
	var S16 = 1;
	var S24 = 2;
	var S32 = 3;
	var F32 = 4;

	public var byteDepth(get, never):Int;

	private function get_byteDepth():Int
	{
		return switch (cast this : AudioDataFormat)
		{
			case U8: 1;
			case S16: 2;
			case S24: 3;
			case S32, F32: 4;
			default: 0;
		}
	}
}
