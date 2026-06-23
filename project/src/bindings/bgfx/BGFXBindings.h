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
#include <bgfx/platform.h>
#include <shaderc/shaderc.h>
#include <SDL3/SDL.h>


namespace lime {


	class BGFXBindings {

		public:

			static SDL_Window* defaultWindow;

			static bool Init (SDL_Window* sdlWindow);

			static void ResetWindow (int width, int height);

			static void Shutdown ();

	};


}
