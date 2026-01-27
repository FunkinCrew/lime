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

	/**
		horizontal delta of trackpad scroll
	**/
	public var scrollX:Float;

	/**
		vertical delta of trackpad scroll
	**/
	public var scrollY:Float;

	/**
		horizontal scroll inertia after a user lifts their finger
	**/
	public var momentumScrollX:Float;

	/**
		vertical scroll inertia after a user lifts their finger
	**/
	public var momentumScrollY:Float;


	public function new(type:GestureType = UNSPECIFIED, magnification:Float = 0.0, rotation:Float = 0.0, panTranslationX:Float = 0.0, panTranslationY:Float = 0.0, panVelocityX:Float = 0.0, panVelocityY:Float = 0.0)
	{
		this.type = type;
		this.magnification = magnification;
		this.rotation = rotation;
		this.panTranslationX = panTranslationX;
		this.panTranslationY = panTranslationY;
		this.panVelocityX = panVelocityX;
		this.panVelocityY = panVelocityY;
	}

	public function clear():Void
	{
		this.type = UNSPECIFIED;
		this.magnification = 0.0;
		this.rotation = 0.0;
		this.panTranslationX = 0.0;
		this.panTranslationY = 0.0;
		this.panVelocityX = 0.0;
		this.panVelocityY = 0.0;
	}
}

enum GestureType
{
	ROTATION;
	MAGNIFICATION;
	PAN;
	SCROLL;
	MOMENTUMSCROLL;
	UNSPECIFIED;
}
