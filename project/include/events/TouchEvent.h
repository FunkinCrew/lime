#pragma once

#include <stdint.h>
#include <system/CFFI.h>

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
		double timestamp;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		TouchEvent();

		static void Dispatch(TouchEvent *event);
	};

} // namespace lime