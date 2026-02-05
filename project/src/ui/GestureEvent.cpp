#include <system/CFFI.h>
#include <ui/GestureEvent.h>


namespace lime {

	ValuePointer* GestureEvent::callback = 0;
	ValuePointer* GestureEvent::eventObject = 0;

	static int id_id;
	static int id_timestamp;
	static double id_dTheta;
	static double id_dDist;
	static double id_x;
	static double id_y;
	static int id_numFingers;



	static double id_panTranslationX;
	static double id_panTranslationY;
	static double id_panVelocityX;
	static double id_panVelocityY;

	static int id_state;
	static int id_magnification;
	static int id_rotation;

	static bool init = false;

	GestureEvent::GestureEvent () {

		id = 0;
		timestamp = 0;
		dTheta = 0.0;
		dDist = 0.0;
		x = 0.0;
		y = 0.0;
		numFingers = 0;
		state = GESTURE_ENDED;

		magnification = 0.0;
		rotation = 0.0;
		panTranslationX = 0.0;
		panTranslationY = 0.0;
		panVelocityX = 0.0;
		panVelocityY = 0.0;

	}

	void GestureEvent::Dispatch (GestureEvent* event) {

		if (GestureEvent::callback) {

			if (GestureEvent::eventObject->IsCFFIValue ()) {

				if (!init) {

					id_id = val_id ("id");
					id_timestamp = val_id ("timestamp");
					id_dTheta = val_id ("dTheta");
					id_dDist = val_id ("dDist");
					id_x = val_id ("x");
					id_y = val_id ("y");
					id_numFingers = val_id ("numFingers");
					id_state = val_id ("state");
					id_magnification = val_id ("magnification");
					id_rotation = val_id ("rotation");
					id_panTranslationX = val_id ("panTranslationX");
					id_panTranslationY = val_id ("panTranslationY");
					id_panVelocityX = val_id ("panVelocityX");
					id_panVelocityY = val_id ("panVelocityY");
					init = true;

				}

				value object = (value)GestureEvent::eventObject->Get ();

				alloc_field (object, id_id, alloc_int (event->id));
				alloc_field (object, id_timestamp, alloc_int (event->timestamp));
				alloc_field (object, id_dTheta, alloc_float (event->dTheta));
				alloc_field (object, id_dDist, alloc_float (event->dDist));
				alloc_field (object, id_x, alloc_float (event->x));
				alloc_field (object, id_y, alloc_float (event->y));
				alloc_field (object, id_numFingers, alloc_int (event->numFingers));
				alloc_field (object, id_state, alloc_int (event->state));
				alloc_field (object, id_magnification, alloc_float (event->magnification));
				alloc_field (object, id_rotation, alloc_float (event->rotation));
				alloc_field (object, id_panTranslationX, alloc_float (event->panTranslationX));
				alloc_field (object, id_panTranslationY, alloc_float (event->panTranslationY));
				alloc_field (object, id_panVelocityX, alloc_float (event->panVelocityX));
				alloc_field (object, id_panTranslationY, alloc_float (event->panTranslationY));

			} else {

				GestureEvent* eventObject = (GestureEvent*)GestureEvent::eventObject->Get ();

				eventObject->id = event->id;
				eventObject->timestamp = event->timestamp;
				eventObject->dTheta = event->dTheta;
				eventObject->dDist = event->dDist;
				eventObject->x = event->x;
				eventObject->y = event->y;
				eventObject->numFingers = event->numFingers;
				eventObject->state = event->state;
				eventObject->magnification = event->magnification;
				eventObject->rotation = event->rotation;
				eventObject->panTranslationX = event->panTranslationX;
				eventObject->panTranslationY = event->panTranslationY;
				eventObject->panVelocityX = event->panVelocityX;
				eventObject->panVelocityY = event->panVelocityY;

			}

			GestureEvent::callback->Call ();

		}
	}
}