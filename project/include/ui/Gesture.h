#ifndef LIME_UI_GESTURE_H
#define LIME_UI_GESTURE_H

#include <functional>
#include <SDL.h>
#include <ui/GestureEvent.h>

typedef struct ObjcPoint {

    double x;
    double y;

} ObjcPoint;

enum GestureRecognizerState
{

	GestureRecognizerStatePossible = 0,
    GestureRecognizerStateBegan = 1,
    GestureRecognizerStateChanged = 2,
    GestureRecognizerStateEnded = 3,
    GestureRecognizerStateCancelled = 4,
    GestureRecognizerStateFailed = 5,
    GestureRecognizerStateRecognized = GestureRecognizerStateEnded

};

typedef struct GestureCallbacks {

	std::function<void(GestureRecognizerState state, double rotation, ObjcPoint locationInView)> onRotationEvent;
	std::function<void(GestureRecognizerState state, double magnification, ObjcPoint locationInView)> onMagnificationEvent;
	std::function<void(GestureRecognizerState state, ObjcPoint translationInView, ObjcPoint velocityInView, ObjcPoint locationInView)> onPanEvent;

} GestureCallbacks;

namespace lime {


	class Gesture {

		public:

		static inline GestureState fromAppleEnum(GestureRecognizerState state)
		{
			if (state < 5 && state != 0)
				return (GestureState)(state - 1);

			return GESTURE_ENDED;
		}

		static void RegisterCallback(const GestureCallbacks* callbacks, SDL_Window* window);

	};


}

#endif