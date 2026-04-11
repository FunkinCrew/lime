#include <system/CFFI.h>
#include <events/ClipboardEvent.h>


namespace lime {


	ValuePointer* ClipboardEvent::callback = 0;
	ValuePointer* ClipboardEvent::eventObject = 0;


	ClipboardEvent::ClipboardEvent () {

		type = CLIPBOARD_UPDATE;

	}


	void ClipboardEvent::Dispatch (ClipboardEvent* event) {

		if (ClipboardEvent::callback) {

			if (ClipboardEvent::eventObject->IsCFFIValue ()) {

				value object = (value)ClipboardEvent::eventObject->Get ();

				alloc_field (object, val_id ("type"), alloc_int (event->type));

			} else {

				ClipboardEvent* eventObject = (ClipboardEvent*)ClipboardEvent::eventObject->Get ();

				eventObject->type = event->type;

			}

			ClipboardEvent::callback->Call ();

		}

	}


}