#include <events/JoystickEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *JoystickEvent::callback = 0;
	ValuePointer *JoystickEvent::eventObject = 0;

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
			value object = (value)JoystickEvent::eventObject->Get();

			alloc_field(object, val_id("id"), alloc_int(event->id));
			alloc_field(object, val_id("index"), alloc_int(event->index));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("eventValue"), alloc_int(event->eventValue));
			alloc_field(object, val_id("x"), alloc_float(event->x));
			alloc_field(object, val_id("y"), alloc_float(event->y));

			JoystickEvent::callback->Call();
		}
	}

} // namespace lime