#pragma once

#include <hx/CFFIPrime.h>
#include <stdint.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum TouchEventType
	{

		TOUCH_START,
		TOUCH_END,
		TOUCH_MOVE

	};

	struct TouchEvent
	{
		int device;
		double dx;
		double dy;
		int id;
		double pressure;
		TouchEventType type;
		double x;
		double y;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		TouchEvent();

		static void Dispatch(TouchEvent *event);
	};

} // namespace lime