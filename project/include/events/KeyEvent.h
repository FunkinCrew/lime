#pragma once


#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>
#include <stdint.h>


namespace lime {


	enum KeyEventType {

		KEY_DOWN,
		KEY_UP

	};


	struct KeyEvent {

		double keyCode;
		int modifier;
		KeyEventType type;
		int windowID;
		double timestamp;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		KeyEvent ();

		static void Dispatch (KeyEvent* event);

	};


}