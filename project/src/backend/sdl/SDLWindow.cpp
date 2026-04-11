#include "SDLWindow.h"
#include "SDLApplication.h"
#include "system/System.h"
#include "../../bindings/opengl/OpenGLBindings.h"

#include <vector>
#include <cstring>


namespace lime {


	static SystemCursor currentCursor = DEFAULT;


	SDLWindow::SDLWindow (Application* application, int width, int height, int flags, const char* title) {

		context = 0;

		currentApplication = application;

		this->flags = flags;

		int sdlWindowFlags = SDL_WINDOW_OPENGL;

		if (flags & WINDOW_FLAG_FULLSCREEN) sdlWindowFlags |= SDL_WINDOW_FULLSCREEN;
		if (flags & WINDOW_FLAG_RESIZABLE) sdlWindowFlags |= SDL_WINDOW_RESIZABLE;
		if (flags & WINDOW_FLAG_TRANSPARENT) sdlWindowFlags |= SDL_WINDOW_TRANSPARENT;
		if (flags & WINDOW_FLAG_BORDERLESS) sdlWindowFlags |= SDL_WINDOW_BORDERLESS;
		if (flags & WINDOW_FLAG_ALLOW_HIGHDPI) sdlWindowFlags |= SDL_WINDOW_HIGH_PIXEL_DENSITY;
		if (flags & WINDOW_FLAG_HIDDEN) sdlWindowFlags |= SDL_WINDOW_HIDDEN;
		if (flags & WINDOW_FLAG_MINIMIZED) sdlWindowFlags |= SDL_WINDOW_MINIMIZED;
		if (flags & WINDOW_FLAG_MAXIMIZED) sdlWindowFlags |= SDL_WINDOW_MAXIMIZED;

		#ifndef EMSCRIPTEN
		if (flags & WINDOW_FLAG_ALWAYS_ON_TOP) sdlWindowFlags |= SDL_WINDOW_ALWAYS_ON_TOP;
		#endif

		#ifdef LIME_OPENGL_GLES2
		SDL_GL_SetAttribute (SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
		SDL_GL_SetAttribute (SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute (SDL_GL_CONTEXT_MINOR_VERSION, 0);
		#endif

		#ifdef LIME_OPENGL_GL
		// TODO: Use OpenGL 3.3 Core on Desktop
		#endif

		if (flags & WINDOW_FLAG_DEPTH_BUFFER) {

			SDL_GL_SetAttribute (SDL_GL_DEPTH_SIZE, 32 - ((flags & WINDOW_FLAG_STENCIL_BUFFER) ? 8 : 0));

		}

		if (flags & WINDOW_FLAG_STENCIL_BUFFER) {

			SDL_GL_SetAttribute (SDL_GL_STENCIL_SIZE, 8);

		}

		if (flags & WINDOW_FLAG_HW_AA_HIRES) {

			SDL_GL_SetAttribute (SDL_GL_MULTISAMPLEBUFFERS, true);
			SDL_GL_SetAttribute (SDL_GL_MULTISAMPLESAMPLES, 4);

		} else if (flags & WINDOW_FLAG_HW_AA) {

			SDL_GL_SetAttribute (SDL_GL_MULTISAMPLEBUFFERS, true);
			SDL_GL_SetAttribute (SDL_GL_MULTISAMPLESAMPLES, 2);

		}

		if (flags & WINDOW_FLAG_COLOR_DEPTH_32_BIT) {

			SDL_GL_SetAttribute (SDL_GL_RED_SIZE, 8);
			SDL_GL_SetAttribute (SDL_GL_GREEN_SIZE, 8);
			SDL_GL_SetAttribute (SDL_GL_BLUE_SIZE, 8);
			SDL_GL_SetAttribute (SDL_GL_ALPHA_SIZE, 8);

		} else {

			SDL_GL_SetAttribute (SDL_GL_RED_SIZE, 5);
			SDL_GL_SetAttribute (SDL_GL_GREEN_SIZE, 6);
			SDL_GL_SetAttribute (SDL_GL_BLUE_SIZE, 5);

		}

		sdlWindow = SDL_CreateWindow (title, width, height, sdlWindowFlags);

		if (!sdlWindow) {

			#if defined(IPHONE) || defined(APPLETV)
			printf ("Could not create SDL Window: %s\n", SDL_GetError ());
			#else
			SDL_ShowSimpleMessageBox (SDL_MESSAGEBOX_ERROR, "Could not create SDL Window", SDL_GetError (), NULL);
			#endif

			return;

		}

		context = SDL_GL_CreateContext (sdlWindow);

		if (context && SDL_GL_MakeCurrent (sdlWindow, context)) {

			SetVSyncMode ((flags & WINDOW_FLAG_VSYNC) ? WINDOW_VSYNC_ON : WINDOW_VSYNC_OFF);

			OpenGLBindings::Init ();

			#if defined(IPHONE) || defined(APPLETV)
			SDL_PropertiesID props = SDL_GetWindowProperties(sdlWindow);
			OpenGLBindings::defaultFramebuffer = (int)SDL_GetNumberProperty(props, SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER, 0);
			OpenGLBindings::defaultRenderbuffer = (int)SDL_GetNumberProperty(props, SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER, 0);
			#endif

			((SDLApplication*)currentApplication)->RegisterWindow (this);

		} else {

			#if defined(IPHONE) || defined(APPLETV)
			printf ("Could not create SDL GL Context: %s\n", SDL_GetError ());
			#else
			SDL_ShowSimpleMessageBox (SDL_MESSAGEBOX_ERROR, "Could not create SDL GL Context", SDL_GetError (), sdlWindow);
			#endif

			if (sdlWindow) {

				SDL_DestroyWindow (sdlWindow);
				sdlWindow = 0;

			}

			if (context) {

				SDL_GL_DestroyContext (context);
				context = 0;

			}

		}

	}


	SDLWindow::~SDLWindow () {

		if (sdlWindow) {

			SDL_DestroyWindow (sdlWindow);
			sdlWindow = 0;

		}

		if (context) {

			SDL_GL_DestroyContext (context);
			context = 0;

		}

	}


	int SDLWindow::Alert (int type, const char* message, const char* title, const char** buttons, int count) {

		SDL_MessageBoxFlags flags = SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT;

		switch (type)
		{
			case 0:
				flags |= SDL_MESSAGEBOX_ERROR;
				break;

			case 1:
				flags |= SDL_MESSAGEBOX_WARNING;
				break;

			case 2:
				flags |= SDL_MESSAGEBOX_INFORMATION;
				break;

		}

		SDL_MessageBoxData data;
		SDL_zero (data);
		data.flags = flags;
		data.title = title;
		data.message = message;
		data.window = sdlWindow;

		std::vector<SDL_MessageBoxButtonData> sdlButtons;

		sdlButtons.reserve (count);

		if (count == 1) {

			SDL_MessageBoxButtonData button;
			button.flags = SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT;
			button.buttonID = 0;
			button.text = buttons[0];
			sdlButtons.push_back (button);

		} else {

			for (int i = 0; i < count; ++i) {

				SDL_MessageBoxButtonData button;
				SDL_zero (button);
				button.buttonID = i;
				button.text = buttons[i];
				sdlButtons.push_back (button);

			}

		}

		data.numbuttons = sdlButtons.size ();
		data.buttons = sdlButtons.data ();

		int buttonID;

		if (!SDL_ShowMessageBox (&data, &buttonID)) {

			buttonID = -1;

		}

		return buttonID;

	}


	bool SDLWindow::SetVSyncMode (int mode) {

		return SDL_GL_SetSwapInterval (mode);

	}


	void SDLWindow::Close () {

		if (sdlWindow) {

			SDL_DestroyWindow (sdlWindow);
			sdlWindow = 0;

		}

	}


	bool SDLWindow::SetVisible (bool visible) {

		if (visible) {

			SDL_ShowWindow (sdlWindow);

		} else {

			SDL_HideWindow (sdlWindow);

		}

		return !(SDL_GetWindowFlags (sdlWindow) & SDL_WINDOW_HIDDEN);

	}


	void SDLWindow::ContextFlip () {

		if (context) {

			SDL_GL_SwapWindow (sdlWindow);

		}

	}


	void SDLWindow::ContextMakeCurrent () {

		if (sdlWindow && context) {

			SDL_GL_MakeCurrent (sdlWindow, context);

		}

	}


	void SDLWindow::Focus () {

		SDL_RaiseWindow (sdlWindow);

	}

	void* SDLWindow::GetHandle () {

		SDL_PropertiesID props = SDL_GetWindowProperties(sdlWindow);

		#if defined(SDL_VIDEO_DRIVER_WINDOWS)
			void* hwnd = nullptr;
			SDL_GetPointerProperty(props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, &hwnd);
			return hwnd;
		#elif defined(SDL_VIDEO_DRIVER_X11)
			unsigned long x11win = 0;
			SDL_GetNumberProperty(props, SDL_PROP_WINDOW_X11_WINDOW_NUMBER, &x11win);
			return (void*)(uintptr_t)x11win;
		#elif defined(SDL_VIDEO_DRIVER_WAYLAND)
			void* wlSurface = nullptr;
			SDL_GetPointerProperty(props, SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER, &wlSurface);
			return wlSurface;
		#elif defined(SDL_VIDEO_DRIVER_ANDROID)
			void* native = nullptr;
			SDL_GetPointerProperty(props, SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER, &native);
			return native;
		#elif defined(SDL_VIDEO_DRIVER_COCOA)
			void* cocoa = nullptr;
			SDL_GetPointerProperty(props, SDL_PROP_WINDOW_COCOA_WINDOW_POINTER, &cocoa);
			return cocoa;
		#else
			return nullptr;
		#endif

	}

	void* SDLWindow::GetContext () {

		return context;

	}


	int SDLWindow::GetDisplay () {

		return SDL_GetDisplayForWindow (sdlWindow);

	}


	void SDLWindow::GetDisplayMode (DisplayMode* displayMode) {

		const SDL_DisplayMode *mode = SDL_GetDesktopDisplayMode (SDL_GetDisplayForWindow (sdlWindow));

		displayMode->width = mode->w;
		displayMode->height = mode->h;

		switch (mode->format) {

			case SDL_PIXELFORMAT_ARGB8888:

				displayMode->pixelFormat = ARGB32;
				break;

			case SDL_PIXELFORMAT_BGRA8888:
			case SDL_PIXELFORMAT_BGRX8888:

				displayMode->pixelFormat = BGRA32;
				break;

			default:

				displayMode->pixelFormat = RGBA32;

		}

		displayMode->refreshRate = mode->refresh_rate;

	}


	int SDLWindow::GetHeight () {

		int width;
		int height;

		SDL_GetWindowSizeInPixels (sdlWindow, &width, &height);

		return height;

	}


	uint32_t SDLWindow::GetID () {

		return SDL_GetWindowID (sdlWindow);

	}


	bool SDLWindow::GetMouseLock () {

		return SDL_GetWindowRelativeMouseMode (sdlWindow);

	}


	float SDLWindow::GetOpacity () {

		return SDL_GetWindowOpacity (sdlWindow);

	}


	double SDLWindow::GetScale () {

		return 1 /* SDL_GetWindowDisplayScale (sdlWindow) */;

	}


	bool SDLWindow::GetTextInputEnabled () {

		return SDL_TextInputActive (sdlWindow);

	}


	int SDLWindow::GetWidth () {

		int width;
		int height;

		SDL_GetWindowSizeInPixels (sdlWindow, &width, &height);

		return width;

	}


	int SDLWindow::GetX () {

		int x;
		int y;

		SDL_GetWindowPosition (sdlWindow, &x, &y);

		return x;

	}


	int SDLWindow::GetY () {

		int x;
		int y;

		SDL_GetWindowPosition (sdlWindow, &x, &y);

		return y;

	}


	void SDLWindow::Move (int x, int y) {

		SDL_SetWindowPosition (sdlWindow, x, y);

	}


	void SDLWindow::ReadPixels (ImageBuffer *buffer, Rectangle *rect) {

		if (context) {

			// TODO

		}

	}


	void SDLWindow::Resize (int width, int height) {

		SDL_SetWindowSize (sdlWindow, width, height);

	}


	void SDLWindow::SetMinimumSize (int width, int height) {

		SDL_SetWindowMinimumSize (sdlWindow, width, height);

	}


	void SDLWindow::SetMaximumSize (int width, int height) {

		SDL_SetWindowMaximumSize (sdlWindow, width, height);

	}


	bool SDLWindow::SetBorderless (bool borderless) {

		SDL_SetWindowBordered (sdlWindow, !borderless);
		return borderless;

	}


	void SDLWindow::SetCursor (SystemCursor cursor) {

		if (cursor != currentCursor) {

			if (currentCursor == HIDDEN) {

				SDL_ShowCursor ();

			}

			switch (cursor) {

				case HIDDEN:

					SDL_HideCursor ();
					break;

				default:

					SDL_SetCursor ((SDL_Cursor*)Cursor::GetSystemCursor (cursor));
					break;

			}

			currentCursor = cursor;

		}

	}


	void SDLWindow::SetDisplayMode (DisplayMode* displayMode) {

		SDL_PixelFormat pixelFormat;

		switch (displayMode->pixelFormat) {

			case ARGB32:

				pixelFormat = SDL_PIXELFORMAT_ARGB8888;
				break;

			case BGRA32:

				pixelFormat = SDL_PIXELFORMAT_BGRA8888;
				break;

			default:

				pixelFormat = SDL_PIXELFORMAT_RGBA8888;

		}

		SDL_DisplayMode mode = { static_cast<SDL_DisplayID>(GetDisplay()), pixelFormat, displayMode->width, displayMode->height, (float)(SDL_GetDesktopDisplayMode(1)->pixel_density), (float)(displayMode->refreshRate), 0, 0 };

		if (SDL_SetWindowFullscreenMode (sdlWindow, &mode)) {

			if (SDL_GetWindowFlags (sdlWindow) & SDL_WINDOW_FULLSCREEN) {

				SDL_SetWindowFullscreen (sdlWindow, true);

			}

		}

	}


	bool SDLWindow::SetFullscreen (bool fullscreen) {

		SDL_SetWindowFullscreen (sdlWindow, fullscreen);
		return fullscreen;

	}

	void SDLWindow::SetIcon (ImageBuffer *imageBuffer) {

		SDL_PixelFormat format = SDL_GetPixelFormatForMasks (imageBuffer->bitsPerPixel, 0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000);

		SDL_Surface *surface = SDL_CreateSurfaceFrom(imageBuffer->width, imageBuffer->height, format, imageBuffer->data->buffer->b, imageBuffer->Stride ());

		if (surface) {

			SDL_SetWindowIcon (sdlWindow, surface);
			SDL_DestroySurface (surface);

		}

	}


	bool SDLWindow::SetMaximized (bool maximized) {

		if (maximized) {

			SDL_MaximizeWindow (sdlWindow);

		} else {

			SDL_RestoreWindow (sdlWindow);

		}

		return maximized;

	}


	bool SDLWindow::SetMinimized (bool minimized) {

		if (minimized) {

			SDL_MinimizeWindow (sdlWindow);

		} else {

			SDL_RestoreWindow (sdlWindow);

		}

		return minimized;

	}


	void SDLWindow::SetMouseLock (bool mouseLock) {

		if (mouseLock) {

			SDL_SetWindowRelativeMouseMode (sdlWindow, true);

		} else {

			SDL_SetWindowRelativeMouseMode (sdlWindow, false);

		}

	}


	void SDLWindow::SetOpacity (float opacity) {

		SDL_SetWindowOpacity (sdlWindow, opacity);

	}


	bool SDLWindow::SetResizable (bool resizable) {

		#ifndef EMSCRIPTEN

		if (resizable) {

			SDL_SetWindowResizable (sdlWindow, true);

		} else {

			SDL_SetWindowResizable (sdlWindow, false);

		}

		return (SDL_GetWindowFlags (sdlWindow) & SDL_WINDOW_RESIZABLE);

		#else

		return resizable;

		#endif

	}


	void SDLWindow::SetTextInputEnabled (bool enabled) {

		if (enabled) {

			SDL_StartTextInput (sdlWindow);

		} else {

			SDL_StopTextInput (sdlWindow);

		}

	}


	void SDLWindow::SetTextInputRect (Rectangle * rect) {

		SDL_Rect bounds = { 0, 0, 0, 0 };

		if (rect) {

			bounds.x = rect->x;
			bounds.y = rect->y;
			bounds.w = rect->width;
			bounds.h = rect->height;

		}

		SDL_SetTextInputArea(sdlWindow, &bounds, 0);
	}


	const char* SDLWindow::SetTitle (const char* title) {

		SDL_SetWindowTitle (sdlWindow, title);

		return title;

	}


	bool SDLWindow::SetAlwaysOnTop (bool alwaysOnTop) {

		SDL_SetWindowAlwaysOnTop (sdlWindow, alwaysOnTop);

		return alwaysOnTop;

	}

	void SDLWindow::WarpMouse (int x, int y) {

		SDL_WarpMouseInWindow (sdlWindow, x, y);

	}


	Window* MakeWindow (Application* application, int width, int height, int flags, const char* title) {

		return new SDLWindow (application, width, height, flags, title);

	}


}
