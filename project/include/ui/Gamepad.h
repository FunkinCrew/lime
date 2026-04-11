#pragma once

namespace lime {


	class Gamepad {

		public:

			static bool Connect (int deviceID);
			static bool Disconnect (int id);
			static int GetInstanceID (int deviceID);
			static void AddMapping (const char* content);
			static char* GetDeviceGUID (int id);
			static const char* GetDeviceName (int id);
			static void Rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration);
			static void SetLED (int id, int red, int green, int blue);

	};


}