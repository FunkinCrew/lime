#pragma once


#include <system/CFFI.h>
#include <system/ValuePointer.h>


namespace lime {


	enum DropEventType {

		DROP_FILE,
		DROP_TEXT,
		DROP_BEGIN,
		DROP_COMPLETE,
		DROP_POSITION

	};


	struct DropEvent {

		hl_type* t;
		vbyte* data;
		vbyte* source;
		int windowID;
		double x;
		double y;
		DropEventType type;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		DropEvent ();

		static void Dispatch (DropEvent* event);

	};


}