#include <map>
#include <SDL3/SDL.h>
#include <ui/Gamepad.h>

namespace lime
{

	std::map<int, SDL_Gamepad *> gameControllers;

	bool Gamepad::Connect(int id)
	{
		if (!SDL_IsGamepad(id))
			return false;

		SDL_Gamepad *gameController = SDL_OpenGamepad(id);

		if (!gameController)
			return false;

		gameControllers[id] = gameController;

		return true;
	}

	bool Gamepad::Disconnect(int id)
	{
		auto it = gameControllers.find(id);

		if (it == gameControllers.end())
			return false;

		SDL_CloseGamepad(it->second);

		gameControllers.erase(it);

		return true;
	}

	void Gamepad::AddMapping(const char *content)
	{
		SDL_AddGamepadMapping(content);
	}

	char *Gamepad::GetDeviceGUID(int id)
	{
		auto it = gameControllers.find(id);

		if (it == gameControllers.end())
			return nullptr;

		char *guid = new char[64];
		SDL_GUIDToString(SDL_GetGamepadGUIDForID(id), guid, 64);
		return guid;
	}

	const char *Gamepad::GetDeviceName(int id)
	{
		auto it = gameControllers.find(id);

		if (it == gameControllers.end())
			return nullptr;

		return SDL_GetGamepadName(it->second);
	}

	void Gamepad::Rumble(int id, double lowFrequencyRumble, double highFrequencyRumble, int duration)
	{
		auto it = gameControllers.find(id);

		if (it == gameControllers.end())
			return;

		lowFrequencyRumble = (lowFrequencyRumble < 0.0) ? 0.0 : (lowFrequencyRumble > 1.0) ? 1.0 : lowFrequencyRumble;
		highFrequencyRumble = (highFrequencyRumble < 0.0) ? 0.0 : (highFrequencyRumble > 1.0) ? 1.0 : highFrequencyRumble;

		SDL_RumbleGamepad(it->second, static_cast<Uint16>(lowFrequencyRumble * 0xFFFF), static_cast<Uint16>(highFrequencyRumble * 0xFFFF), duration);
	}

	void Gamepad::SetLED(int id, int red, int green, int blue)
	{
		auto it = gameControllers.find(id);

		if (it == gameControllers.end())
			return;

		red = (red < 0) ? 0 : (red > 255) ? 255 : red;
		green = (green < 0) ? 0 : (green > 255) ? 255 : green;
		blue = (blue < 0) ? 0 : (blue > 255) ? 255 : blue;

		SDL_SetGamepadLED(it->second, red, green, blue);
	}

} // namespace lime
