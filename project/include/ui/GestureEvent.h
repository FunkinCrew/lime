#ifndef LIME_UI_GESTURE_EVENT_H
#define LIME_UI_GESTURE_EVENT_H


#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <stdint.h>


namespace lime {

	// apple
	// enum GestureState
	// {
	// 	POSSIBLE,
	// 	BEGAN,
	// 	CHANGED,
	// 	ENDED,
	// 	CANCELLED,
	// 	FAILED,
	// 	// RECOGNIZED = ENDED
	// };


	struct GestureEvent {

		hl_type* t;
		//Uint32
		int id;
		int timestamp;
		double dTheta;
		double dDist;
		double x;
		double y;
		//Uint16
		int numFingers;
		// int rotation;
		// int magnification;
		int state;
		double magnification; // for mac
		double rotation; // for mac

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		GestureEvent ();

		static void Dispatch (GestureEvent* event);

	};

}


#endif