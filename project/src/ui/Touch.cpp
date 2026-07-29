#include <SDL3/SDL.h>
#include <ui/Touch.h>

namespace lime {


	value Touch::GetDevices () {

		int count = 0;

		SDL_TouchID *devices = SDL_GetTouchDevices (&count);

		value result = alloc_array (count);

		for (int i = 0; i < count; i++) {

			val_array_set_i (result, i, alloc_int (devices[i]));

		}

		SDL_free (devices);

		return result;

	}


	const char* Touch::GetDeviceName (int id) {

		return SDL_GetTouchDeviceName (id);

	}


	int Touch::GetDeviceType (int id) {

		return SDL_GetTouchDeviceType (id);

	}


}
