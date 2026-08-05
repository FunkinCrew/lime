#include <events/TouchEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *TouchEvent::callback = 0;
	ValuePointer *TouchEvent::eventObject = 0;

	TouchEvent::TouchEvent()
	{
		type = TOUCH_START;
		x = 0;
		y = 0;
		id = 0;
		dx = 0;
		dy = 0;
		pressure = 0;
		device = 0;
	}

	void TouchEvent::Dispatch(TouchEvent *event)
	{
		if (TouchEvent::callback)
		{
			value object = (value)TouchEvent::eventObject->Get();

			alloc_field(object, val_id("device"), alloc_int(event->device));
			alloc_field(object, val_id("dx"), alloc_float(event->dx));
			alloc_field(object, val_id("dy"), alloc_float(event->dy));
			alloc_field(object, val_id("id"), alloc_int(event->id));
			alloc_field(object, val_id("pressure"), alloc_float(event->pressure));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("x"), alloc_float(event->x));
			alloc_field(object, val_id("y"), alloc_float(event->y));

			TouchEvent::callback->Call();
		}
	}

} // namespace lime