#include <events/RenderEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *RenderEvent::callback = 0;
	AutoGCRoot *RenderEvent::eventObject = 0;

	RenderEvent::RenderEvent()
	{
		type = RENDER;
	}

	void RenderEvent::Dispatch(RenderEvent *event)
	{
		if (RenderEvent::callback)
		{
			value object = RenderEvent::eventObject->get();

			alloc_field(object, val_id("type"), alloc_int(event->type));

			val_call0(RenderEvent::callback->get());
		}
	}

} // namespace lime