#ifndef LIME_UI_JOYSTICK_H
#define LIME_UI_JOYSTICK_H


namespace lime {


	class Joystick {

		public:

			static char* GetDeviceGUID (int id);
			static const char* GetDeviceName (int id);
			static int GetNumAxes (int id);
			static int GetNumButtons (int id);
			static int GetNumHats (int id);
			static void Rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration);
			static void SetLED (int id, int red, int green, int blue);

	};


}


#endif