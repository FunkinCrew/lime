#pragma once

#include <system/CFFI.h>

namespace lime
{

	enum ApplicationEventType
	{
		THEME_CHANGE,
		UPDATE,
		EXIT
	};

	struct ApplicationEvent
	{
		double deltaTime;
		ApplicationEventType type;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		ApplicationEvent();

		static void Dispatch(ApplicationEvent *event);
	};

} // namespace lime
