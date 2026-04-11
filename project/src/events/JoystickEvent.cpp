#include <system/CFFI.h>
#include <events/JoystickEvent.h>


namespace lime {


	ValuePointer* JoystickEvent::callback = 0;
	ValuePointer* JoystickEvent::eventObject = 0;


	JoystickEvent::JoystickEvent () {

		id = 0;
		index = 0;
		eventValue = 0;
		x = 0;
		y = 0;
		type = JOYSTICK_AXIS_MOVE;

	}


	void JoystickEvent::Dispatch (JoystickEvent* event) {

		if (JoystickEvent::callback) {

			if (JoystickEvent::eventObject->IsCFFIValue ()) {

				value object = (value)JoystickEvent::eventObject->Get ();

				alloc_field (object, val_id ("id"), alloc_int (event->id));
				alloc_field (object, val_id ("index"), alloc_int (event->index));
				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("eventValue"), alloc_int (event->eventValue));
				alloc_field (object, val_id ("x"), alloc_float (event->x));
				alloc_field (object, val_id ("y"), alloc_float (event->y));

			} else {

				JoystickEvent* eventObject = (JoystickEvent*)JoystickEvent::eventObject->Get ();

				eventObject->id = event->id;
				eventObject->index = event->index;
				eventObject->type = event->type;
				eventObject->eventValue = event->eventValue;
				eventObject->x = event->x;
				eventObject->y = event->y;

			}

			JoystickEvent::callback->Call ();

		}

	}


}