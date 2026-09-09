#pragma once

#include <hx/CFFIPrime.h>
#include <SDL3/SDL.h>
#include <ui/Window.h>

namespace lime
{

	class Window;

	class Application
	{
	  public:
		Application();
		~Application();

		int Alert(int type, const char *message, const char *title, const char **buttons, int count);
		int Exec();
		void Init();
		int Quit();
		void SetFrameRate(double frameRate);
		bool Update();
		void RegisterWindow(Window *window);

	  private:
		void InitializeSensors();

		void HandleEvent(SDL_Event *event);
		void ProcessClipboardEvent(SDL_Event *event);
		void ProcessDropEvent(SDL_Event *event);
		void ProcessGamepadEvent(SDL_Event *event);
		void ProcessJoystickEvent(SDL_Event *event);
		void ProcessKeyEvent(SDL_Event *event);
		void ProcessMouseEvent(SDL_Event *event);
		void ProcessSensorEvent(SDL_Event *event);
		void ProcessTextEvent(SDL_Event *event);
		void ProcessTouchEvent(SDL_Event *event);
		void ProcessWindowEvent(SDL_Event *event);

		void RenderFrame();
		void FramePacer();

		static bool HandleAppLifecycleEvent(void *userdata, SDL_Event *event);
#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
		static bool HandleEventWatcher(void *userdata, SDL_Event *event);
#endif
#ifdef IPHONE
		static void HandleAppAnimationCallback(void *userdata);
#endif

		static Application *currentApplication;
	};

} // namespace lime
