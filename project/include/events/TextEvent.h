#pragma once


#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>
#include <stdint.h>


namespace lime {


	enum TextEventType {

		TEXT_INPUT,
		TEXT_EDIT

	};


	struct TextEvent {

		int id;
		int length;
		int start;
		char* text;
		TextEventType type;
		int windowID;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		TextEvent ();

		static void Dispatch (TextEvent* event);

	};


}