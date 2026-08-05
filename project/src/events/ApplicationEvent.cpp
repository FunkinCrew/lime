#include <events/ApplicationEvent.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	ValuePointer *ApplicationEvent::callback = 0;
	ValuePointer *ApplicationEvent::eventObject = 0;

	ApplicationEvent::ApplicationEvent()
	{
		deltaTime = 0.0;
		type = UPDATE;
	}

	void ApplicationEvent::Dispatch(ApplicationEvent *event)
	{
		if (ApplicationEvent::callback)
		{
			value object = (value)ApplicationEvent::eventObject->Get();

			alloc_field(object, val_id("deltaTime"), alloc_float(event->deltaTime));
			alloc_field(object, val_id("type"), alloc_int(event->type));

			ApplicationEvent::callback->Call();
		}
	}

} // namespace lime