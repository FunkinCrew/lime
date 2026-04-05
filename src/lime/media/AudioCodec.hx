package lime.media;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AudioCodec(Null<String>) from Null<String> to Null<String>
{
	var WAVE = "WAVE";
	var MPEG = "MPEG";
	var VORBIS = "VORBIS";
	var FLAC = "FLAC";
	var OPUS = "OPUS";

	public static function fromHTML5(value:String):AudioCodec
	{
		if (value == null) return null;
		value = value.toLowerCase();

		if (value.indexOf("opus") != -1) return OPUS;
		else if (value.indexOf("vorbis") != -1) return VORBIS;

		value = StringTools.ltrim(value);
		var idx = value.indexOf(" ");
		if (idx != -1) value = value.substr(0, idx);

		return switch (value)
		{
			case "audio/wav": WAVE;
			case "audio/mp2", "audio/mp3", "audio/mp4", "audio/mpeg": MPEG;
			case "audio/webm": OPUS;
			case "audio/ogg": VORBIS;
			case "audio/flac", "audio/x-flac": FLAC;
			default: null;
		}
	}

	public function toHTML5():String
	{
		return switch (cast this : AudioCodec)
		{
			case WAVE: "audio/wav";
			case MPEG: "audio/mpeg";
			case VORBIS: "audio/ogg";
			case FLAC: "audio/flac";
			case OPUS: "audio/ogg; codecs=\"opus\"";
			default: "audio/null";
		}
	}

	public static function fromFormat(value:String):AudioCodec
	{
		if (value == null) return null;

		return switch (value.toLowerCase())
		{
			case "wav": WAVE;
			case "mp3": MPEG;
			case "ogg": VORBIS;
			case "flac": FLAC;
			case "opus": OPUS;
			default: null;
		}
	}

	public function toFormat():String
	{
		return switch (cast this : AudioCodec)
		{
			case WAVE: "wav";
			case MPEG: "mp3";
			case VORBIS: "ogg";
			case FLAC: "flac";
			case OPUS: "opus";
			default: "dat";
		}
	}
}
