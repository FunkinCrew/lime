#include <system/CFFI.h>
#include <events/SensorEvent.h>


namespace lime {


	ValuePointer* SensorEvent::callback = 0;
	ValuePointer* SensorEvent::eventObject = 0;


	SensorEvent::SensorEvent () {

		type = SENSOR_ACCELEROMETER;
		id = 0;
		x = 0;
		y = 0;
		z = 0;

	}


	void SensorEvent::Dispatch (SensorEvent* event) {

		if (SensorEvent::callback) {

			if (SensorEvent::eventObject->IsCFFIValue ()) {

				value object = (value)SensorEvent::eventObject->Get ();

				alloc_field (object, val_id ("id"), alloc_int (event->id));
				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("x"), alloc_float (event->x));
				alloc_field (object, val_id ("y"), alloc_float (event->y));
				alloc_field (object, val_id ("z"), alloc_float (event->z));

			} else {

				SensorEvent* eventObject = (SensorEvent*)SensorEvent::eventObject->Get ();

				eventObject->id = event->id;
				eventObject->type = event->type;
				eventObject->x = event->x;
				eventObject->y = event->y;
				eventObject->z = event->z;

			}

			SensorEvent::callback->Call ();

		}

	}


}