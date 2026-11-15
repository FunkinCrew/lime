package lime.media.miniaudio.nodes;

#if (!lime_doc_gen || lime_miniaudio)
class MAVocoderNodeConfig
{
	public static function init(channels:Int, sampleRate:Int):MAVocoderNodeConfig
	{
		final config:MAVocoderNodeConfig = new MAVocoderNodeConfig();
		config.channels = channels;
		config.sampleRate = sampleRate;
		return config;
	}

	public var channels:Int;
	public var sampleRate:Int;
	public var bands:Int;
	public var filtersPerBand:Int;

	public function new():Void
	{
		channels = 0;
		sampleRate = 0;
		bands = 16;
		filtersPerBand = 6;
	}

	public function toDynamicObject():Dynamic
	{
		return {
			channels: channels,
			sampleRate: sampleRate,
			bands: bands,
			filtersPerBand: filtersPerBand
		}
	}
}
#end
