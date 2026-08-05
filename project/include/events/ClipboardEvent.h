#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum ClipboardEventType
	{

		CLIPBOARD_UPDATE

	};

	struct ClipboardEvent
	{
		ClipboardEventType type;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		ClipboardEvent();

		static void Dispatch(ClipboardEvent *event);
	};

} // namespace lime