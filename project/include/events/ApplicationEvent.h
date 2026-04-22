#pragma once


#include <system/CFFI.h>
#include <system/ValuePointer.h>


namespace lime {


	enum ApplicationEventType {

		THEME_CHANGE,
		UPDATE,
		EXIT

	};


	struct ApplicationEvent {

		hl_type* t;
		double deltaTime;
		ApplicationEventType type;

		static ValuePointer* callback;
		static ValuePointer* eventObject;

		ApplicationEvent ();

		static void Dispatch (ApplicationEvent* event);

	};


}
