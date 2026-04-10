#pragma once


#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <stdint.h>


namespace lime {


	enum KeyEventType {

		KEY_DOWN,
		KEY_UP

	};


	struct KeyEvent {

		hl_type* t;
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