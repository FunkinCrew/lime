#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum OrientationEventType
	{

		DISPLAY_ORIENTATION_CHANGE,
		DEVICE_ORIENTATION_CHANGE

	};

	struct OrientationEvent
	{
		int orientation;
		int display;
		OrientationEventType type;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		OrientationEvent();

		static void Dispatch(OrientationEvent *event);
	};

} // namespace lime