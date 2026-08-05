#include <events/TextEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *TextEvent::callback = 0;
	ValuePointer *TextEvent::eventObject = 0;

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
			value object = (value)TextEvent::eventObject->Get();

			if (event->type != TEXT_INPUT)
			{
				alloc_field(object, val_id("length"), alloc_int(event->length));
				alloc_field(object, val_id("start"), alloc_int(event->start));
			}

			alloc_field(object, val_id("text"), alloc_string((const char *)event->text));
			alloc_field(object, val_id("type"), alloc_int(event->type));
			alloc_field(object, val_id("windowID"), alloc_int(event->windowID));

			TextEvent::callback->Call();
		}
	}

} // namespace lime