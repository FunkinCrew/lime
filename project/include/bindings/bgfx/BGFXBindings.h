#pragma once

#include <SDL3/SDL.h>

#undef main

namespace lime
{

	class BGFXBindings
	{
	  public:
		static SDL_Window *defaultWindow;

		static bool Init(SDL_Window *sdlWindow);

		static void SetMetalLayerComposited(bool composit);

		static void ResetWindow(int width, int height);

		static void Shutdown();
	};

} // namespace lime
