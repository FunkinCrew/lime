package lime._internal.backend.native;

import haxe.MainLoop;

import lime.math.Vector4;
import lime.media.AudioSource;

import sys.thread.Mutex;
import sys.thread.Thread;

@:access(lime.media.AudioBuffer)
class NativeAudioSource
{
	private static var hasDirectChannelsExt:Null<Bool>;
	private static var hasALSoftLatencyExt:Null<Bool>;

	private static var activeAudioSources:Array<NativeAudioSource> = [];
	private static var processingMutex:Mutex = new Mutex();
	private static var processingThread:Thread;

	private var completed:Bool;
	private var dataLength:Int;
	private var format:Int;
	private var loops:Int;
	private var parent:AudioSource;
	private var playing:Bool;
	private var position:Vector4;

	public function new(parent:AudioSource)
	{
		setupProcessingThread();

		this.parent = parent;

		position = new Vector4();
	}

	public function dispose():Void {}

	public function init():Void
	{
		registerSource(this);
	}

	public function play():Void
	{
		if (playing || handle == null)
		{
			return;
		}

		playing = true;

		setCurrentTime(completed ? 0 : getCurrentTime());
	}

	public function pause():Void
	{
		playing = false;
	}

	public function stop():Void
	{
		playing = false;

		setCurrentTime(0);
	}

	// Event Handlers

	private function process():Void
	{
		if (loops > 0)
		{
			playing = false;
			loops--;
			setCurrentTime(0);
			play();
			return;
		}

		if (!completed)
		{
			stop();

			// `onComplete` must not run from the processing thread,
			// in case a crash happens from this callback or smth, itll be bad,
			// it should use the main thread for it.
			MainLoop.runInMainThread(function():Void
			{
				parent.onComplete.dispatch();
			});
		}

		completed = true;
	}

	// Get & Set Methods
	public function getCurrentTime():Float
	{
		return 0;
	}

	public function setCurrentTime(value:Float):Float
	{
		return value;
	}

	public function getGain():Float
	{
		return 1;
	}

	public function setGain(value:Float):Float
	{
		return value;
	}

	public function getLength():Float
	{
		return 0;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPitch():Float
	{
		return 1;
	}

	public function setPitch(value:Float):Float
	{
		return value;
	}

	public function getPosition():Vector4
	{
		return position;
	}

	public function setPosition(value:Vector4):Vector4
	{
		position.x = value.x;
		position.y = value.y;
		position.z = value.z;
		position.w = value.w;

		return position;
	}

	public function getLatency():Float
	{
		return 0;
	}

	// processing Thread Functions

	@:noCompletion
	private static function registerSource(source:NativeAudioSource):Void
	{
		processingMutex.acquire();

		if (!activeAudioSources.contains(source))
			activeAudioSources.push(source);

		processingMutex.release();
	}

	@:noCompletion
	private static function unregisterSource(source:NativeAudioSource):Void
	{
		processingMutex.acquire();

		if (activeAudioSources.contains(source))
			activeAudioSources.remove(source);

		processingMutex.release();
	}

	@:noCompletion
	private static function setupProcessingThread():Void
	{
		if (processingThread == null)
		{
			processingThread = Thread.create(function():Void
			{
				while (true)
				{
					processingMutex.acquire();

					for (activeAudioSource in activeAudioSources)
					{
						activeAudioSource.process();
					}

					// Useful for tracking how many audio sources are currently being processed,
					// but itll spam the shit out of your console,
					// should be removed later ig.
					// MainLoop.runInMainThread(Sys.println.bind('Active sources: ${activeAudioSources.length}'));

					processingMutex.release();

					Sys.sleep(0.01);
				}
			});
		}
	}
}
