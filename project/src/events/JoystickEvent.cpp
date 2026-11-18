#include <events/JoystickEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *JoystickEvent::callback = 0;
	AutoGCRoot *JoystickEvent::eventObject = 0;

	JoystickEvent::JoystickEvent()
	{
		id = 0;
		index = 0;
		eventValue = 0;
		x = 0;
		y = 0;
		type = JOYSTICK_AXIS_MOVE;
	}

	void JoystickEvent::Dispatch(JoystickEvent *event)
	{
		if (JoystickEvent::callback)
		{
			value object = JoystickEvent::eventObject->get();

			alloc_field(object, val_id("id"), alloc_int(event->id));
			alloc_field(object, val_id("index"), alloc_int(event->index));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("eventValue"), alloc_int(event->eventValue));
			alloc_field(object, val_id("x"), alloc_float(event->x));
			alloc_field(object, val_id("y"), alloc_float(event->y));

			val_call0(JoystickEvent::callback->get());
		}
	}

} // namespace lime