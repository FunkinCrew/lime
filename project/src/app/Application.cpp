#include <app/Application.h>
#include <events/ApplicationEvent.h>
#include <events/ClipboardEvent.h>
#include <events/DropEvent.h>
#include <events/GamepadEvent.h>
#include <events/JoystickEvent.h>
#include <events/KeyEvent.h>
#include <events/MouseEvent.h>
#include <events/OrientationEvent.h>
#include <events/RenderEvent.h>
#include <events/SensorEvent.h>
#include <events/TextEvent.h>
#include <events/TouchEvent.h>
#include <events/WindowEvent.h>
#include <system/System.h>
#include <ui/Gamepad.h>
#include <ui/Gesture.h>
#include <ui/Joystick.h>

#ifdef HX_MACOS
#include <unistd.h>
#endif

#include <cmath>

namespace lime
{

	struct FrameTime
	{
		Uint64 current;
		Uint64 previous;
		Uint64 frame;
		Uint64 target;
	};

	Application *Application::currentApplication = 0;

	FrameTime frameTime;
	bool active = false;
	bool background = false;

	SDL_SensorID accelerometerSensorID = -1;
	SDL_Sensor *accelerometerSensor = nullptr;

	SDL_SensorID gyroscopeSensorID = -1;
	SDL_Sensor *gyroscopeSensor = nullptr;

	Application::Application()
	{
#if !(defined(HX_MACOS) || defined(IPHONE))
		SDL_SetHint(SDL_HINT_AUDIO_FREQUENCY, "48000");
		SDL_SetHint(SDL_HINT_AUDIO_CHANNELS, "2");
		SDL_SetHint(SDL_HINT_AUDIO_FORMAT, "F32");
		SDL_SetHint(SDL_HINT_AUDIO_DEVICE_STREAM_ROLE, "Game");

#ifdef ANDROID
		if (SDL_GetAndroidSDKVersion() < 31)
		{
			SDL_SetHint(SDL_HINT_AUDIO_DRIVER, "openslES");
		}
#endif
#endif

		SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI, "1");

#ifdef IPHONE
		SDL_SetHint(SDL_HINT_IOS_HIDE_HOME_INDICATOR, "3");
#endif

#ifdef HX_LINUX
		SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY, "1");
#endif

#ifdef HX_MACOS
		SDL_SetHint(SDL_HINT_MAC_SCROLL_MOMENTUM, "1");

		SDL_SetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY, "1");
#endif

		Uint32 initFlags = SDL_INIT_VIDEO | SDL_INIT_GAMEPAD | SDL_INIT_JOYSTICK | SDL_INIT_SENSOR;

#if !(defined(HX_MACOS) || defined(IPHONE))
		initFlags |= SDL_INIT_AUDIO;
#endif

		if (!SDL_Init(initFlags))
		{
			printf("Could not initialize SDL: %s.\n", SDL_GetError());
		}

		SDL_SetEventFilter(HandleAppLifecycleEvent, NULL);

#if defined(HX_WINDOWS) || defined(HX_MACOS)
		SDL_AddEventWatch(HandleEventWatcher, NULL);
#endif

		currentApplication = this;

		SDL_zero(frameTime);
		frameTime.target = (Uint64)std::llround(1e9 / 60.0);
		frameTime.previous = SDL_GetTicksNS();

		active = false;

		InitializeSensors();

#ifdef HX_MACOS
		const char *path = SDL_GetBasePath();

		if (path)
		{
			chdir(path);
		}
