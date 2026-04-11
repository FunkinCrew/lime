#include <SDL3/SDL.h>
#include <ui/Gamepad.h>
#include <map>


namespace lime {


	std::map<int, SDL_Gamepad*> gameControllers;
	std::map<int, int> gameControllerIDs;


	bool Gamepad::Connect (int deviceID) {

		if (!SDL_IsGamepad (deviceID))
			return false;

		SDL_Gamepad* gameController = SDL_OpenGamepad (deviceID);

		if (!gameController)
			return false;

		int id = SDL_GetGamepadID (gameController);
		gameControllers[id] = gameController;
		gameControllerIDs[deviceID] = id;
		return true;

	}


	bool Gamepad::Disconnect (int id) {

		auto it = gameControllers.find (id);

		if (it == gameControllers.end ())
			return false;

		SDL_CloseGamepad(it->second);

		gameControllers.erase(it);

		for (auto iter = gameControllerIDs.begin (); iter != gameControllerIDs.end (); ++iter) {

			if (iter->second == id) {

				gameControllerIDs.erase (iter);
				break;

			}

		}

		return true;

	}


	int Gamepad::GetInstanceID (int deviceID) {

		auto it = gameControllerIDs.find (deviceID);

		if (it == gameControllerIDs.end ())
			return -1;

		return it->second;

	}


	void Gamepad::AddMapping (const char* content) {

		SDL_AddGamepadMapping(content);

	}


	char* Gamepad::GetDeviceGUID (int id) {

		auto it = gameControllers.find (id);

		if (it == gameControllers.end ())
			return nullptr;

		char* guid = new char[64];
		SDL_GUIDToString (SDL_GetGamepadGUIDForID (id), guid, 64);
		return guid;

	}


	const char* Gamepad::GetDeviceName (int id) {

		auto it = gameControllers.find (id);

		if (it == gameControllers.end ())
			return nullptr;

		return SDL_GetGamepadName (it->second);

	}


	void Gamepad::Rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration) {

		auto it = gameControllers.find (id);

		if (it == gameControllers.end ())
			return;

		lowFrequencyRumble = (lowFrequencyRumble < 0.0) ? 0.0 : (lowFrequencyRumble > 1.0) ? 1.0 : lowFrequencyRumble;
		highFrequencyRumble = (highFrequencyRumble < 0.0) ? 0.0 : (highFrequencyRumble > 1.0) ? 1.0 : highFrequencyRumble;

		SDL_RumbleGamepad (it->second, static_cast<Uint16> (lowFrequencyRumble * 0xFFFF), static_cast<Uint16> (highFrequencyRumble * 0xFFFF), duration);

	}


	void Gamepad::SetLED (int id, int red, int green, int blue) {

		auto it = gameControllers.find (id);

		if (it == gameControllers.end ())
			return;

		red = (red < 0) ? 0 : (red > 255) ? 255 : red;
		green = (green < 0) ? 0 : (green > 255) ? 255 : green;
		blue = (blue < 0) ? 0 : (blue > 255) ? 255 : blue;

		SDL_SetGamepadLED (it->second, red, green, blue);

	}


}
