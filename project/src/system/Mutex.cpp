#include <system/Mutex.h>
#include <SDL3/SDL.h>


namespace lime {


	Mutex::Mutex () {

		mutex = SDL_CreateMutex ();

	}


	Mutex::~Mutex () {

		if (mutex) {

			SDL_DestroyMutex ((SDL_Mutex*)mutex);

		}

	}


	void Mutex::Lock () const {

		if (mutex) {

			SDL_LockMutex ((SDL_Mutex*)mutex);

		}

	}


	bool Mutex::TryLock () const {

		return mutex ? SDL_TryLockMutex ((SDL_Mutex*)mutex) : false;

	}


	void Mutex::Unlock () const {

		if (mutex) {

			SDL_UnlockMutex ((SDL_Mutex*)mutex);

		}

	}


}