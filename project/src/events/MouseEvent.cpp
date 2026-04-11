#include <system/CFFI.h>
#include <events/MouseEvent.h>


namespace lime {


	ValuePointer* MouseEvent::callback = 0;
	ValuePointer* MouseEvent::eventObject = 0;


	MouseEvent::MouseEvent () {

		button = 0;
		type = MOUSE_DOWN;
		windowID = 0;
		x = 0.0;
		y = 0.0;
		movementX = 0.0;
		movementY = 0.0;
		clickCount = 0;

	}


	void MouseEvent::Dispatch (MouseEvent* event) {

		if (MouseEvent::callback) {

			if (MouseEvent::eventObject->IsCFFIValue ()) {

				value object = (value)MouseEvent::eventObject->Get ();

				alloc_field (object, val_id ("button"), alloc_int (event->button));
				alloc_field (object, val_id ("movementX"), alloc_float (event->movementX));
				alloc_field (object, val_id ("movementY"), alloc_float (event->movementY));
				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("windowID"), alloc_int (event->windowID));
				alloc_field (object, val_id ("x"), alloc_float (event->x));
				alloc_field (object, val_id ("y"), alloc_float (event->y));
				alloc_field (object, val_id ("clickCount"), alloc_int (event->clickCount));

			} else {

				MouseEvent* eventObject = (MouseEvent*)MouseEvent::eventObject->Get ();

				eventObject->button = event->button;
				eventObject->movementX = event->movementX;
				eventObject->movementY = event->movementY;
				eventObject->type = event->type;
				eventObject->windowID = event->windowID;
				eventObject->x = event->x;
				eventObject->y = event->y;
				eventObject->clickCount = event->clickCount;

			}

			MouseEvent::callback->Call ();

		}

	}


}
