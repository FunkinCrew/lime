#include <events/ClipboardEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *ClipboardEvent::callback = 0;
	ValuePointer *ClipboardEvent::eventObject = 0;

	ClipboardEvent::ClipboardEvent()
	{
		type = CLIPBOARD_UPDATE;
	}

	void ClipboardEvent::Dispatch(ClipboardEvent *event)
	{
		if (ClipboardEvent::callback)
		{
			value object = (value)ClipboardEvent::eventObject->Get();

			alloc_field(object, val_id("type"), alloc_int(event->type));

			ClipboardEvent::callback->Call();
		}
	}

} // namespace lime