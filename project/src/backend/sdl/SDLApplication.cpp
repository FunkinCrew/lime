#include "SDLApplication.h"
#include "SDLGamepad.h"
#include "SDLJoystick.h"
#include <system/System.h>

#ifdef HX_MACOS
#include <CoreFoundation/CoreFoundation.h>
#endif

#ifdef EMSCRIPTEN
#include "emscripten.h"
#endif

#include <cmath>


namespace lime {


	AutoGCRoot* Application::callback = 0;
	SDLApplication* SDLApplication::currentApplication = 0;


	const int analogAxisDeadZone = 1000;
	std::map<int, std::map<int, int> > gamepadsAxisMap;


	#if defined(ANDROID) || defined (IPHONE)
	SDL_SensorID gyroscopeSensorID = -1;
	SDL_Sensor* gyroscopeSensor = nullptr;

	SDL_SensorID accelerometerSensorID = -1;
	SDL_Sensor* accelerometerSensor = nullptr;
	#endif


	SDLApplication::SDLApplication () {

		SDL_SetHint (SDL_HINT_TIMER_RESOLUTION, "1");

		#if !defined(EMSCRIPTEN) && !defined(LIME_SWITCH)
		SDL_SetHint (SDL_HINT_ANDROID_TRAP_BACK_BUTTON, "0");
		SDL_SetHint (SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");
		SDL_SetHint (SDL_HINT_MOUSE_TOUCH_EVENTS, "0");
		SDL_SetHint (SDL_HINT_TOUCH_MOUSE_EVENTS, "1");
		#endif

		#if !(defined (LIME_ANGLE) && defined (IPHONE))
		SDL_SetHint (SDL_HINT_VIDEO_FORCE_EGL, "1");
		#ifdef HX_WINDOWS
		SDL_SetHint (SDL_HINT_VIDEO_WIN_D3DCOMPILER, "none");
		#endif
		SDL_SetHint (SDL_HINT_OPENGL_ES_DRIVER, "1");
		#endif

		Uint32 initFlags = SDL_INIT_VIDEO | SDL_INIT_GAMEPAD | SDL_INIT_JOYSTICK | SDL_INIT_SENSOR;

		// #if defined(LIME_MOJOAL) || defined(LIME_OPENALSOFT)
		// initFlags |= SDL_INIT_AUDIO;
		// #endif

		if (!SDL_Init (initFlags)) {

			printf ("Could not initialize SDL: %s.\n", SDL_GetError ());

		}

		#if defined(ANDROID) || defined (IPHONE)
		SDL_SetEventFilter (HandleAppLifecycleEvent, NULL);
		#endif

		SDL_SetLogPriority (SDL_LOG_CATEGORY_APPLICATION, SDL_LOG_PRIORITY_WARN);

		currentApplication = this;
		active = false;
		frameStart = 0;
		frameEnd = 0;
		frameTargetTime = std::round (SDL_NS_PER_SECOND / 60.0);
		deltaTime = 0.0;

		SDL_SetEventEnabled (SDL_EVENT_DROP_FILE, true);

		#if defined(ANDROID) || defined (IPHONE)
		InitializeSensors ();
		#endif

		#ifdef HX_MACOS
		CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL (CFBundleGetMainBundle ());
		char path[PATH_MAX];

		if (CFURLGetFileSystemRepresentation (resourcesURL, TRUE, (UInt8 *)path, PATH_MAX)) {

			chdir (path);

		}

		CFRelease (resourcesURL);
		#endif

	}


	#if defined(ANDROID) || defined (IPHONE)
	void SDLApplication::InitializeSensors () {

		gyroscopeSensorID = System::GetFirstGyroscopeSensorId ();

		if (gyroscopeSensorID > 0)
			gyroscopeSensor = SDL_SensorOpen (gyroscopeSensorID);

		accelerometerSensorID = System::GetFirstAccelerometerSensorId ();

		if (gyroscopeSensorID > 0)
			accelerometerSensor = SDL_SensorOpen (gyroscopeSensorID);

	}
	#endif


	SDLApplication::~SDLApplication () {

		#if defined(ANDROID) || defined(IPHONE)
		if (gyroscopeSensor) {

			SDL_SensorClose (gyroscopeSensor);
			gyroscopeSensor = nullptr;
			gyroscopeSensorID = -1;

		}

		if (accelerometerSensor) {

			SDL_SensorClose (accelerometerSensor);
			accelerometerSensor = nullptr;
			accelerometerSensorID = -1;

		}
		#endif

	}


	int SDLApplication::Exec () {

		Init ();

		#ifdef EMSCRIPTEN
		emscripten_cancel_main_loop ();
		emscripten_set_main_loop (UpdateFrame, 0, 0);
		emscripten_set_main_loop_timing (EM_TIMING_RAF, 1);
		#endif

		#if defined(IPHONE) || defined(EMSCRIPTEN)

		return 0;

		#else

		while (active) {

			Update ();

		}

		return Quit ();

		#endif

	}


	void SDLApplication::HandleEvent (SDL_Event* event) {

		#if defined(IPHONE) || defined(EMSCRIPTEN)

		int top = 0;
		gc_set_top_of_stack(&top,false);

		#endif

		switch (event->type) {

			case SDL_EVENT_CLIPBOARD_UPDATE:

				ProcessClipboardEvent (event);
				break;

			case SDL_EVENT_GAMEPAD_AXIS_MOTION:
			case SDL_EVENT_GAMEPAD_BUTTON_DOWN:
			case SDL_EVENT_GAMEPAD_BUTTON_UP:
			case SDL_EVENT_GAMEPAD_ADDED:
			case SDL_EVENT_GAMEPAD_REMOVED:

				ProcessGamepadEvent (event);
				break;

			case SDL_EVENT_DROP_FILE:

				ProcessDropEvent (event);
				break;

			case SDL_EVENT_FINGER_MOTION:
			case SDL_EVENT_FINGER_DOWN:
			case SDL_EVENT_FINGER_UP:

				ProcessTouchEvent (event);
				break;

			case SDL_EVENT_JOYSTICK_AXIS_MOTION:

				ProcessJoystickEvent (event);
				break;

			case SDL_EVENT_JOYSTICK_BALL_MOTION:
			case SDL_EVENT_JOYSTICK_BUTTON_DOWN:
			case SDL_EVENT_JOYSTICK_BUTTON_UP:
			case SDL_EVENT_JOYSTICK_HAT_MOTION:
			case SDL_EVENT_JOYSTICK_ADDED:
			case SDL_EVENT_JOYSTICK_REMOVED:

				ProcessJoystickEvent (event);
				break;

			case SDL_EVENT_KEY_DOWN:
			case SDL_EVENT_KEY_UP:

				ProcessKeyEvent (event);
				break;

			case SDL_EVENT_MOUSE_MOTION:
			case SDL_EVENT_MOUSE_BUTTON_DOWN:
			case SDL_EVENT_MOUSE_BUTTON_UP:
			case SDL_EVENT_MOUSE_WHEEL:

				ProcessMouseEvent (event);
				break;

			#ifndef EMSCRIPTEN
			case SDL_EVENT_RENDER_DEVICE_RESET:

				renderEvent.type = RENDER_CONTEXT_LOST;
				RenderEvent::Dispatch (&renderEvent);

				renderEvent.type = RENDER_CONTEXT_RESTORED;
				RenderEvent::Dispatch (&renderEvent);

				renderEvent.type = RENDER;
				break;
			#endif

			#if defined(ANDROID) || defined (IPHONE)
			case SDL_EVENT_SENSOR_UPDATE:

				ProcessSensorEvent (event);
				break;
			#endif

			case SDL_EVENT_TEXT_INPUT:
			case SDL_EVENT_TEXT_EDITING:

				ProcessTextEvent (event);
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

				if (SDL_PollEvent(&event)) {

					if (event.type != SDL_EVENT_QUIT) {

						HandleEvent(&event);

					}

				}

				break;

			case SDL_EVENT_QUIT:

				active = false;
				break;

		}

	}


	void SDLApplication::Init () {

		active = true;

	}


	void SDLApplication::ProcessClipboardEvent (SDL_Event* event) {

		if (ClipboardEvent::callback) {

			clipboardEvent.type = CLIPBOARD_UPDATE;

			ClipboardEvent::Dispatch (&clipboardEvent);

		}

	}


	void SDLApplication::ProcessDropEvent (SDL_Event* event) {

		if (DropEvent::callback) {

			dropEvent.type = DROP_FILE;
			dropEvent.file = (vbyte*)event->drop.data;

			DropEvent::Dispatch (&dropEvent);
			SDL_free (dropEvent.file);

		}

	}


	void SDLApplication::ProcessGamepadEvent (SDL_Event* event) {

		if (GamepadEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_GAMEPAD_AXIS_MOTION:

					if (gamepadsAxisMap[event->gaxis.which].empty ()) {

						gamepadsAxisMap[event->gaxis.which][event->gaxis.axis] = event->gaxis.value;

					} else if (gamepadsAxisMap[event->gaxis.which][event->gaxis.axis] == event->gaxis.value) {

						break;

					}

					gamepadEvent.type = GAMEPAD_AXIS_MOVE;
					gamepadEvent.axis = event->gaxis.axis;
					gamepadEvent.id = event->gaxis.which;

					if (event->gaxis.value > -analogAxisDeadZone && event->gaxis.value < analogAxisDeadZone) {

						if (gamepadsAxisMap[event->gaxis.which][event->gaxis.axis] != 0) {

							gamepadsAxisMap[event->gaxis.which][event->gaxis.axis] = 0;
							gamepadEvent.axisValue = 0;
							GamepadEvent::Dispatch (&gamepadEvent);

						}

						break;

					}

					gamepadsAxisMap[event->gaxis.which][event->gaxis.axis] = event->gaxis.value;
					gamepadEvent.axisValue = event->gaxis.value / (event->gaxis.value > 0 ? 32767.0 : 32768.0);
					gamepadEvent.timestamp = event->gaxis.timestamp;

					GamepadEvent::Dispatch (&gamepadEvent);
					break;

				case SDL_EVENT_GAMEPAD_BUTTON_DOWN:

					gamepadEvent.type = GAMEPAD_BUTTON_DOWN;
					gamepadEvent.button = event->gbutton.button;
					gamepadEvent.id = event->gbutton.which;
					gamepadEvent.timestamp = event->gbutton.timestamp;

					GamepadEvent::Dispatch (&gamepadEvent);
					break;

				case SDL_EVENT_GAMEPAD_BUTTON_UP:

					gamepadEvent.type = GAMEPAD_BUTTON_UP;
					gamepadEvent.button = event->gbutton.button;
					gamepadEvent.id = event->gbutton.which;
					gamepadEvent.timestamp = event->gbutton.timestamp;

					GamepadEvent::Dispatch (&gamepadEvent);
					break;

				case SDL_EVENT_GAMEPAD_ADDED:

					if (SDLGamepad::Connect (event->cdevice.which)) {

						gamepadEvent.type = GAMEPAD_CONNECT;
						gamepadEvent.id = SDLGamepad::GetInstanceID (event->cdevice.which);
						gamepadEvent.timestamp = event->cdevice.timestamp;

						GamepadEvent::Dispatch (&gamepadEvent);

					}

					break;

				case SDL_EVENT_GAMEPAD_REMOVED: {

					gamepadEvent.type = GAMEPAD_DISCONNECT;
					gamepadEvent.id = event->cdevice.which;
					gamepadEvent.timestamp = event->cdevice.timestamp;

					GamepadEvent::Dispatch (&gamepadEvent);
					SDLGamepad::Disconnect (event->cdevice.which);
					break;

				}

			}

		}

	}


