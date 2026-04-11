#pragma once


#include <SDL3/SDL.h>


#include <graphics/ImageBuffer.h>
#include <ui/Cursor.h>
#include <ui/Window.h>


namespace lime {


	class SDLWindow : public Window {

		public:

			SDLWindow (Application* application, int width, int height, int flags, const char* title);
			~SDLWindow ();

			virtual int Alert (int type, const char* message, const char* title, const char** buttons, int count);
			virtual bool SetVSyncMode (int mode);
			virtual void Close ();
			virtual void ContextFlip ();
			virtual void ContextMakeCurrent ();
			virtual void Focus ();
			virtual void* GetHandle ();
			virtual void* GetContext ();
			// virtual Cursor GetCursor ();
			virtual int GetDisplay ();
			virtual void GetDisplayMode (DisplayMode* displayMode);
			virtual int GetHeight ();
			virtual uint32_t GetID ();
			virtual bool GetMouseLock ();
			virtual float GetOpacity ();
			virtual double GetScale ();
			virtual bool GetTextInputEnabled ();
			virtual int GetWidth ();
			virtual int GetX ();
			virtual int GetY ();
			virtual void Move (int x, int y);
			virtual void ReadPixels (ImageBuffer *buffer, Rectangle *rect);
			virtual void Resize (int width, int height);
			virtual void SetMinimumSize (int width, int height);
			virtual void SetMaximumSize (int width, int height);
			virtual bool SetBorderless (bool borderless);
			virtual void SetCursor (SystemCursor cursor);
			virtual void SetDisplayMode (DisplayMode* displayMode);
			virtual bool SetFullscreen (bool fullscreen);
			virtual void SetIcon (ImageBuffer *imageBuffer);
			virtual bool SetMaximized (bool maximized);
			virtual bool SetMinimized (bool minimized);
			virtual void SetMouseLock (bool mouseLock);
			virtual void SetOpacity (float opacity);
			virtual bool SetResizable (bool resizable);
			virtual void SetTextInputEnabled (bool enabled);
			virtual void SetTextInputRect (Rectangle *rect);
			virtual const char* SetTitle (const char* title);
			virtual bool SetVisible (bool visible);
			virtual bool SetAlwaysOnTop (bool alwaysOnTop);
			virtual void WarpMouse (int x, int y);
			SDL_Window* sdlWindow;

		private:

			SDL_GLContext context;

	};


}