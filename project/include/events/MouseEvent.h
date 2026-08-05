#pragma once

#include <hx/CFFIPrime.h>
#include <stdint.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum MouseEventType
	{

		MOUSE_DOWN,
		MOUSE_UP,
		MOUSE_MOVE,
		MOUSE_WHEEL

	};

	struct MouseEvent
	{
		int button;
		double movementX;
		double movementY;
		MouseEventType type;
		int windowID;
		double x;
		double y;
		int clickCount;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		MouseEvent();

		static void Dispatch(MouseEvent *event);
	};

} // namespace lime