#endif
	}

	void Application::InitializeSensors()
	{
		accelerometerSensorID = System::GetFirstAccelerometerSensorId();

		if (accelerometerSensorID > 0)
		{
			accelerometerSensor = SDL_OpenSensor(accelerometerSensorID);
		}

		gyroscopeSensorID = System::GetFirstGyroscopeSensorId();

		if (gyroscopeSensorID > 0)
		{
			gyroscopeSensor = SDL_OpenSensor(gyroscopeSensorID);
		}
	}

	Application::~Application()
	{
		if (gyroscopeSensor)
		{
			SDL_CloseSensor(gyroscopeSensor);
			gyroscopeSensor = nullptr;
			gyroscopeSensorID = -1;
		}

		if (accelerometerSensor)
		{
			SDL_CloseSensor(accelerometerSensor);
			accelerometerSensor = nullptr;
			accelerometerSensorID = -1;
		}
	}

	int Application::Exec()
	{
		Init();

#ifndef IPHONE

		while (active)
		{
			Update();
		}

		return Quit();

#else

		return 0;

#endif
	}

	void Application::HandleEvent(SDL_Event *event)
	{
		switch (event->type)
		{
			case SDL_EVENT_SYSTEM_THEME_CHANGED:
			{
				ApplicationEvent applicationEvent;
				applicationEvent.type = THEME_CHANGE;
				ApplicationEvent::Dispatch(&applicationEvent);
				break;
			}

			case SDL_EVENT_CLIPBOARD_UPDATE:

				ProcessClipboardEvent(event);
				break;

			case SDL_EVENT_GAMEPAD_AXIS_MOTION:
			case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
			case SDL_EVENT_GAMEPAD_BUTTON_UP:
			case SDL_EVENT_GAMEPAD_ADDED:
			case SDL_EVENT_GAMEPAD_REMOVED:

				ProcessGamepadEvent(event);
				break;

			case SDL_EVENT_DISPLAY_ORIENTATION:
			{
				OrientationEvent orientationEvent;
				orientationEvent.type = DISPLAY_ORIENTATION_CHANGE;
				orientationEvent.orientation = event->display.data1;
				orientationEvent.display = event->display.displayID;
				OrientationEvent::Dispatch(&orientationEvent);
				break;
			}

			case SDL_EVENT_DROP_FILE:
			case SDL_EVENT_DROP_TEXT:
			case SDL_EVENT_DROP_BEGIN:
			case SDL_EVENT_DROP_COMPLETE:
			case SDL_EVENT_DROP_POSITION:

				ProcessDropEvent(event);
				break;

			case SDL_EVENT_FINGER_CANCELED:
			case SDL_EVENT_FINGER_MOTION:
			case SDL_EVENT_FINGER_DOWN:
			case SDL_EVENT_FINGER_UP:

				ProcessTouchEvent(event);
				break;

			case SDL_EVENT_JOYSTICK_AXIS_MOTION:

				ProcessJoystickEvent(event);
				break;

			case SDL_EVENT_JOYSTICK_BALL_MOTION:
			case SDL_EVENT_JOYSTICK_BUTTON_DOWN:
			case SDL_EVENT_JOYSTICK_BUTTON_UP:
			case SDL_EVENT_JOYSTICK_HAT_MOTION:
			case SDL_EVENT_JOYSTICK_ADDED:
			case SDL_EVENT_JOYSTICK_REMOVED:

				ProcessJoystickEvent(event);
				break;

			case SDL_EVENT_KEY_DOWN:
			case SDL_EVENT_KEY_UP:

				ProcessKeyEvent(event);
				break;

			case SDL_EVENT_MOUSE_MOTION:
			case SDL_EVENT_MOUSE_BUTTON_DOWN:
			case SDL_EVENT_MOUSE_BUTTON_UP:
			case SDL_EVENT_MOUSE_WHEEL:

				ProcessMouseEvent(event);
				break;

			case SDL_EVENT_RENDER_DEVICE_RESET:
			{
				RenderEvent renderEventContextLost;
				renderEventContextLost.type = RENDER_CONTEXT_LOST;
				RenderEvent::Dispatch(&renderEventContextLost);

				RenderEvent renderEventContextRestored;
				renderEventContextRestored.type = RENDER_CONTEXT_RESTORED;
				RenderEvent::Dispatch(&renderEventContextRestored);
				break;
			}

			case SDL_EVENT_SENSOR_UPDATE:

				ProcessSensorEvent(event);
				break;

			case SDL_EVENT_TEXT_INPUT:
			case SDL_EVENT_TEXT_EDITING:

				ProcessTextEvent(event);
				break;

			case SDL_EVENT_WINDOW_MOUSE_ENTER:
			case SDL_EVENT_WINDOW_MOUSE_LEAVE:
			case SDL_EVENT_WINDOW_SHOWN:
			case SDL_EVENT_WINDOW_HIDDEN:
			case SDL_EVENT_WINDOW_FOCUS_GAINED:
			case SDL_EVENT_WINDOW_FOCUS_LOST:
			case SDL_EVENT_WINDOW_MAXIMIZED:
			case SDL_EVENT_WINDOW_MINIMIZED:
			case SDL_EVENT_WINDOW_MOVED:
			case SDL_EVENT_WINDOW_RESTORED:
			case SDL_EVENT_WINDOW_EXPOSED:
			case SDL_EVENT_WINDOW_RESIZED:

				ProcessWindowEvent(event);
				break;

			case SDL_EVENT_WINDOW_CLOSE_REQUESTED:

				ProcessWindowEvent(event);

				SDL_Event event;

				if (SDL_PollEvent(&event))
				{
					if (event.type != SDL_EVENT_QUIT)
					{
						HandleEvent(&event);
					}
				}

				break;

			case SDL_EVENT_QUIT:

				active = false;
				break;
		}
	}

	void Application::Init()
	{
		active = true;
	}

	void Application::ProcessClipboardEvent(SDL_Event *event)
	{
		if (ClipboardEvent::callback)
		{
			ClipboardEvent clipboardEvent;
			clipboardEvent.type = CLIPBOARD_UPDATE;
			ClipboardEvent::Dispatch(&clipboardEvent);
		}
	}

	void Application::ProcessDropEvent(SDL_Event *event)
	{
		if (DropEvent::callback)
		{
			DropEvent dropEvent;

			switch (event->type)
			{
				case SDL_EVENT_DROP_FILE:
					dropEvent.type = DROP_FILE;
					break;
				case SDL_EVENT_DROP_TEXT:
					dropEvent.type = DROP_TEXT;
					break;
				case SDL_EVENT_DROP_BEGIN:
					dropEvent.type = DROP_BEGIN;
					break;
				case SDL_EVENT_DROP_COMPLETE:
					dropEvent.type = DROP_COMPLETE;
					break;
				case SDL_EVENT_DROP_POSITION:
					dropEvent.type = DROP_POSITION;
					break;
			}

			dropEvent.x = event->drop.x;
			dropEvent.y = event->drop.y;
			dropEvent.data = (char *)event->drop.data;
			dropEvent.source = (char *)event->drop.source;
			dropEvent.windowID = event->drop.windowID;

			DropEvent::Dispatch(&dropEvent);
		}
	}

	void Application::ProcessGamepadEvent(SDL_Event *event)
	{
		if (GamepadEvent::callback)
		{
			switch (event->type)
			{
				case SDL_EVENT_GAMEPAD_AXIS_MOTION:
				{
					GamepadEvent gamepadEvent;
					gamepadEvent.type = GAMEPAD_AXIS_MOVE;
					gamepadEvent.axis = event->gaxis.axis;
					gamepadEvent.id = event->gaxis.which;
					gamepadEvent.axisValue = event->gaxis.value / (event->gaxis.value > 0 ? 32767.0 : 32768.0);
					gamepadEvent.timestamp = event->gaxis.timestamp;
					GamepadEvent::Dispatch(&gamepadEvent);
					break;
				}

				case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
				{
					GamepadEvent gamepadEvent;
					gamepadEvent.type = GAMEPAD_BUTTON_DOWN;
					gamepadEvent.button = event->gbutton.button;
					gamepadEvent.id = event->gbutton.which;
					gamepadEvent.timestamp = event->gbutton.timestamp;
					GamepadEvent::Dispatch(&gamepadEvent);
					break;
				}

				case SDL_EVENT_GAMEPAD_BUTTON_UP:
				{
					GamepadEvent gamepadEvent;
					gamepadEvent.type = GAMEPAD_BUTTON_UP;
					gamepadEvent.button = event->gbutton.button;
					gamepadEvent.id = event->gbutton.which;
					gamepadEvent.timestamp = event->gbutton.timestamp;
					GamepadEvent::Dispatch(&gamepadEvent);
					break;
				}

				case SDL_EVENT_GAMEPAD_ADDED:
				{
					if (Gamepad::Connect(event->cdevice.which))
					{
						GamepadEvent gamepadEvent;
						gamepadEvent.type = GAMEPAD_CONNECT;
						gamepadEvent.id = Gamepad::GetInstanceID(event->cdevice.which);
						gamepadEvent.timestamp = event->cdevice.timestamp;
						GamepadEvent::Dispatch(&gamepadEvent);
					}
					break;
				}

				case SDL_EVENT_GAMEPAD_REMOVED:
				{
					GamepadEvent gamepadEvent;
					gamepadEvent.type = GAMEPAD_DISCONNECT;
					gamepadEvent.id = event->cdevice.which;
					gamepadEvent.timestamp = event->cdevice.timestamp;
					GamepadEvent::Dispatch(&gamepadEvent);

					Gamepad::Disconnect(event->cdevice.which);
					break;
				}
			}
		}
	}

	void Application::ProcessJoystickEvent(SDL_Event *event)
	{
		if (JoystickEvent::callback)
		{
			switch (event->type)
			{
				case SDL_EVENT_JOYSTICK_AXIS_MOTION:
				{
					JoystickEvent joystickEvent;
					joystickEvent.type = JOYSTICK_AXIS_MOVE;
					joystickEvent.index = event->jaxis.axis;
					joystickEvent.x = event->jaxis.value / (event->jaxis.value > 0 ? 32767.0 : 32768.0);
					joystickEvent.id = event->jaxis.which;
					JoystickEvent::Dispatch(&joystickEvent);
					break;
				}

				case SDL_EVENT_JOYSTICK_BUTTON_DOWN:
				{
					JoystickEvent joystickEvent;
					joystickEvent.type = JOYSTICK_BUTTON_DOWN;
					joystickEvent.index = event->jbutton.button;
					joystickEvent.id = event->jbutton.which;
					JoystickEvent::Dispatch(&joystickEvent);
					break;
				}

				case SDL_EVENT_JOYSTICK_BUTTON_UP:
				{
					JoystickEvent joystickEvent;
					joystickEvent.type = JOYSTICK_BUTTON_UP;
					joystickEvent.index = event->jbutton.button;
					joystickEvent.id = event->jbutton.which;
					JoystickEvent::Dispatch(&joystickEvent);
					break;
				}

				case SDL_EVENT_JOYSTICK_HAT_MOTION:
				{
					JoystickEvent joystickEvent;
					joystickEvent.type = JOYSTICK_HAT_MOVE;
					joystickEvent.index = event->jhat.hat;
					joystickEvent.eventValue = event->jhat.value;
					joystickEvent.id = event->jhat.which;
					JoystickEvent::Dispatch(&joystickEvent);
					break;
				}

				case SDL_EVENT_JOYSTICK_ADDED:
				{
					if (Joystick::Connect(event->jdevice.which))
					{
						JoystickEvent joystickEvent;
						joystickEvent.type = JOYSTICK_CONNECT;
						joystickEvent.id = Joystick::GetInstanceID(event->jdevice.which);
						JoystickEvent::Dispatch(&joystickEvent);
					}
					break;
				}

				case SDL_EVENT_JOYSTICK_REMOVED:
				{
					if (Joystick::Disconnect(event->jdevice.which))
					{
						JoystickEvent joystickEvent;
						joystickEvent.type = JOYSTICK_DISCONNECT;
						joystickEvent.id = event->jdevice.which;
						JoystickEvent::Dispatch(&joystickEvent);
					}
					break;
				}
			}
		}
	}

	void Application::ProcessKeyEvent(SDL_Event *event)
	{
		if (KeyEvent::callback)
		{
			KeyEvent keyEvent;

			keyEvent.type = event->type == SDL_EVENT_KEY_DOWN ? KEY_DOWN : KEY_UP;
			keyEvent.keyCode = event->key.key;
			keyEvent.modifier = event->key.mod;
			keyEvent.windowID = event->key.windowID;
			keyEvent.timestamp = event->key.timestamp;

			if (keyEvent.type == KEY_DOWN)
			{
				if (keyEvent.keyCode == SDLK_CAPSLOCK)
					keyEvent.modifier |= SDL_KMOD_CAPS;

				if (keyEvent.keyCode == SDLK_LALT)
					keyEvent.modifier |= SDL_KMOD_LALT;

				if (keyEvent.keyCode == SDLK_LCTRL)
					keyEvent.modifier |= SDL_KMOD_LCTRL;

				if (keyEvent.keyCode == SDLK_LGUI)
					keyEvent.modifier |= SDL_KMOD_LGUI;

				if (keyEvent.keyCode == SDLK_LSHIFT)
					keyEvent.modifier |= SDL_KMOD_LSHIFT;

				if (keyEvent.keyCode == SDLK_MODE)
					keyEvent.modifier |= SDL_KMOD_MODE;

				if (keyEvent.keyCode == SDLK_NUMLOCKCLEAR)
					keyEvent.modifier |= SDL_KMOD_NUM;

				if (keyEvent.keyCode == SDLK_RALT)
					keyEvent.modifier |= SDL_KMOD_RALT;

				if (keyEvent.keyCode == SDLK_RCTRL)
					keyEvent.modifier |= SDL_KMOD_RCTRL;

				if (keyEvent.keyCode == SDLK_RGUI)
					keyEvent.modifier |= SDL_KMOD_RGUI;

				if (keyEvent.keyCode == SDLK_RSHIFT)
					keyEvent.modifier |= SDL_KMOD_RSHIFT;
			}

			KeyEvent::Dispatch(&keyEvent);
		}
	}

	void Application::ProcessMouseEvent(SDL_Event *event)
	{
		if (MouseEvent::callback)
		{
			MouseEvent mouseEvent;

#ifndef IPHONE
			float scale = 1;
#else
			float scale = SDL_GetWindowPixelDensity(SDL_GetWindowFromID(event->window.windowID));
#endif

			switch (event->type)
			{
				case SDL_EVENT_MOUSE_MOTION:
					mouseEvent.type = MOUSE_MOVE;
					mouseEvent.x = event->motion.x * scale;
					mouseEvent.y = event->motion.y * scale;
					mouseEvent.movementX = event->motion.xrel * scale;
					mouseEvent.movementY = event->motion.yrel * scale;
					break;
				case SDL_EVENT_MOUSE_BUTTON_DOWN:
					mouseEvent.type = MOUSE_DOWN;
					mouseEvent.button = event->button.button - 1;
					mouseEvent.x = event->button.x * scale;
					mouseEvent.y = event->button.y * scale;
					mouseEvent.clickCount = event->button.clicks;
					break;
				case SDL_EVENT_MOUSE_BUTTON_UP:
					mouseEvent.type = MOUSE_UP;
					mouseEvent.button = event->button.button - 1;
					mouseEvent.x = event->button.x * scale;
					mouseEvent.y = event->button.y * scale;
					mouseEvent.clickCount = event->button.clicks;
					break;
				case SDL_EVENT_MOUSE_WHEEL:
					mouseEvent.type = MOUSE_WHEEL;
					mouseEvent.x = event->wheel.x;
					mouseEvent.y = event->wheel.y;
					break;
			}

			mouseEvent.windowID = event->button.windowID;
			MouseEvent::Dispatch(&mouseEvent);
		}
	}

	void Application::ProcessSensorEvent(SDL_Event *event)
	{
		if (SensorEvent::callback)
		{
			if (event->sensor.which == accelerometerSensorID)
			{
				SensorEvent sensorEvent;
				sensorEvent.type = SENSOR_ACCELEROMETER;
				sensorEvent.id = event->sensor.which;
				sensorEvent.x = event->sensor.data[0];
				sensorEvent.y = event->sensor.data[1];
				sensorEvent.z = event->sensor.data[2];
				SensorEvent::Dispatch(&sensorEvent);
			}
			else if (event->sensor.which == gyroscopeSensorID)
			{
				SensorEvent sensorEvent;
				sensorEvent.type = SENSOR_GYROSCOPE;
				sensorEvent.id = event->sensor.which;
				sensorEvent.x = event->sensor.data[0];
				sensorEvent.y = event->sensor.data[1];
				sensorEvent.z = event->sensor.data[2];
				SensorEvent::Dispatch(&sensorEvent);
			}
		}
	}

	void Application::ProcessTextEvent(SDL_Event *event)
	{
		if (TextEvent::callback)
		{
			TextEvent textEvent;

			textEvent.type = event->type == SDL_EVENT_TEXT_INPUT ? TEXT_INPUT : TEXT_EDIT;

			if (event->type == SDL_EVENT_TEXT_EDITING)
			{
				textEvent.start = event->edit.start;
				textEvent.length = event->edit.length;
			}

			if (textEvent.text)
			{
				free(textEvent.text);
			}

			textEvent.text = (char *)malloc(strlen(event->text.text) + 1);
			strcpy((char *)textEvent.text, event->text.text);
			textEvent.windowID = event->text.windowID;

			TextEvent::Dispatch(&textEvent);
		}
	}

	void Application::ProcessTouchEvent(SDL_Event *event)
	{
		if (TouchEvent::callback)
		{
			TouchEvent touchEvent;

			switch (event->type)
			{
				case SDL_EVENT_FINGER_MOTION:
					touchEvent.type = TOUCH_MOVE;
					break;
				case SDL_EVENT_FINGER_DOWN:
					touchEvent.type = TOUCH_START;
					break;
				case SDL_EVENT_FINGER_CANCELED:
				case SDL_EVENT_FINGER_UP:
					touchEvent.type = TOUCH_END;
					break;
			}

			touchEvent.x = event->tfinger.x;
			touchEvent.y = event->tfinger.y;
			touchEvent.id = event->tfinger.fingerID;
			touchEvent.dx = event->tfinger.dx;
			touchEvent.dy = event->tfinger.dy;
			touchEvent.pressure = event->tfinger.pressure;
			touchEvent.device = event->tfinger.touchID;

			TouchEvent::Dispatch(&touchEvent);
		}
	}

	void Application::ProcessWindowEvent(SDL_Event *event)
	{
		if (WindowEvent::callback)
		{
			WindowEvent windowEvent;

			switch (event->type)
			{
				case SDL_EVENT_WINDOW_SHOWN:
					windowEvent.type = WINDOW_SHOW;
					break;
				case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
					windowEvent.type = WINDOW_CLOSE;
					break;
				case SDL_EVENT_WINDOW_HIDDEN:
					windowEvent.type = WINDOW_HIDE;
					break;
				case SDL_EVENT_WINDOW_MOUSE_ENTER:
					windowEvent.type = WINDOW_ENTER;
					break;
				case SDL_EVENT_WINDOW_FOCUS_GAINED:
					windowEvent.type = WINDOW_FOCUS_IN;
					break;
				case SDL_EVENT_WINDOW_FOCUS_LOST:
					windowEvent.type = WINDOW_FOCUS_OUT;
					break;
				case SDL_EVENT_WINDOW_MOUSE_LEAVE:
					windowEvent.type = WINDOW_LEAVE;
					break;
				case SDL_EVENT_WINDOW_MAXIMIZED:
					windowEvent.type = WINDOW_MAXIMIZE;
					break;
				case SDL_EVENT_WINDOW_MINIMIZED:
					windowEvent.type = WINDOW_MINIMIZE;
					break;
				case SDL_EVENT_WINDOW_EXPOSED:
					windowEvent.type = WINDOW_EXPOSE;
					break;
				case SDL_EVENT_WINDOW_MOVED:
					windowEvent.type = WINDOW_MOVE;
					windowEvent.x = event->window.data1;
					windowEvent.y = event->window.data2;
					break;
				case SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED:
				case SDL_EVENT_WINDOW_METAL_VIEW_RESIZED:
				case SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED:
				case SDL_EVENT_WINDOW_RESIZED:
					windowEvent.type = WINDOW_RESIZE;
#ifndef IPHONE
					SDL_GetWindowSize(SDL_GetWindowFromID(event->window.windowID), &windowEvent.width, &windowEvent.height);
#else
					SDL_GetWindowSizeInPixels(SDL_GetWindowFromID(event->window.windowID), &windowEvent.width, &windowEvent.height);
#endif
					break;
				case SDL_EVENT_WINDOW_RESTORED:
					windowEvent.type = WINDOW_RESTORE;
					break;
			}

			windowEvent.windowID = event->window.windowID;

			WindowEvent::Dispatch(&windowEvent);
		}
	}

	int Application::Quit()
	{
		ApplicationEvent applicationEvent;
		applicationEvent.type = EXIT;
		ApplicationEvent::Dispatch(&applicationEvent);

		SDL_Quit();

		return 0;
	}

	void Application::RegisterWindow(Window *window)
	{
#ifdef HX_MACOS
		Gesture::Register(window);
#endif

#ifdef IPHONE
		SDL_SetiOSAnimationCallback(window->sdlWindow, 1, HandleAppAnimationCallback, NULL);
#endif
	}

	void Application::SetFrameRate(double frameRate)
	{
		frameTime.target = frameRate < 1 ? 0 : (Uint64)std::llround(1e9 / frameRate);
	}

	void Application::RenderFrame()
	{
		ApplicationEvent applicationEvent;
		applicationEvent.type = UPDATE;
		applicationEvent.deltaTime = std::fmax(0.0, (double)frameTime.frame / 1e6);
		ApplicationEvent::Dispatch(&applicationEvent);

		RenderEvent renderEvent;
		renderEvent.type = RENDER;
		RenderEvent::Dispatch(&renderEvent);
	}

	void Application::FramePacer()
	{
		// Measure the total duration of the current frame (update + render)
		frameTime.current = SDL_GetTicksNS();
		frameTime.frame = frameTime.current - frameTime.previous;
		frameTime.previous = frameTime.current;

		// If the frame was faster than the target frame time, delay to cap FPS
		if (frameTime.frame < frameTime.target)
		{
			// Pause for the remaining time to maintain a consistent frame rate
			SDL_DelayPrecise(frameTime.target - frameTime.frame);

			// Measure the actual time spent waiting and add it to frameTime
			frameTime.current = SDL_GetTicksNS();
			frameTime.frame += frameTime.current - frameTime.previous;
			frameTime.previous = frameTime.current;
		}
	}

	bool Application::Update()
	{
		SDL_Event event;

		while (SDL_PollEvent(&event))
		{
			HandleEvent(&event);

			if (!active)
				return active;
		}

		if (!background)
		{
			RenderFrame();
		}

		FramePacer();

		return active;
	}

	bool Application::HandleAppLifecycleEvent(void *userdata, SDL_Event *event)
	{
		switch (event->type)
		{
			case SDL_EVENT_TERMINATING:

				return false;

			case SDL_EVENT_LOW_MEMORY:

				return false;

			case SDL_EVENT_WILL_ENTER_BACKGROUND:

				return false;

			case SDL_EVENT_DID_ENTER_BACKGROUND:
			{
				background = true;
				WindowEvent windowEvent;
				windowEvent.type = WINDOW_DEACTIVATE;
				WindowEvent::Dispatch(&windowEvent);
				return false;
			}

			case SDL_EVENT_WILL_ENTER_FOREGROUND:

				return false;

			case SDL_EVENT_DID_ENTER_FOREGROUND:
			{
				WindowEvent windowEvent;
				windowEvent.type = WINDOW_ACTIVATE;
				WindowEvent::Dispatch(&windowEvent);
				background = false;
				return false;
			}

			default:

				return true;
		}
	}

#if defined(HX_WINDOWS) || defined(HX_MACOS)
	bool Application::HandleEventWatcher(void *userdata, SDL_Event *event)
	{
		if (!background)
		{
			switch (event->type)
			{
				case SDL_EVENT_WINDOW_EXPOSED:
				case SDL_EVENT_WINDOW_RESIZED:
					currentApplication->ProcessWindowEvent(event);
					currentApplication->RenderFrame();
					currentApplication->FramePacer();
					return false;
			}
		}

		return true;
	}
#endif

#ifdef IPHONE
	void Application::HandleAppAnimationCallback(void *userdata)
	{
		currentApplication->Update();
	}
#endif

} // namespace lime
