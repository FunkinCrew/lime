#include <events/OrientationEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *OrientationEvent::callback = 0;
	AutoGCRoot *OrientationEvent::eventObject = 0;

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
			value object = OrientationEvent::eventObject->get();

			alloc_field(object, val_id("orientation"), alloc_int(event->orientation));
			alloc_field(object, val_id("display"), alloc_int(event->display));
			alloc_field(object, val_id("type"), alloc_int(event->type));

			val_call0(OrientationEvent::callback->get());
		}
	}

} // namespace lime