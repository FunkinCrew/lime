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

	/**
		type of gesture that user currently using
	**/
	public var type:GestureType;

	/**
		x position of the gesture center (mouse position)
	**/
	public var x:Float;

	/**
		y position of the gesture center (mouse position)
	**/
	public var y:Float;

	/**
		rotation in radians
	**/
	public var rotation:Float;

	/**
		scale of gesture, starts at 0
	**/
	public var magnification:Float;

	#if macos
	/**
		Offset by x coordinate
	**/
	public var panTranslationX:Float;
	/**
		Offset by y coordinate
	**/
	public var panTranslationY:Float;

	/**
		velocity of pan gesture by x coordinate
	**/
	public var panVelocityX:Float;

	/**
		velocity of pan gesture by y coordinate
	**/
	public var panVelocityY:Float;
	#end

	public function new(type:GestureType = UNSPECIFIED, rotation:Float = 0.0, magnification:Float = 0.0, panTranslationX:Float = 0.0, panTranslationY:Float = 0.0, panVelocityX:Float = 0.0, panVelocityY:Float = 0.0)
	{
		this.type = type;
		this.rotation = rotation;
		this.magnification = magnification;
		#if macos
		this.panTranslationX = panTranslationX;
		this.panTranslationY = panTranslationY;
		this.panVelocityX = panVelocityX;
		this.panVelocityY = panVelocityY;
		#end
	}

	public function clear():Void
	{
		this.type = UNSPECIFIED;
		this.rotation = 0.0;
		this.magnification = 0.0;
		#if macos
		this.panTranslationX = 0.0;
		this.panTranslationY = 0.0;
		this.panVelocityX = 0.0;
		this.panVelocityY = 0.0;
		#end
	}
}

enum GestureType
{
	ROTATION;
	MAGNIFICATION;
	PAN;
	UNSPECIFIED;
}