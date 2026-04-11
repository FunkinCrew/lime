#include <system/CFFI.h>
#include <events/GamepadEvent.h>


namespace lime {


	ValuePointer* GamepadEvent::callback = 0;
	ValuePointer* GamepadEvent::eventObject = 0;


	GamepadEvent::GamepadEvent () {

		axis = 0;
		axisValue = 0;
		button = 0;
		id = 0;
		type = GAMEPAD_AXIS_MOVE;
		timestamp = 0.0;

	}


	void GamepadEvent::Dispatch (GamepadEvent* event) {

		if (GamepadEvent::callback) {

			if (GamepadEvent::eventObject->IsCFFIValue ()) {

				value object = (value)GamepadEvent::eventObject->Get ();

				alloc_field (object, val_id ("axis"), alloc_int (event->axis));
				alloc_field (object, val_id ("button"), alloc_int (event->button));
				alloc_field (object, val_id ("id"), alloc_int (event->id));
				alloc_field (object, val_id ("type"), alloc_int (event->type));
				alloc_field (object, val_id ("axisValue"), alloc_float (event->axisValue));
				alloc_field (object, val_id ("timestamp"), alloc_float (event->timestamp));

			} else {

				GamepadEvent* eventObject = (GamepadEvent*)GamepadEvent::eventObject->Get ();

				eventObject->axis = event->axis;
				eventObject->button = event->button;
				eventObject->id = event->id;
				eventObject->type = event->type;
				eventObject->axisValue = event->axisValue;
				eventObject->timestamp = event->timestamp;

			}

			GamepadEvent::callback->Call ();

		}

	}


}