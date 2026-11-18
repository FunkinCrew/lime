#pragma once

#include <system/CFFI.h>

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

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		OrientationEvent();

		static void Dispatch(OrientationEvent *event);
	};

} // namespace lime