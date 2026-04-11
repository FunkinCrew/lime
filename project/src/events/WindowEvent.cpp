#include <system/CFFI.h>
#include <events/WindowEvent.h>


namespace lime {


	ValuePointer* WindowEvent::callback = 0;
	ValuePointer* WindowEvent::eventObject = 0;


	WindowEvent::WindowEvent () {

		type = WINDOW_ACTIVATE;

		width = 0;
		height = 0;
		windowID = 0;
		x = 0;
		y = 0;

	}


	void WindowEvent::Dispatch (WindowEvent* event) {

		if (WindowEvent::callback) {

			if (WindowEvent::eventObject->IsCFFIValue ()) {

				value object = (value)WindowEvent::eventObject->Get ();

				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("windowID"), alloc_int (event->windowID));

				switch (event->type) {

					case WINDOW_MOVE:

						alloc_field (object, val_id ("x"), alloc_int (event->x));
						alloc_field (object, val_id ("y"), alloc_int (event->y));
						break;

					case WINDOW_RESIZE:

						alloc_field (object, val_id ("width"), alloc_int (event->width));
						alloc_field (object, val_id ("height"), alloc_int (event->height));
						break;

					default: break;

				}

			} else {

				WindowEvent* eventObject = (WindowEvent*)WindowEvent::eventObject->Get ();

				eventObject->type = event->type;
				eventObject->windowID = event->windowID;

				switch (event->type) {

					case WINDOW_MOVE:

						eventObject->x = event->x;
						eventObject->y = event->y;
						break;

					case WINDOW_RESIZE:

						eventObject->width = event->width;
						eventObject->height = event->height;
						break;

					default: break;

				}

			}

			WindowEvent::callback->Call ();

		}

	}


}