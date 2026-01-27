package lime.ui;

import lime.app.Event;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Gesture
{
	public static var onCancel = new Event<Gesture->Void>();
	public static var onEnd = new Event<Gesture->Void>();
	public static var onMove = new Event<Gesture->Void>();
	public static var onStart = new Event<Gesture->Void>();

	public var id:Int;
	#if !macos // cant get bc old sdl
	public var timestamp:Int;
	public var dTheta:Float; // rotation
	public var dDist:Float; // scale
	#end
	public var x:Float;
	public var y:Float;
	public var numFingers:Int;

	// mac os stuff
	public var rotation:Float; // for mac is radians
	public var magnification:Float;

	public function new(id:Int = 0, timestamp:Int = 0, dTheta:Float = 0.0, dDist:Float = 0.0, x:Float = 0.0, y:Float = 0.0, numFingers:Int = 0)
	{
		this.id = id;
		#if !macos
		this.timestamp = timestamp;
		this.dTheta = dTheta;
		this.dDist = dDist;
		#end
		this.x = x;
		this.y = y;
		this.numFingers = numFingers;
	}
}