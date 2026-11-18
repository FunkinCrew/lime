#include <events/KeyEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *KeyEvent::callback = 0;
	AutoGCRoot *KeyEvent::eventObject = 0;

	KeyEvent::KeyEvent()
	{
		keyCode = 0;
		modifier = 0;
		type = KEY_DOWN;
		windowID = 0;
		timestamp = 0.0;
	}

	void KeyEvent::Dispatch(KeyEvent *event)
	{
		if (KeyEvent::callback)
		{
			value object = KeyEvent::eventObject->get();

			alloc_field(object, val_id("keyCode"), alloc_float(event->keyCode));
			alloc_field(object, val_id("modifier"), alloc_int(event->modifier));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("windowID"), alloc_int(event->windowID));
			alloc_field(object, val_id("timestamp"), alloc_float(event->timestamp));

			val_call0(KeyEvent::callback->get());
		}
	}

} // namespace lime