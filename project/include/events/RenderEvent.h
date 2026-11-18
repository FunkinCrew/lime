#pragma once

#include <system/CFFI.h>

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

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		RenderEvent();

		static void Dispatch(RenderEvent *event);
	};

} // namespace lime
