#include <events/ApplicationEvent.h>
#include <system/CFFI.h>


namespace lime {


	ValuePointer* ApplicationEvent::callback = 0;
	ValuePointer* ApplicationEvent::eventObject = 0;


	ApplicationEvent::ApplicationEvent () {

		deltaTime = 0.0;
		type = UPDATE;

	}


	void ApplicationEvent::Dispatch (ApplicationEvent* event) {

		if (ApplicationEvent::callback) {

			if (ApplicationEvent::eventObject->IsCFFIValue ()) {

				value object = (value)ApplicationEvent::eventObject->Get ();

				alloc_field (object, val_id ("deltaTime"), alloc_float (event->deltaTime));
				alloc_field (object, val_id ("type"), alloc_int (event->type));

			} else {

				ApplicationEvent* eventObject = (ApplicationEvent*)ApplicationEvent::eventObject->Get ();

				eventObject->deltaTime = event->deltaTime;
				eventObject->type = event->type;

			}

			ApplicationEvent::callback->Call ();

		}

	}


}