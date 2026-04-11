#include <system/CFFI.h>
#include <events/KeyEvent.h>


namespace lime {


	ValuePointer* KeyEvent::callback = 0;
	ValuePointer* KeyEvent::eventObject = 0;


	KeyEvent::KeyEvent () {

		keyCode = 0;
		modifier = 0;
		type = KEY_DOWN;
		windowID = 0;
		timestamp = 0.0;

	}


	void KeyEvent::Dispatch (KeyEvent* event) {

		if (KeyEvent::callback) {

			if (KeyEvent::eventObject->IsCFFIValue ()) {

				value object = (value)KeyEvent::eventObject->Get ();

				alloc_field (object, val_id ("keyCode"), alloc_float (event->keyCode));
				alloc_field (object, val_id ("modifier"), alloc_int (event->modifier));
				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("windowID"), alloc_int (event->windowID));
				alloc_field (object, val_id ("timestamp"), alloc_float (event->timestamp));

			} else {

				KeyEvent* eventObject = (KeyEvent*)KeyEvent::eventObject->Get ();

				eventObject->keyCode = event->keyCode;
				eventObject->modifier = event->modifier;
				eventObject->type = event->type;
				eventObject->windowID = event->windowID;
				eventObject->timestamp = event->timestamp;

			}

			KeyEvent::callback->Call ();

		}

	}


}