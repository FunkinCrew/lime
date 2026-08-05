#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

namespace lime
{

	enum DropEventType
	{

		DROP_FILE,
		DROP_TEXT,
		DROP_BEGIN,
		DROP_COMPLETE,
		DROP_POSITION

	};

	struct DropEvent
	{
		char *data;
		char *source;
		int windowID;
		double x;
		double y;
		DropEventType type;

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		DropEvent();

		static void Dispatch(DropEvent *event);
	};

} // namespace lime