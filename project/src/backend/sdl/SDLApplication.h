#pragma once


#include <SDL3/SDL.h>
#include <app/Application.h>
#include <events/ApplicationEvent.h>
#include <events/RenderEvent.h>
#include <events/ClipboardEvent.h>
#include <events/OrientationEvent.h>
#include <events/SensorEvent.h>
#include <events/DropEvent.h>
#include <events/GamepadEvent.h>
#include <events/JoystickEvent.h>
#include <events/KeyEvent.h>
#include <events/MouseEvent.h>
#include <events/TextEvent.h>
#include <events/TouchEvent.h>
#include <events/WindowEvent.h>
#include "SDLWindow.h"


namespace lime {


	struct FrameTime {
		Uint64 current;
		Uint64 previous;
		Uint64 frame;
		Uint64 target;
	};


	class SDLApplication : public Application {

		public:

			SDLApplication ();
			~SDLApplication ();

			virtual int Exec ();
			virtual void Init ();
			virtual int Quit ();
			virtual void SetFrameRate (double frameRate);
			virtual bool Update ();

			void RegisterWindow (SDLWindow *window);

		private:
			void InitializeSensors();

			void HandleEvent (SDL_Event* event);
			void ProcessClipboardEvent (SDL_Event* event);
			void ProcessDropEvent (SDL_Event* event);
			void ProcessGamepadEvent (SDL_Event* event);
			void ProcessJoystickEvent (SDL_Event* event);
			void ProcessKeyEvent (SDL_Event* event);
			void ProcessMouseEvent (SDL_Event* event);
			void ProcessSensorEvent (SDL_Event* event);
			void ProcessTextEvent (SDL_Event* event);
			void ProcessTouchEvent (SDL_Event* event);
			void ProcessWindowEvent (SDL_Event* event);

			static bool HandleAppLifecycleEvent (void* userdata, SDL_Event* event);
			static void UpdateFrame ();
			static void UpdateFrame (void*);

			static SDLApplication* currentApplication;
			FrameTime frameTime;
			bool active;

			ApplicationEvent applicationEvent;
			ClipboardEvent clipboardEvent;
			DropEvent dropEvent;
			GamepadEvent gamepadEvent;
			JoystickEvent joystickEvent;
			KeyEvent keyEvent;
			MouseEvent mouseEvent;
			OrientationEvent orientationEvent;
			RenderEvent renderEvent;
			SensorEvent sensorEvent;
			TextEvent textEvent;
			TouchEvent touchEvent;
			WindowEvent windowEvent;

	};


}