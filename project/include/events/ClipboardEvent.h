#pragma once

#include <system/CFFI.h>

namespace lime
{

	enum ClipboardEventType
	{
		CLIPBOARD_UPDATE
	};

	struct ClipboardEvent
	{
		ClipboardEventType type;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		ClipboardEvent();

		static void Dispatch(ClipboardEvent *event);
	};

} // namespace lime