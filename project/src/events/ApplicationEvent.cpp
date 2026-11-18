#include <events/ApplicationEvent.h>
#include <system/CFFI.h>

namespace lime
{

	AutoGCRoot *ApplicationEvent::callback = 0;
	AutoGCRoot *ApplicationEvent::eventObject = 0;

	ApplicationEvent::ApplicationEvent()
	{
		deltaTime = 0.0;
		type = UPDATE;
	}

	void ApplicationEvent::Dispatch(ApplicationEvent *event)
	{
		if (ApplicationEvent::callback)
		{
			value object = ApplicationEvent::eventObject->get();

			alloc_field(object, val_id("deltaTime"), alloc_float(event->deltaTime));
			alloc_field(object, val_id("type"), alloc_int(event->type));

			val_call0(ApplicationEvent::callback->get());
		}
	}

} // namespace lime