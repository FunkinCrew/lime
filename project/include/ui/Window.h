#pragma once

#include <app/Application.h>
#include <graphics/ImageBuffer.h>
#include <hx/CFFIPrime.h>
#include <math/Rectangle.h>
#include <SDL3/SDL.h>
#include <stdint.h>
#include <system/DisplayMode.h>
#include <ui/Cursor.h>

namespace lime
{

	enum WindowVSyncMode
	{
		WINDOW_VSYNC_ADAPTIVE = -1,
		WINDOW_VSYNC_OFF = 0,
		WINDOW_VSYNC_ON = 1,
	};

	enum WindowFlags
	{
		WINDOW_FLAG_FULLSCREEN = 0x00000001,
		WINDOW_FLAG_TRANSPARENT = 0x00000002,
		WINDOW_FLAG_BORDERLESS = 0x00000004,
		WINDOW_FLAG_RESIZABLE = 0x00000008,
		WINDOW_FLAG_VSYNC = 0x00000010,
		WINDOW_FLAG_HW_AA = 0x00000020,
		WINDOW_FLAG_HW_AA_HIRES = 0x00000060,
		WINDOW_FLAG_ALLOW_SHADERS = 0x00000080,
		WINDOW_FLAG_REQUIRE_SHADERS = 0x00000100,
		WINDOW_FLAG_DEPTH_BUFFER = 0x00000200,
		WINDOW_FLAG_STENCIL_BUFFER = 0x00000400,
		WINDOW_FLAG_ALLOW_HIGHDPI = 0x00000800,
		WINDOW_FLAG_HIDDEN = 0x00001000,
		WINDOW_FLAG_MINIMIZED = 0x00002000,
		WINDOW_FLAG_MAXIMIZED = 0x00004000,
		WINDOW_FLAG_ALWAYS_ON_TOP = 0x00008000,
		WINDOW_FLAG_COLOR_DEPTH_32_BIT = 0x00010000
	};

	class Window
	{
	  public:
		Window(Application *application, int width, int height, int flags, const char *title);
		virtual ~Window();

		int Alert(int type, const char *message, const char *title, const char **buttons, int count);
		bool SetVSyncMode(int mode);
		void Close();
		void ContextFlip();
		void ContextMakeCurrent();
		void Focus();
		void *GetHandle();
		void *GetContext();
		int GetDisplay();
		void GetDisplayMode(DisplayMode *displayMode);
		int GetHeight();
		uint32_t GetID();
		bool GetMouseLock();
		float GetOpacity();
		double GetScale();
		bool GetTextInputEnabled();
		int GetWidth();
		int GetX();
		int GetY();
		void Move(int x, int y);
		void ReadPixels(ImageBuffer *buffer, Rectangle *rect);
		void Resize(int width, int height);
		void SetMinimumSize(int width, int height);
		void SetMaximumSize(int width, int height);
		bool SetBorderless(bool borderless);
		void SetCursor(SystemCursor cursor);
		void SetDisplayMode(DisplayMode *displayMode);
		bool SetFullscreen(bool fullscreen);
		void SetIcon(ImageBuffer *imageBuffer);
		bool SetMaximized(bool maximized);
		bool SetMinimized(bool minimized);
		void SetMouseLock(bool mouseLock);
		void SetOpacity(float opacity);
		bool SetResizable(bool resizable);
		void SetTextInputEnabled(bool enabled);
		void SetTextInputRect(Rectangle *rect);
		const char *SetTitle(const char *title);
		bool SetVisible(bool visible);
		bool SetAlwaysOnTop(bool alwaysOnTop);
		void WarpMouse(int x, int y);

		Application *currentApplication;
		int flags;
		SDL_Window *sdlWindow;

	  private:
		SDL_GLContext context;
	};

} // namespace lime
