#include <events/GestureEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *GestureEvent::callback = 0;
	ValuePointer *GestureEvent::eventObject = 0;

	GestureEvent::GestureEvent()
	{
		x = 0.0;
		y = 0.0;
		state = GESTURE_END;
		magnification = 0.0;
		rotation = 0.0;
		panTranslationX = 0.0;
		panTranslationY = 0.0;
		panVelocityX = 0.0;
		panVelocityY = 0.0;
		scrollX = 0.0;
		scrollY = 0.0;
		momentumScrollX = 0.0;
		momentumScrollY = 0.0;
	}

	void GestureEvent::Dispatch(GestureEvent *event)
	{
		if (GestureEvent::callback)
		{
			value object = (value)GestureEvent::eventObject->Get();

			alloc_field(object, val_id("x"), alloc_float(event->x));
			alloc_field(object, val_id("y"), alloc_float(event->y));
			alloc_field(object, val_id("state"), alloc_int(event->state));
			alloc_field(object, val_id("magnification"), alloc_float(event->magnification));
			alloc_field(object, val_id("rotation"), alloc_float(event->rotation));
			alloc_field(object, val_id("panTranslationX"), alloc_float(event->panTranslationX));
			alloc_field(object, val_id("panTranslationY"), alloc_float(event->panTranslationY));
			alloc_field(object, val_id("panVelocityX"), alloc_float(event->panVelocityX));
			alloc_field(object, val_id("panVelocityY"), alloc_float(event->panVelocityY));
			alloc_field(object, val_id("scrollX"), alloc_float(event->scrollX));
			alloc_field(object, val_id("scrollY"), alloc_float(event->scrollY));
			alloc_field(object, val_id("momentumScrollX"), alloc_float(event->momentumScrollX));
			alloc_field(object, val_id("momentumScrollY"), alloc_float(event->momentumScrollY));

			GestureEvent::callback->Call();
		}
	}
} // namespace lime
