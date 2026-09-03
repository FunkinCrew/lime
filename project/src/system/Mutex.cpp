#include <system/Mutex.h>

namespace lime
{

	Mutex::Mutex()
	{
		mutex = SDL_CreateMutex();
	}

	Mutex::~Mutex()
	{
		if (mutex)
		{
			SDL_DestroyMutex(mutex);
		}
	}

	void Mutex::Lock() const
	{
		if (mutex)
		{
			SDL_LockMutex(mutex);
		}
	}

	void Mutex::Unlock() const
	{
		if (mutex)
		{
			SDL_UnlockMutex(mutex);
		}
	}

} // namespace lime