package lime.media.miniaudio.nodes;

#if (!lime_doc_gen || lime_miniaudio)
class MALtrimNodeConfig
{
	public static function init(channels:Int, threshold:Float):MALtrimNodeConfig
	{
		final config:MALtrimNodeConfig = new MALtrimNodeConfig();
		config.channels = channels;
		config.threshold = threshold;
		return config;
	}

	public var channels:Int;
	public var threshold:Float;

	public function new():Void
	{
		channels = 0;
		threshold = 0;
	}

	public function toDynamicObject():Dynamic
	{
		return {
			channels: channels,
			threshold: threshold
		}
	}
}
#end
