#ifndef LIME_UI_GESTURE_H
#define LIME_UI_GESTURE_H

#include <functional>
#include <SDL.h>

using CallbackFunc = std::function<void(double, int, double, double)>;

typedef struct GestureCallbacks
{
	CallbackFunc onRotEvent;
	CallbackFunc onMagEvent;
	// void (*onRotEvent)(int rotation, int state);
	// void (*onMagEvent)(int magnification, int state);

} GestureCallbacks;



namespace lime {

	void RegisterCallback(const GestureCallbacks* callbacks, SDL_Window* window);
	// class Gesture {

	// 	public:

			// static void RegisterCallback (GestureCallbacks* callbacks);

	// };


}


#endif