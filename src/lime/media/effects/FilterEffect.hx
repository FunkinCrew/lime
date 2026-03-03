package lime.media.effects;

import lime.media.AudioEffect;
#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALFilter;
import lime.media.openal.ALSource;
#elseif (js && html5)
import js.html.audio.BiquadFilterNode;
import js.html.audio.BiquadFilterType;
import lime.media.howlerjs.Howler;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
/**
	An audio playback effect that can represent different kinds of filters, tone control devices,
	and graphic equalizers, mainly LOWPASS, HIGHPASS, BANDPASS.

	NOTE: One audio source can only have one FilterEffect.
		Only works in web, and native targets, flash doesn't support this.
**/
class FilterEffect extends AudioEffect
{
	/**
		The type of filter used on this biquad filter.

		`LOWPASS`: Standard second-order resonant lowpass filter with 12dB/octave rolloff.
			Frequencies below the cutoff pass through; frequencies above it are attenuated.

		`HIGHPASS`: Standard second-order resonant highpass filter with 12dB/octave rolloff.
			Frequencies below the cutoff are attenuated; frequencies above it pass through.

		`BANDPASS`: Standard second-order bandpass filter. Frequencies outside the given range of frequencies are attenuated;
			the frequencies inside it pass through.

	**/
	public var type(default, set):FilterEffectType;

	/**
		A variable representing a frequency in the current filtering algorithm measured, in hz; Ranging from 0 to 24000.
	**/
	public var frequency(default, set):Float;

	#if (js && html5)
	@:noCompletion private var __biquadFilter:BiquadFilterNode;
	#end

	public function new(type:FilterEffectType = LOWPASS, frequency:Float = 1000)
	{
		super();

		#if lime_openal
		__alFilter = AL.createFilter();
		if (__alFilter != null && __alAux != null)
		{
			//AL.auxi(__alAux, AL.EFFECTSLOT_EFFECT, __alEffect = AL.createEffect());
		}
		#elseif (js && html5)
		__biquadFilter = new BiquadFilterNode(untyped Howler.ctx);
		__audioNodes.push(__biquadFilter);
		#end

		@:bypassAccessor this.type = type;
		@:bypassAccessor this.frequency = frequency;

		__update();
	}

	/*#if lime_openal
	@:noCompletion private inline function dbToGain(db:Float):Float
	{
		return Math.pow(10, db / 20);
	}

	@:noCompletion private inline function correctCutoff(freq:Float):Float
	{
		return Math.min(freq * 1.25, 22000);
	}

	@:noCompletion private inline function applyDetune(freq:Float, detuneCents:Float):Float
	{
		return freq * Math.pow(2, detuneCents / 1200);
	}

	@:noCompletion private inline function normalizeFreq(freq:Float):Float
	{
		return Math.min(Math.max(freq / 22050, 0), 1);
	}

	@:noCompletion private inline function qToResonance(q:Float):Float
	{
		return Math.min(Math.max(1 + (q - 0.7) * 0.6, 0.5), 3);
	}
	#end*/

	@:noCompletion override function __update():Void
	{
		#if lime_openal
		if (__alFilter == null) return;

		// An attempt to try approximate the filtering to match with web.
		switch (type)
		{
			case LOWPASS:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_LOWPASS);
				AL.filterf(__alFilter, AL.LOWPASS_GAIN, 1.0 - Math.exp(-64 * frequency / 4000.0));
				AL.filterf(__alFilter, AL.LOWPASS_GAINHF, frequency > 22000.0 ? 1.0 : 1.0 - Math.exp(-2.48 * Math.max(frequency - 200, 0) / 18000.0));

			case HIGHPASS:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_HIGHPASS);
				AL.filterf(__alFilter, AL.HIGHPASS_GAIN, Math.exp(-2.48 * (frequency + 2000.0) / 22000.0));
				AL.filterf(__alFilter, AL.HIGHPASS_GAINLF, Math.exp(-14 * frequency / 20000.0));

			case BANDPASS:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_BANDPASS);
				AL.filterf(__alFilter, AL.BANDPASS_GAIN, Math.pow(Math.sin(frequency / 7639.437268410977/*(24000.0 / Math.PI)*/), 0.01));
				AL.filterf(__alFilter, AL.BANDPASS_GAINHF, frequency / 24000.0);
				AL.filterf(__alFilter, AL.BANDPASS_GAINLF, (24000.0 - frequency) / 24000.0);

			/*
			case LOWPASS:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_LOWPASS);
				AL.filterf(__alFilter, AL.LOWPASS_GAIN, 1);
				AL.filterf(__alFilter, AL.LOWPASS_GAINHF, normalizeFreq(freq));
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_GAIN, qToResonance(q));
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_CENTER, freq);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_WIDTH, q);
				trace("lowpass", normalizeFreq(freq), qToResonance(q), freq, q);

			case HIGHPASS:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_HIGHPASS);
				AL.filterf(__alFilter, AL.HIGHPASS_GAIN, 1);
				AL.filterf(__alFilter, AL.HIGHPASS_GAINLF, normalizeFreq(freq));
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_GAIN, qToResonance(q));
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_CENTER, freq);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_WIDTH, q);
				trace("highpass", normalizeFreq(freq), qToResonance(q), freq, q);

			case BANDPASS:
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_NULL);
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_BANDPASS);
				AL.filterf(__alFilter, AL.BANDPASS_GAIN, 1);

				var bw = freq / q;
				AL.filterf(__alFilter, AL.BANDPASS_GAINLF, normalizeFreq(freq - bw * 0.5));
				AL.filterf(__alFilter, AL.BANDPASS_GAINHF, normalizeFreq(freq + bw * 0.5));
				trace("bandpass", freq, bw, normalizeFreq(freq - bw * 0.5), normalizeFreq(freq + bw * 0.5));

			case LOWSHELF:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_NULL);
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_LOW_GAIN, dbToGain(gain));
				AL.effectf(__alEffect, AL.EQUALIZER_LOW_CUTOFF, freq);

			case HIGHSHELF:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_NULL);
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_HIGH_GAIN, dbToGain(gain));
				AL.effectf(__alEffect, AL.EQUALIZER_HIGH_CUTOFF, freq);

			case PEAKING:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_NULL);
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_GAIN, dbToGain(gain));
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_CENTER, freq);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_WIDTH, q);

			case NOTCH:
				AL.filteri(__alFilter, AL.FILTER_TYPE, AL.FILTER_NULL);
				AL.effecti(__alEffect, AL.EFFECT_TYPE, AL.EFFECT_EQUALIZER);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_GAIN, 0.2);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_CENTER, freq);
				AL.effectf(__alEffect, AL.EQUALIZER_MID1_WIDTH, q);
			*/
		}
		#elseif (js && html5)
		__biquadFilter.type = cast type;
		__biquadFilter.frequency.value = frequency;
		#end

		super.__update();
	}

	@:noCompletion private inline function set_type(value:FilterEffectType):FilterEffectType
	{
		if (type == value) return value;
		type = value;

		__update();
		return value;
	}

	@:noCompletion private inline function set_frequency(value:Float):Float
	{
		if (frequency == value) return value;
		frequency = Math.min(Math.max(value, 0), 24000);

		__update();
		return value;
	}
}

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FilterEffectType(String) from String to String
{
	var LOWPASS = "lowpass";
	var HIGHPASS = "highpass";
	var BANDPASS = "bandpass";
	//var LOWSHELF = "lowshelf";
	//var HIGHSHELF = "highshelf";
	//var PEAKING = "peaking";
	//var NOTCH = "notch";
	//var ALLPASS = "allpass";
}
