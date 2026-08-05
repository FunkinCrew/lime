#pragma once

#include <hx/CFFIPrime.h>
#include <stdint.h>
#include <system/ValuePointer.h>

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

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		KeyEvent();

		static void Dispatch(KeyEvent *event);
	};

} // namespace lime