	void SDLApplication::ProcessJoystickEvent (SDL_Event* event) {

		if (JoystickEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_JOYSTICK_AXIS_MOTION:

					joystickEvent.type = JOYSTICK_AXIS_MOVE;
					joystickEvent.index = event->jaxis.axis;
					joystickEvent.x = event->jaxis.value / (event->jaxis.value > 0 ? 32767.0 : 32768.0);
					joystickEvent.id = event->jaxis.which;

					JoystickEvent::Dispatch (&joystickEvent);
					break;

				case SDL_EVENT_JOYSTICK_BUTTON_DOWN:

					joystickEvent.type = JOYSTICK_BUTTON_DOWN;
					joystickEvent.index = event->jbutton.button;
					joystickEvent.id = event->jbutton.which;

					JoystickEvent::Dispatch (&joystickEvent);
					break;

				case SDL_EVENT_JOYSTICK_BUTTON_UP:

					joystickEvent.type = JOYSTICK_BUTTON_UP;
					joystickEvent.index = event->jbutton.button;
					joystickEvent.id = event->jbutton.which;

					JoystickEvent::Dispatch (&joystickEvent);
					break;

				case SDL_EVENT_JOYSTICK_HAT_MOTION:

					joystickEvent.type = JOYSTICK_HAT_MOVE;
					joystickEvent.index = event->jhat.hat;
					joystickEvent.eventValue = event->jhat.value;
					joystickEvent.id = event->jhat.which;

					JoystickEvent::Dispatch (&joystickEvent);
					break;

				case SDL_EVENT_JOYSTICK_ADDED:

					joystickEvent.type = JOYSTICK_CONNECT;
					joystickEvent.id = SDLJoystick::GetInstanceID (event->jdevice.which);

					JoystickEvent::Dispatch (&joystickEvent);
					break;

				case SDL_EVENT_JOYSTICK_REMOVED:

					joystickEvent.type = JOYSTICK_DISCONNECT;
					joystickEvent.id = event->jdevice.which;

					JoystickEvent::Dispatch (&joystickEvent);
					SDLJoystick::Disconnect (event->jdevice.which);
					break;

			}

		}

	}


	void SDLApplication::ProcessKeyEvent (SDL_Event* event) {

		if (KeyEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_KEY_DOWN: keyEvent.type = KEY_DOWN; break;
				case SDL_EVENT_KEY_UP: keyEvent.type = KEY_UP; break;

			}

			keyEvent.keyCode = event->key.key;
			keyEvent.modifier = event->key.mod;
			keyEvent.windowID = event->key.windowID;
			keyEvent.timestamp = event->key.timestamp;

			if (keyEvent.type == KEY_DOWN) {

				if (keyEvent.keyCode == SDLK_CAPSLOCK) keyEvent.modifier |= SDL_KMOD_CAPS;
				if (keyEvent.keyCode == SDLK_LALT) keyEvent.modifier |= SDL_KMOD_LALT;
				if (keyEvent.keyCode == SDLK_LCTRL) keyEvent.modifier |= SDL_KMOD_LCTRL;
				if (keyEvent.keyCode == SDLK_LGUI) keyEvent.modifier |= SDL_KMOD_LGUI;
				if (keyEvent.keyCode == SDLK_LSHIFT) keyEvent.modifier |= SDL_KMOD_LSHIFT;
				if (keyEvent.keyCode == SDLK_MODE) keyEvent.modifier |= SDL_KMOD_MODE;
				if (keyEvent.keyCode == SDLK_NUMLOCKCLEAR) keyEvent.modifier |= SDL_KMOD_NUM;
				if (keyEvent.keyCode == SDLK_RALT) keyEvent.modifier |= SDL_KMOD_RALT;
				if (keyEvent.keyCode == SDLK_RCTRL) keyEvent.modifier |= SDL_KMOD_RCTRL;
				if (keyEvent.keyCode == SDLK_RGUI) keyEvent.modifier |= SDL_KMOD_RGUI;
				if (keyEvent.keyCode == SDLK_RSHIFT) keyEvent.modifier |= SDL_KMOD_RSHIFT;

			}

			KeyEvent::Dispatch (&keyEvent);

		}

	}


	void SDLApplication::ProcessMouseEvent (SDL_Event* event) {

		if (MouseEvent::callback) {

			SDL_Window * sdlWindow = SDL_GetWindowFromID(event->window.windowID);

			float scale = SDL_GetWindowPixelDensity(sdlWindow) / SDL_GetWindowDisplayScale(sdlWindow);

			switch (event->type) {

				case SDL_EVENT_MOUSE_MOTION:

					mouseEvent.type = MOUSE_MOVE;
					mouseEvent.x = event->motion.x * scale;
					mouseEvent.y = event->motion.y * scale;
					mouseEvent.movementX = event->motion.xrel * scale;
					mouseEvent.movementY = event->motion.yrel * scale;
					break;

				case SDL_EVENT_MOUSE_BUTTON_DOWN:

					SDL_CaptureMouse (true);

					mouseEvent.type = MOUSE_DOWN;
					mouseEvent.button = event->button.button - 1;
					mouseEvent.x = event->button.x * scale;
					mouseEvent.y = event->button.y * scale;
					mouseEvent.clickCount = event->button.clicks;
					break;

				case SDL_EVENT_MOUSE_BUTTON_UP:

					SDL_CaptureMouse (false);

					mouseEvent.type = MOUSE_UP;
					mouseEvent.button = event->button.button - 1;
					mouseEvent.x = event->button.x * scale;
					mouseEvent.y = event->button.y * scale;
					mouseEvent.clickCount = event->button.clicks;
					break;

				case SDL_EVENT_MOUSE_WHEEL:

					mouseEvent.type = MOUSE_WHEEL;

					if (event->wheel.direction == SDL_MOUSEWHEEL_FLIPPED) {

						mouseEvent.x = -event->wheel.x;
						mouseEvent.y = -event->wheel.y;

					} else {

						mouseEvent.x = event->wheel.x;
						mouseEvent.y = event->wheel.y;

					}
					break;

			}

			mouseEvent.windowID = event->button.windowID;
			MouseEvent::Dispatch (&mouseEvent);

		}

	}


	#if defined(ANDROID) || defined (IPHONE)
	void SDLApplication::ProcessSensorEvent(SDL_Event* event) {

		if (SensorEvent::callback) {

			if (event->sensor.which == gyroscopeSensorID) {

				sensorEvent.type = SENSOR_GYROSCOPE;
				sensorEvent.id = event->sensor.which;
				sensorEvent.x = event->sensor.data[0];
				sensorEvent.y = event->sensor.data[1];
				sensorEvent.z = event->sensor.data[2];
				SensorEvent::Dispatch(&sensorEvent);

			} else if (event->sensor.which == accelerometerSensorID) {

				sensorEvent.type = SENSOR_ACCELEROMETER;
				sensorEvent.id = event->sensor.which;
				sensorEvent.x = event->sensor.data[0];
				sensorEvent.y = event->sensor.data[1];
				sensorEvent.z = event->sensor.data[2];
				SensorEvent::Dispatch(&sensorEvent);

			}

		}

	}
	#endif


	void SDLApplication::ProcessTextEvent (SDL_Event* event) {

		if (TextEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_TEXT_INPUT:

					textEvent.type = TEXT_INPUT;
					break;

				case SDL_EVENT_TEXT_EDITING:

					textEvent.type = TEXT_EDIT;
					textEvent.start = event->edit.start;
					textEvent.length = event->edit.length;
					break;

			}

			if (textEvent.text) {

				free (textEvent.text);

			}

			textEvent.text = (vbyte*)malloc (strlen (event->text.text) + 1);
			strcpy ((char*)textEvent.text, event->text.text);

			textEvent.windowID = event->text.windowID;
			TextEvent::Dispatch (&textEvent);

		}

	}


	void SDLApplication::ProcessTouchEvent (SDL_Event* event) {

		if (TouchEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_FINGER_MOTION:

					touchEvent.type = TOUCH_MOVE;
					break;

				case SDL_EVENT_FINGER_DOWN:

					touchEvent.type = TOUCH_START;
					break;

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

			TouchEvent::Dispatch (&touchEvent);

		}

	}


	void SDLApplication::ProcessWindowEvent (SDL_Event* event) {

		if (WindowEvent::callback) {

			switch (event->type) {

				case SDL_EVENT_WINDOW_SHOWN: windowEvent.type = WINDOW_SHOW; break;
				case SDL_EVENT_WINDOW_CLOSE_REQUESTED: windowEvent.type = WINDOW_CLOSE; break;
				case SDL_EVENT_WINDOW_HIDDEN: windowEvent.type = WINDOW_HIDE; break;
				case SDL_EVENT_WINDOW_MOUSE_ENTER: windowEvent.type = WINDOW_ENTER; break;
				case SDL_EVENT_WINDOW_FOCUS_GAINED: windowEvent.type = WINDOW_FOCUS_IN; break;
				case SDL_EVENT_WINDOW_FOCUS_LOST: windowEvent.type = WINDOW_FOCUS_OUT; break;
				case SDL_EVENT_WINDOW_MOUSE_LEAVE: windowEvent.type = WINDOW_LEAVE; break;
				case SDL_EVENT_WINDOW_MAXIMIZED: windowEvent.type = WINDOW_MAXIMIZE; break;
				case SDL_EVENT_WINDOW_MINIMIZED: windowEvent.type = WINDOW_MINIMIZE; break;
				case SDL_EVENT_WINDOW_EXPOSED: windowEvent.type = WINDOW_EXPOSE; break;

				case SDL_EVENT_WINDOW_MOVED:

					windowEvent.type = WINDOW_MOVE;
					windowEvent.x = event->window.data1;
					windowEvent.y = event->window.data2;
					break;

				case SDL_EVENT_WINDOW_RESIZED:
				{
					float scale = SDL_GetWindowDisplayScale(SDL_GetWindowFromID(event->window.windowID));
					windowEvent.type = WINDOW_RESIZE;
					windowEvent.width = (int)(event->window.data1 / scale);
					windowEvent.height = (int)(event->window.data2 / scale);
					break;
				}

				case SDL_EVENT_WINDOW_RESTORED: windowEvent.type = WINDOW_RESTORE; break;

			}

			windowEvent.windowID = event->window.windowID;
			WindowEvent::Dispatch (&windowEvent);

		}

	}


	int SDLApplication::Quit () {

		applicationEvent.type = EXIT;
		ApplicationEvent::Dispatch (&applicationEvent);

		SDL_Quit ();

		return 0;

	}


	void SDLApplication::RegisterWindow (SDLWindow *window) {

		#ifdef IPHONE
		SDL_SetiOSAnimationCallback (window->sdlWindow, 1, UpdateFrame, NULL);
		#endif

	}


	void SDLApplication::SetFrameRate (double frameRate) {

		frameTargetTime = frameRate < 1 ? 0 : std::round (SDL_NS_PER_SECOND / frameRate);

	}


	bool SDLApplication::Update () {

		frameStart = SDL_GetTicksNS ();

		{
			SDL_Event event;

			while (SDL_PollEvent (&event)) {

				HandleEvent (&event);

				if (!active)
					return active;

			}

			applicationEvent.type = UPDATE;
			applicationEvent.deltaTime = deltaTime;

			ApplicationEvent::Dispatch (&applicationEvent);
			RenderEvent::Dispatch (&renderEvent);
		}

		frameEnd = SDL_GetTicksNS ();

		Uint64 frameTime = frameEnd - frameStart;

		if (frameTargetTime > 0 && frameTime < frameTargetTime) {

			SDL_DelayPrecise (frameTargetTime - frameTime);

		}

		deltaTime = (double) (SDL_GetTicksNS () - frameStart) / SDL_NS_PER_MS;

		return active;
	}


	#if defined(ANDROID) || defined (IPHONE)
	int SDLApplication::HandleAppLifecycleEvent (void* userdata, SDL_Event* event) {

		#if defined(IPHONE)

		int top = 0;

		gc_set_top_of_stack (&top, false);

		#endif

		switch (event->type) {

			case SDL_APP_TERMINATING:

				return 0;

			case SDL_APP_LOWMEMORY:

				return 0;

			case SDL_APP_WILLENTERBACKGROUND:

				return 0;

			case SDL_APP_DIDENTERBACKGROUND:

				currentApplication->windowEvent.type = WINDOW_DEACTIVATE;
				WindowEvent::Dispatch (&currentApplication->windowEvent);
				return 0;

			case SDL_APP_WILLENTERFOREGROUND:

				return 0;

			case SDL_APP_DIDENTERFOREGROUND:

				currentApplication->windowEvent.type = WINDOW_ACTIVATE;
				WindowEvent::Dispatch (&currentApplication->windowEvent);
				return 0;

			default:

				return 1;

		}

	}
	#endif


	void SDLApplication::UpdateFrame () {

		#ifdef EMSCRIPTEN
		System::GCTryExitBlocking ();
		#endif

		currentApplication->Update ();

		#ifdef EMSCRIPTEN
		System::GCTryEnterBlocking ();
		#endif

	}


	void SDLApplication::UpdateFrame (void*) {

		UpdateFrame ();

	}


	Application* CreateApplication () {

		return new SDLApplication ();

	}


}


#ifdef ANDROID
int SDL_main (int argc, char *argv[]) { return 0; }
#endif
