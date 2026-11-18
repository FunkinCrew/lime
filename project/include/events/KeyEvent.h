#pragma once

#include <stdint.h>
#include <system/CFFI.h>

namespace lime
{

	enum KeyEventType
	{
		KEY_DOWN,
		KEY_UP
	};

	struct KeyEvent
	{
		double keyCode;
		int modifier;
		KeyEventType type;
		int windowID;
		double timestamp;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		KeyEvent();

		static void Dispatch(KeyEvent *event);
	};

} // namespace lime