#include <events/TextEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *TextEvent::callback = 0;
	AutoGCRoot *TextEvent::eventObject = 0;

	TextEvent::TextEvent()
	{
		length = 0;
		start = 0;
		text = 0;
		windowID = 0;
	}

	void TextEvent::Dispatch(TextEvent *event)
	{
		if (TextEvent::callback)
		{
			value object = TextEvent::eventObject->get();

			if (event->type != TEXT_INPUT)
			{
				alloc_field(object, val_id("length"), alloc_int(event->length));
				alloc_field(object, val_id("start"), alloc_int(event->start));
			}

			alloc_field(object, val_id("text"), alloc_string((const char *)event->text));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("windowID"), alloc_int(event->windowID));

			val_call0(TextEvent::callback->get());
		}
	}

} // namespace lime