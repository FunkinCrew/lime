package lime.media;

#if lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALAuxiliaryEffectSlot;
import lime.media.openal.ALEffect;
import lime.media.openal.ALFilter;
import lime.media.openal.ALSource;
#elseif (js && html5)
import js.html.audio.AudioNode;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
/**
	Audio effects that can be used to apply to an audio source.

	NOTE: Only works in web, and native targets, flash doesn't support this.
**/
class AudioEffect
{
	/**
		Disables this audio effect.
	**/
	public var bypass(default, set):Bool;

	/**
		Should it dispose immediately if it has been unused.
	**/
	public var autoDispose:Bool = true;

	@:allow(lime.media.AudioSource)
	@:noCompletion private var __appliedSources:Array<AudioSource>;
	#if lime_openal
	@:noCompletion private var __alAux:Null<ALAuxiliaryEffectSlot>;
	@:noCompletion private var __alEffect:Null<ALEffect>;
	@:noCompletion private var __alFilter:Null<ALFilter>;
	#elseif (js && html5)
	@:noCompletion private var __audioNodes:Array<AudioNode>;
	#end

	/**
		Creates a new `AudioEffect` instance.
		Won't do anything since it haven't been implemented.
	**/
	public function new()
	{
		__appliedSources = [];

		#if lime_openal
		__alAux = AL.createAux();
		#elseif (js && html5)
		__audioNodes = [];
		#end
	}

	/**
		Releases any resources used by this `AudioEffect`.
	**/
	public function dispose():Void
	{
		if (__appliedSources == null) return;

		if (!bypass)
		{
			for (source in __appliedSources) 
			{
				if (source != null)
				{
					source.removeEffect(this);
			
				}
			}
		}
		__appliedSources = null;

		#if lime_openal
		if (__alAux != null)
		{
			AL.deleteAux(__alAux);
			__alAux = null;
		}

		if (__alEffect != null)
		{
			AL.deleteEffect(__alEffect);
			__alEffect = null;
		}

		if (__alFilter != null)
		{
			AL.deleteFilter(__alFilter);
			__alFilter = null;
		}
		#elseif (js && html5)
		if (__audioNodes != null)
		{
			for (node in __audioNodes)
			{
				node.disconnect();
			}
			__audioNodes = null;
		}
		#end
	}

	@:noCompletion private function __update():Void
	{
		if (!bypass)
		{
			for (source in __appliedSources)
			{
				if (source != null)
				{
					@:privateAccess
					source.__backend.updateEffect(source.__effects.indexOf(this));
				}
			}
		}
	}

	@:noCompletion private inline function set_bypass(value:Bool):Bool
	{
		if (value == bypass) return value;

		if (value)
		{
			for (source in __appliedSources)
			{
				if (source != null)
				{
					@:privateAccess
					source.__backend.addEffect(source.__effects.indexOf(this));
				}
			}
		}
		else
		{
			for (source in __appliedSources)
			{
				if (source != null)
				{
					@:privateAccess
					source.__backend.removeEffect(source.__effects.indexOf(this));
				}
			}
		}

		return bypass = value;
	}
}