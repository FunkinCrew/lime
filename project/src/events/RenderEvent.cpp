#include <events/RenderEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *RenderEvent::callback = 0;
	ValuePointer *RenderEvent::eventObject = 0;

	RenderEvent::RenderEvent()
	{
		type = RENDER;
	}

	void RenderEvent::Dispatch(RenderEvent *event)
	{
		if (RenderEvent::callback)
		{
			value object = (value)RenderEvent::eventObject->Get();

			alloc_field(object, val_id("type"), alloc_int(event->type));

			RenderEvent::callback->Call();
		}
	}

} // namespace lime