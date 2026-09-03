#pragma once

#include <SDL3/SDL.h>

namespace lime
{

	class Mutex
	{
	  public:
		Mutex();
		~Mutex();

		void Lock() const;
		void Unlock() const;

	  private:
		SDL_Mutex *mutex;
	};

} // namespace lime