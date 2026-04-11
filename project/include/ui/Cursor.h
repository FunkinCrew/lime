#pragma once

namespace lime {


	enum SystemCursor {

		HIDDEN,
		ARROW,
		CROSSHAIR,
		DEFAULT,
		MOVE,
		POINTER,
		RESIZE_NESW,
		RESIZE_NS,
		RESIZE_NWSE,
		RESIZE_WE,
		TEXT,
		WAIT,
		WAIT_ARROW,
		CUSTOM

	};

	class Cursor {

		public:

			static void* GetSystemCursor (SystemCursor type);

	};


}