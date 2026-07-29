package lime.ui;


import lime._internal.backend.native.NativeCFFI;
import lime.app.Event;

enum abstract TouchDeviceType(Int) from Int to Int
{
	/**
	 * Invalid touch device.
	 */
	public var INVALID:Int = -1;

	/**
	 * Touch screen with window-relative coordinates.
	 */
	public var DIRECT:Int = 0;

	/**
	 * Trackpad with absolute device coordinates.
	 */
	public var INDIRECT_ABSOLUTE:Int = 1;

	/**
	 * Trackpad with screen cursor-relative coordinates.
	 */
	public var INDIRECT_RELATIVE:Int = 2;
}

@:access(lime._internal.backend.native.NativeCFFI)
class Touch
{
	public static var onCancel = new Event<Touch->Void>();
	public static var onEnd = new Event<Touch->Void>();
	public static var onMove = new Event<Touch->Void>();
	public static var onStart = new Event<Touch->Void>();

	public var device:Int;
	public var dx:Float;
	public var dy:Float;
	public var id:Int;
	public var pressure:Float;
	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float, id:Int, dx:Float, dy:Float, pressure:Float, device:Int)
	{
		this.x = x;
		this.y = y;
		this.id = id;
		this.dx = dx;
		this.dy = dy;
		this.pressure = pressure;
		this.device = device;
	}

	public static function getDevices():Array<Int>
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_touch_get_devices();
		#else
		return null;
		#end
	}

	public static function getDeviceName(id:Int):Dynamic
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_touch_get_device_name(id);
		#else
		return null;
		#end
	}

	public static function getDeviceType(id:Int):TouchDeviceType
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_touch_get_device_type(id);
		#else
		return -1;
		#end
	}
}
