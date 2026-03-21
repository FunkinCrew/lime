#include "SDLJoystick.h"


namespace lime {


	std::map<int, int> joystickIDs;
	std::map<int, SDL_Joystick*> joysticks;


	bool SDLJoystick::Connect (int deviceID) {

		SDL_Joystick* joystick = SDL_OpenJoystick (deviceID);

		if (!joystick)
			return false;

		int id = SDL_GetJoystickID (joystick);
		joysticks[id] = joystick;
		joystickIDs[deviceID] = id;
		return true;

	}


	bool SDLJoystick::Disconnect (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return false;

		SDL_CloseJoystick (it->second);

		joysticks.erase (it);

		for (auto iter = joystickIDs.begin (); iter != joystickIDs.end (); ++iter) {

			if (iter->second == id) {

				joystickIDs.erase (iter);
				break;

			}

		}

		return true;

	}


	int SDLJoystick::GetInstanceID (int deviceID) {

		auto it = joystickIDs.find (deviceID);

		if (it == joystickIDs.end ())
			return -1;

		return it->second;

	}


	char* Joystick::GetDeviceGUID (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return nullptr;

		char* guid = new char[64];
		SDL_GUIDToString (SDL_GetJoystickGUID (it->second), guid, 64);
		return guid;

	}


	const char* Joystick::GetDeviceName (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return nullptr;

		return SDL_GetJoystickName (it->second);

	}


	int Joystick::GetNumAxes (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return 0;

		return SDL_GetNumJoystickAxes (it->second);

	}


	int Joystick::GetNumButtons (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return 0;

		return SDL_GetNumJoystickButtons (it->second);

	}


	int Joystick::GetNumHats (int id) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return 0;

		return SDL_GetNumJoystickHats (it->second);

	}


	void Joystick::Rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return;

		lowFrequencyRumble = (lowFrequencyRumble < 0.0) ? 0.0 : (lowFrequencyRumble > 1.0) ? 1.0 : lowFrequencyRumble;
		highFrequencyRumble = (highFrequencyRumble < 0.0) ? 0.0 : (highFrequencyRumble > 1.0) ? 1.0 : highFrequencyRumble;

		SDL_RumbleJoystick (it->second, static_cast<Uint16> (lowFrequencyRumble * 0xFFFF), static_cast<Uint16> (highFrequencyRumble * 0xFFFF), duration);

	}


	void Joystick::SetLED (int id, int red, int green, int blue) {

		auto it = joysticks.find (id);

		if (it == joysticks.end ())
			return;

		red = (red < 0) ? 0 : (red > 255) ? 255 : red;
		green = (green < 0) ? 0 : (green > 255) ? 255 : green;
		blue = (blue < 0) ? 0 : (blue > 255) ? 255 : blue;

		SDL_SetJoystickLED (it->second, red, green, blue);

	}


}
