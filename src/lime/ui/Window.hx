package lime.ui;

import lime.app.Application;
import lime.app.Event;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.graphics.RenderContextAttributes;
import lime.math.Rectangle;
import lime.system.Display;
import lime.system.DisplayMode;
#if (js && html5)
import js.html.Element;
#end
#if openfl
import openfl.display.Stage;
#else
typedef Stage = Dynamic;
#end

#if hl
@:keep
#end
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Window
{
	public var application(default, null):Application;
	public var borderless(get, set):Bool;
	public var context(default, null):RenderContext;
	public var cursor(get, set):MouseCursor;
	public var display(get, null):Display;
	public var displayMode(get, set):DisplayMode;
	#if (!lime_doc_gen || (js && html5))
	public var element(default, null):#if (js && html5) Element #else Dynamic #end;
	#end
	public var nativeHandle(get, null):Dynamic;

	/**
	 * The current frame rate (measured in frames-per-second) of the window.
	 *
	 * On some platforms, a frame rate of 60 or greater may imply vsync, which will
	 * perform more quickly on displays with a higher refresh rate
	**/
	public var frameRate(get, set):Float;

	public var fullscreen(get, set):Bool;
	public var height(get, set):Int;
	public var hidden(get, null):Bool;
	public var id(default, null):Int;
	public var maxHeight(get, set):Int;
	public var maximized(get, set):Bool;
	public var maxWidth(get, set):Int;
	public var minHeight(get, set):Int;
	public var minimized(get, set):Bool;
	public var minWidth(get, set):Int;
	public var mouseLock(get, set):Bool;
	public var onActivate(default, null) = new Event<Void->Void>();
	public var onClose(default, null) = new Event<Void->Void>();
	public var onDeactivate(default, null) = new Event<Void->Void>();
	public var onDropFile(default, null) = new Event<String->String->Float->Float->Void>();
	public var onDropText(default, null) = new Event<String->String->Float->Float->Void>();
	public var onDropBegin(default, null) = new Event<Void->Void>();
	public var onDropComplete(default, null) = new Event<Float->Float->Void>();
	public var onDropPosition(default, null) = new Event<Float->Float->Void>();
	public var onEnter(default, null) = new Event<Void->Void>();
	public var onExpose(default, null) = new Event<Void->Void>();
	public var onFocusIn(default, null) = new Event<Void->Void>();
	public var onFocusOut(default, null) = new Event<Void->Void>();
	public var onFullscreen(default, null) = new Event<Void->Void>();
	public var onHide(default, null) = new Event<Void->Void>();

	/**
		Fired when the user presses a key down when this window has focus.
	**/
	public var onKeyDown(default, null) = new Event<KeyCode->KeyModifier->Void>();
	public var onKeyDownPrecise(default, null) = new Event<KeyCode->KeyModifier->haxe.Int64->Void>();

	/**
		Fired when the user releases a key that was down.
	**/
	public var onKeyUp(default, null) = new Event<KeyCode->KeyModifier->Void>();
	public var onKeyUpPrecise(default, null) = new Event<KeyCode->KeyModifier->haxe.Int64->Void>();

	public var onLeave(default, null) = new Event<Void->Void>();

	/**
		Fired when the window is maximized.
	**/
	public var onMaximize(default, null) = new Event<Void->Void>();

	/**
		Fired when the window is minimized.
	**/
	public var onMinimize(default, null) = new Event<Void->Void>();

	/**
		Fired when the user pressed a mouse button down.
	**/
	public var onMouseDown(default, null) = new Event<Float->Float->MouseButton->Void>();

	/**
		Fired when the mouse is moved over the window.
	**/
	public var onMouseMove(default, null) = new Event<Float->Float->Void>();
	public var onMouseMoveRelative(default, null) = new Event<Float->Float->Void>();

	/**
		Fired when the user releases a mouse button that was pressed down.
	**/
	public var onMouseUp(default, null) = new Event<Float->Float->Int->Void>();

	/**
		Fired when the user interacts with the mouse wheel.
	**/
	public var onMouseWheel(default, null) = new Event<Float->Float->MouseWheelMode->Void>();

	/**
		Fired when the window is moved to a new position.
	**/
	public var onMove(default, null) = new Event<Float->Float->Void>();
	public var onRender(default, null) = new Event<RenderContext->Void>();
	public var onRenderContextLost(default, null) = new Event<Void->Void>();
	public var onRenderContextRestored(default, null) = new Event<RenderContext->Void>();

	/**
		Fired when the window is resized with new dimensions.
	**/
	public var onResize(default, null) = new Event<Int->Int->Void>();

	public var onRestore(default, null) = new Event<Void->Void>();
	public var onShow(default, null) = new Event<Void->Void>();
	public var onTextEdit(default, null) = new Event<String->Int->Int->Void>();
	public var onTextInput(default, null) = new Event<String->Void>();

	public var opacity(get, set):Float;
	public var parameters:Dynamic;
	public var resizable(get, set):Bool;
	public var scale(get, null):Float;
	#if (!lime_doc_gen || openfl)
	public var stage(default, null):Stage;
	#end
	public var textInputEnabled(get, set):Bool;
	public var title(get, set):String;
	public var visible(get, set):Bool;
	public var alwaysOnTop(get, set):Bool;
	public var width(get, set):Int;
	public var x(get, set):Int;
	public var y(get, set):Int;

	@:allow(openfl.display.Stage)
	@:allow(lime.app.Application)
	@:allow(lime._internal.backend.html5.HTML5Window)
	private var clickCount:Int = 0;

	@:noCompletion private var __attributes:WindowAttributes;
	@:noCompletion private var __backend:WindowBackend;
	@:noCompletion private var __borderless:Bool;
	@:noCompletion private var __fullscreen:Bool;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __hidden:Bool;
	@:noCompletion private var __maximized:Bool;
	@:noCompletion private var __minimized:Bool;
	@:noCompletion private var __resizable:Bool;
	@:noCompletion private var __scale:Float;
	@:noCompletion private var __title:String;
	@:noCompletion private var __alwaysOnTop:Bool;
	@:noCompletion private var __width:Int;
	@:noCompletion private var __x:Int;
	@:noCompletion private var __y:Int;
	@:noCompletion private var __minWidth:Int = 0;
	@:noCompletion private var __minHeight:Int = 0;
	@:noCompletion private var __maxWidth:Int = 0x7FFFFFFF;
	@:noCompletion private var __maxHeight:Int = 0x7FFFFFFF;

	#if commonjs
	private static function __init__()
	{
		var p = untyped Window.prototype;
		untyped Object.defineProperties(p,
			{
				"borderless": {get: p.get_borderless, set: p.set_borderless},
				"cursor": {get: p.get_cursor, set: p.set_cursor},
				"display": {get: p.get_display},
				"displayMode": {get: p.get_displayMode, set: p.set_displayMode},
				"frameRate": {get: p.get_frameRate, set: p.set_frameRate},
				"fullscreen": {get: p.get_fullscreen, set: p.set_fullscreen},
				"height": {get: p.get_height, set: p.set_height},
				"maxHeight": {get: p.get_maxHeight, set: p.set_maxHeight},
				"maximized": {get: p.get_maximized, set: p.set_maximized},
				"maxWidth": {get: p.get_maxWidth, set: p.set_maxWidth},
				"minHeight": {get: p.get_minHeight, set: p.set_minHeight},
				"minimized": {get: p.get_minimized, set: p.set_minimized},
				"minWidth": {get: p.get_minWidth, set: p.set_minWidth},
				"mouseLock": {get: p.get_mouseLock, set: p.set_mouseLock},
				"resizable": {get: p.get_resizable, set: p.set_resizable},
				"scale": {get: p.get_scale},
				"textInputEnabled": {get: p.get_textInputEnabled, set: p.set_textInputEnabled},
				"title": {get: p.get_title, set: p.set_title},
				"visible": {get: p.get_visible, set: p.set_visible},
				"alwaysOnTop": {get: p.get_alwaysOnTop, set: p.set_alwaysOnTop},
				"width": {get: p.get_width, set: p.set_width},
				"x": {get: p.get_x, set: p.set_y},
				"y": {get: p.get_x, set: p.set_y}
			});
	}
	#end

	@:noCompletion private function new(application:Application, attributes:WindowAttributes)
	{
		this.application = application;
		__attributes = attributes != null ? attributes : {};

		if (Reflect.hasField(__attributes, "parameters")) parameters = __attributes.parameters;

		__width = 0;
		__height = 0;
		__fullscreen = false;
		__scale = 1;
		__x = 0;
		__y = 0;
		__title = Reflect.hasField(__attributes, "title") ? __attributes.title : "";
		__hidden = false;
		__borderless = Reflect.hasField(__attributes, "borderless") ? __attributes.borderless : false;
		__resizable = Reflect.hasField(__attributes, "resizable") ? __attributes.resizable : false;
		__maximized = Reflect.hasField(__attributes, "maximized") ? __attributes.maximized : false;
		__minimized = Reflect.hasField(__attributes, "minimized") ? __attributes.minimized : false;

		id = -1;

		__backend = new WindowBackend(this);
	}

	public function alert(?type:MessageBoxType = INFORMATION, message:String = null, title:String = null, buttons:Array<String> = null):Int
	{
		return __backend.alert(type, message, title, buttons);
	}

	public function close():Void
	{
		__backend.close();
	}

	public function focus():Void
	{
		__backend.focus();
	}

	/**
	 * Sets the swap interval for the current window.
	 * @return `false` if the swap interval could not be set
	**/
	public function setVSyncMode(mode:lime.ui.WindowVSyncMode):Bool
	{
		return __backend.setVSyncMode(mode);
	}

	public function move(x:Int, y:Int):Void
	{
		__backend.move(x, y);

		__x = x;
		__y = y;
	}

	public function readPixels(rect:Rectangle = null):Image
	{
		return __backend.readPixels(rect);
	}

	public function resize(width:Int, height:Int):Void
	{
		if (width < __minWidth)
		{
			width = __minWidth;
		}
		else if (width > __maxWidth)
		{
			width = __maxWidth;
		}
		if (height < __minHeight)
		{
			height = __minHeight;
		}
		else if (height > __maxHeight)
		{
			height = __maxHeight;
		}

		__backend.resize(width, height);

		__width = width;
		__height = height;
	}

	public function setMinSize(width:Int, height:Int):Void
	{
		__backend.setMinSize(width, height);

		__minWidth = width;
		__minHeight = height;
		if (__width < __minWidth || __height < __minHeight) {
			resize(__width, __height);
		}
	}

	public function setMaxSize(width:Int, height:Int):Void
	{
		__backend.setMaxSize(width, height);

		__maxWidth = width;
		__maxHeight = height;
		if (__width > __maxWidth || __height > __maxHeight) {
			resize(__width, __height);
		}
	}

	public function setIcon(image:Image):Void
	{
		if (image == null)
		{
			return;
		}

		__backend.setIcon(image);
	}

	public function toString():String
	{
		return "[object Window]";
	}

	public function warpMouse(x:Int, y:Int):Void
	{
		__backend.warpMouse(x, y);
	}

	// Get & Set Methods
	@:noCompletion private function get_cursor():MouseCursor
	{
		return __backend.getCursor();
	}

	@:noCompletion private function set_cursor(value:MouseCursor):MouseCursor
	{
		return __backend.setCursor(value);
	}

	@:noCompletion private function get_display():Display
	{
		return __backend.getDisplay();
	}

	@:noCompletion private function get_displayMode():DisplayMode
	{
		return __backend.getDisplayMode();
	}

	@:noCompletion private function set_displayMode(value:DisplayMode):DisplayMode
	{
		return __backend.setDisplayMode(value);
	}

	@:noCompletion private function get_nativeHandle():Dynamic
	{
		return __backend.getNativeHandle();
	}

	@:noCompletion private inline function get_borderless():Bool
	{
		return __borderless;
	}

	@:noCompletion private function set_borderless(value:Bool):Bool
	{
		return __borderless = __backend.setBorderless(value);
	}

	@:noCompletion private inline function get_frameRate():Float
	{
		return __backend.getFrameRate();
	}

	@:noCompletion private inline function set_frameRate(value:Float):Float
	{
		return __backend.setFrameRate(value);
	}

	@:noCompletion private inline function get_fullscreen():Bool
	{
		return __fullscreen;
	}

	@:noCompletion private function set_fullscreen(value:Bool):Bool
	{
		return __fullscreen = __backend.setFullscreen(value);
	}

	@:noCompletion private inline function get_height():Int
	{
		return __height;
	}

	@:noCompletion private function set_height(value:Int):Int
	{
		resize(__width, value);
		return __height;
	}

	@:noCompletion private inline function get_hidden():Bool
	{
		return __hidden;
	}

	@:noCompletion private inline function get_maxHeight():Int
	{
		return __maxHeight;
	}

	@:noCompletion private function set_maxHeight(value:Int):Int
	{
		setMaxSize(__maxWidth, value);
		return __maxHeight;
	}

	@:noCompletion private inline function get_maximized():Bool
	{
		return __maximized;
	}

	@:noCompletion private inline function set_maximized(value:Bool):Bool
	{
		__minimized = false;
		return __maximized = __backend.setMaximized(value);
	}

	@:noCompletion private inline function get_maxWidth():Int
	{
		return __maxWidth;
	}

	@:noCompletion private function set_maxWidth(value:Int):Int
	{
		setMinSize(value, __maxHeight);
		return __maxWidth;
	}

	@:noCompletion private inline function get_minHeight():Int
	{
		return __minHeight;
	}

	@:noCompletion private function set_minHeight(value:Int):Int
	{
		setMinSize(__minWidth, value);
		return __minHeight;
	}

	@:noCompletion private inline function get_minimized():Bool
	{
		return __minimized;
	}

	@:noCompletion private function set_minimized(value:Bool):Bool
	{
		__maximized = false;
		return __minimized = __backend.setMinimized(value);
	}

	@:noCompletion private inline function get_minWidth():Int
	{
		return __minWidth;
	}

	@:noCompletion private function set_minWidth(value:Int):Int
	{
		setMinSize(value, __minHeight);
		return __minWidth;
	}

	@:noCompletion private function get_mouseLock():Bool
	{
		return __backend.getMouseLock();
	}

	@:noCompletion private function set_mouseLock(value:Bool):Bool
	{
		__backend.setMouseLock(value);
		return value;
	}

	@:noCompletion private function get_opacity():Float
	{
		return __backend.getOpacity();
	}

	@:noCompletion private function set_opacity(value:Float):Float
	{
		__backend.setOpacity(value);
		return value;
	}

	@:noCompletion private inline function get_resizable():Bool
	{
		return __resizable;
	}

	@:noCompletion private function set_resizable(value:Bool):Bool
	{
		__resizable = __backend.setResizable(value);
		return __resizable;
	}

	@:noCompletion private inline function get_scale():Float
	{
		return __scale;
	}

	@:noCompletion private inline function get_textInputEnabled():Bool
	{
		return __backend.getTextInputEnabled();
	}

	@:noCompletion private inline function set_textInputEnabled(value:Bool):Bool
	{
		return __backend.setTextInputEnabled(value);
	}

	public function setTextInputRect(value:Rectangle):Rectangle
	{
		return __backend.setTextInputRect(value);
	}

	@:noCompletion private inline function get_title():String
	{
		return __title;
	}

	@:noCompletion private function set_title(value:String):String
	{
		return __title = __backend.setTitle(value);
	}

	@:noCompletion private inline function get_visible():Bool
	{
		return !__hidden;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		__hidden = !__backend.setVisible(value);
		return !__hidden;
	}

	@:noCompletion private inline function get_alwaysOnTop():Bool
	{
		return __alwaysOnTop;
	}

	@:noCompletion private function set_alwaysOnTop(value:Bool):Bool
	{
		return __alwaysOnTop = __backend.setAlwaysOnTop(value);
	}

	@:noCompletion private inline function get_width():Int
	{
		return __width;
	}

	@:noCompletion private function set_width(value:Int):Int
	{
		resize(value, __height);
		return __width;
	}

	@:noCompletion private inline function get_x():Int
	{
		return __x;
	}

	@:noCompletion private function set_x(value:Int):Int
	{
		move(value, __y);
		return __x;
	}

	@:noCompletion private inline function get_y():Int
	{
		return __y;
	}

	@:noCompletion private function set_y(value:Int):Int
	{
		move(__x, value);
		return __y;
	}
}

#if (js && html5)
@:noCompletion private typedef WindowBackend = lime._internal.backend.html5.HTML5Window;
#else
@:noCompletion private typedef WindowBackend = lime._internal.backend.native.NativeWindow;
#end
