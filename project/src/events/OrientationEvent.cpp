#include <events/OrientationEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *OrientationEvent::callback = 0;
	ValuePointer *OrientationEvent::eventObject = 0;

	OrientationEvent::OrientationEvent()
	{
		orientation = 0;
		display = 0;
		type = DISPLAY_ORIENTATION_CHANGE;
	}

	void OrientationEvent::Dispatch(OrientationEvent *event)
	{
		if (OrientationEvent::callback)
		{
			value object = (value)OrientationEvent::eventObject->Get();

			alloc_field(object, val_id("orientation"), alloc_int(event->orientation));
			alloc_field(object, val_id("display"), alloc_int(event->display));
			alloc_field(object, val_id("type"), alloc_int(event->type));

			OrientationEvent::callback->Call();
		}
	}

} // namespace lime