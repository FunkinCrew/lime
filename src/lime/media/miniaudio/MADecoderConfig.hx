package lime.media.miniaudio;

#if (!lime_doc_gen || lime_miniaudio)
import haxe.DynamicAccess;

class MADecoderConfig
{
	public static function init(outputFormat:MAFormat, outputChannels:Int, outputSampleRate:Int):MADecoderConfig
	{
		final config:MADecoderConfig = new MADecoderConfig();
		config.format = outputFormat;
		config.channels = outputChannels;
		config.sampleRate = outputSampleRate;
		return config;
	}

	public var format:MAFormat;
	public var channels:Int;
	public var sampleRate:Int;

	public function new():Void
	{
		format = UNKNOWN;
		channels = 0;
		sampleRate = 0;
	}

	public function toDynamicObject():Dynamic
	{
		final obj:DynamicAccess<Dynamic> = {};
		obj.set('format', format);
		obj.set('channels', channels);
		obj.set('sampleRate', sampleRate);
		return obj;
	}
}
#end
