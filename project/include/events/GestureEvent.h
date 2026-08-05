#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum GestureState
	{

		GESTURE_START = 0,
		GESTURE_MOVE = 1,
		GESTURE_END = 2,
		GESTURE_CANCEL = 3

	};

	struct GestureEvent
	{
		double x;
		double y;
		GestureState state;
		double magnification;
		double rotation;
		double panTranslationX;
		double panTranslationY;
		double panVelocityX;
		double panVelocityY;
		double scrollX;
		double scrollY;
		double momentumScrollX;
		double momentumScrollY;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		GestureEvent();

		static void Dispatch(GestureEvent *event);
	};

} // namespace lime
