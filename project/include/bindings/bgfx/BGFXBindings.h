#pragma once

#ifdef min
#undef min
#endif
#ifdef max
#undef max
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <bgfx/bgfx.h>
#include <SDL3/SDL.h>
#include <shaderc/shaderc.h>

#undef main

namespace lime
{

	class BGFXBindings
	{
	  public:
		static SDL_Window *defaultWindow;

		static bool Init(SDL_Window *sdlWindow);

		static void ResetWindow(int width, int height);

		static void Shutdown();
	};

} // namespace lime
