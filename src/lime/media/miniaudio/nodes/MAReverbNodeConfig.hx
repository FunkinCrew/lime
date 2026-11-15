package lime.media.miniaudio.nodes;

#if (!lime_doc_gen || lime_miniaudio)
class MAReverbNodeConfig
{
	public static function init(channels:Int, sampleRate:Int):MAReverbNodeConfig
	{
		final config:MAReverbNodeConfig = new MAReverbNodeConfig();
		config.channels = channels;
		config.sampleRate = sampleRate;
		return config;
	}

	public var channels:Int;
	public var sampleRate:Int;
	public var roomSize:Float;
	public var damping:Float;
	public var width:Float;
	public var wetVolume:Float;
	public var dryVolume:Float;
	public var mode:Float;

	public function new():Void
	{
		channels = 0;
		sampleRate = 0;
		roomSize = 0.5;
		damping = 0.25;
		width = 1;
		wetVolume = 1.0 / 3.0;
		dryVolume = 0;
		mode = 0;
	}

	public function toDynamicObject():Dynamic
	{
		return {
			channels: channels,
			sampleRate: sampleRate,
			roomSize: roomSize,
			damping: damping,
			width: width,
			wetVolume: wetVolume,
			dryVolume: dryVolume,
			mode: mode
		}
	}
}
#end
