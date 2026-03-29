#include "SDLJoystick.h"


namespace lime {


	std::map<int, int> joystickIDs = std::map<int, int> ();
	std::map<int, SDL_Joystick*> joysticks = std::map<int, SDL_Joystick*> ();


	bool SDLJoystick::Connect (int deviceID) {

		SDL_Joystick* joystick = SDL_JoystickOpen (deviceID);
		int id = SDL_JoystickInstanceID (joystick);

		if (joystick) {

			joysticks[id] = joystick;
			joystickIDs[deviceID] = id;
			return true;

		}

		return false;

	}


	bool SDLJoystick::Disconnect (int id) {

		if (joysticks.find (id) != joysticks.end ()) {

			SDL_Joystick* joystick = joysticks[id];
			SDL_JoystickClose (joystick);
			joysticks.erase (id);
			return true;

		}

		return false;

	}


	int SDLJoystick::GetInstanceID (int deviceID) {

		return joystickIDs[deviceID];

	}


	const char* Joystick::GetDeviceGUID (int id) {

		char* guid = new char[64];
		SDL_JoystickGetGUIDString (SDL_JoystickGetGUID (joysticks[id]), guid, 64);
		return guid;

	}


	const char* Joystick::GetDeviceName (int id) {

		return SDL_JoystickName (joysticks[id]);

	}


	int Joystick::GetNumAxes (int id) {

		return SDL_JoystickNumAxes (joysticks[id]);

	}


	int Joystick::GetNumButtons (int id) {

		return SDL_JoystickNumButtons (joysticks[id]);

	}


	int Joystick::GetNumHats (int id) {

		return SDL_JoystickNumHats (joysticks[id]);

	}


}
