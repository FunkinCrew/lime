#pragma once


#include <SDL3/SDL.h>
#include <ui/Gamepad.h>
#include <map>


namespace lime {


	class SDLGamepad {

		public:

			static bool Connect (int deviceID);
			static bool Disconnect (int id);
			static int GetInstanceID (int deviceID);

	};


}