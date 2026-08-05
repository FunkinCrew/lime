#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum RenderEventType
	{

		RENDER,
		RENDER_CONTEXT_LOST,
		RENDER_CONTEXT_RESTORED

	};

	struct RenderEvent
	{
		RenderEventType type;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		RenderEvent();

		static void Dispatch(RenderEvent *event);
	};

} // namespace lime
