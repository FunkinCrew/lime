package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.DynamicAccess;

class MAAudioRingBufferConfig
{
	public static function init(format:MAFormat, channels:Int, sampleRate:Int, sizeInFrames:Int):MAAudioRingBufferConfig
	{
		final config:MAAudioRingBufferConfig = new MAAudioRingBufferConfig();
		config.format = format;
		config.channels = channels;
		config.sampleRate = sampleRate;
		config.sizeInFrames = sizeInFrames;
		return config;
	}

	public var format:MAFormat;
	public var channels:Int;
	public var sampleRate:Int;
	public var sizeInFrames:Int;

	public function new():Void
	{
		format = UNKNOWN;
		channels = 0;
		sampleRate = 0;
		sizeInFrames = 0;
	}

	public function toDynamicObject():Dynamic
	{
		final obj:DynamicAccess<Dynamic> = {};
		obj.set('format', format);
		obj.set('channels', channels);
		obj.set('sampleRate', sampleRate);
		obj.set('sizeInFrames', sizeInFrames);
		return obj;
	}
}
#end
