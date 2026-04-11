#include <system/CFFI.h>
#include <events/DropEvent.h>


namespace lime {


	ValuePointer* DropEvent::callback = 0;
	ValuePointer* DropEvent::eventObject = 0;


	DropEvent::DropEvent () {

		data = 0;
		source = 0;
		windowID = 0;
		x = 0.0;
		y = 0.0;
		type = DROP_FILE;

	}


	void DropEvent::Dispatch (DropEvent* event) {

		if (DropEvent::callback) {

			if (DropEvent::eventObject->IsCFFIValue ()) {

				value object = (value)DropEvent::eventObject->Get ();

				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("windowID"), alloc_int (event->windowID));

				alloc_field (object, val_id ("x"), alloc_float (event->x));
				alloc_field (object, val_id ("y"), alloc_float (event->y));

				alloc_field (object, val_id ("data"), event->data ? alloc_string ((const char*)event->data) : alloc_null ());
				alloc_field (object, val_id ("source"), event->source ? alloc_string ((const char*)event->source) : alloc_null ());

			} else {

				DropEvent* eventObject = (DropEvent*)DropEvent::eventObject->Get ();

				eventObject->type = event->type;
				eventObject->windowID = event->windowID;
				eventObject->x = event->x;
				eventObject->y = event->y;

				int length;

				if (event->data) {

					int length = strlen ((const char*)event->data);
					char* data = (char*)malloc (length + 1);
					strcpy (data, (const char*)event->data);
					eventObject->data = (vbyte*)data;

				}

				if (event->source) {

					length = strlen ((const char*)event->source);
					char* source = (char*)malloc (length + 1);
					strcpy (source, (const char*)event->source);
					eventObject->source = (vbyte*)source;

				}

			}
			DropEvent::callback->Call ();

		}

	}


}