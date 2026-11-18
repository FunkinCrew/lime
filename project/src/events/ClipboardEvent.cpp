#include <events/ClipboardEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *ClipboardEvent::callback = 0;
	AutoGCRoot *ClipboardEvent::eventObject = 0;

	ClipboardEvent::ClipboardEvent()
	{
		type = CLIPBOARD_UPDATE;
	}

	void ClipboardEvent::Dispatch(ClipboardEvent *event)
	{
		if (ClipboardEvent::callback)
		{
			value object = ClipboardEvent::eventObject->get();

			alloc_field(object, val_id("type"), alloc_int(event->type));

			val_call0(ClipboardEvent::callback->get());
		}
	}

} // namespace lime