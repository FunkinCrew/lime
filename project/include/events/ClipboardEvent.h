#pragma once


#include <system/CFFI.h>
#include <system/ValuePointer.h>


namespace lime {


	enum ClipboardEventType {

		CLIPBOARD_UPDATE

	};


	struct ClipboardEvent {

		hl_type* t;
		ClipboardEventType type;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		ClipboardEvent ();

		static void Dispatch (ClipboardEvent* event);

	};


}