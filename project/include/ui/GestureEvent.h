#ifndef LIME_UI_GESTURE_EVENT_H
#define LIME_UI_GESTURE_EVENT_H


#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <stdint.h>


namespace lime {

	enum GestureState
	{
		GESTURE_BEGAN = 0,
		GESTURE_CHANGED = 1,
		GESTURE_ENDED = 2,
		GESTURE_CANCELLED = 3
	};


	struct GestureEvent {

		hl_type* t;
		int id;
		int timestamp;
		double dTheta;
		double dDist;
		double x;
		double y;
		int numFingers;
		GestureState state;

		// for mac
		double magnification;
		double rotation;
		double panTranslationX;
		double panTranslationY;
		double panVelocityX;
		double panVelocityY;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		GestureEvent ();

		static void Dispatch (GestureEvent* event);

	};

}


#endif