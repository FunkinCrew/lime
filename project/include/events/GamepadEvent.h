#pragma once

#include <system/CFFI.h>

namespace lime
{

	enum GamepadEventType
	{
		GAMEPAD_AXIS_MOVE,
		GAMEPAD_BUTTON_DOWN,
		GAMEPAD_BUTTON_UP,
		GAMEPAD_CONNECT,
		GAMEPAD_DISCONNECT
	};

	struct GamepadEvent
	{
		int axis;
		int button;
		int id;
		GamepadEventType type;
		double axisValue;
		double timestamp;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		GamepadEvent();

		static void Dispatch(GamepadEvent *event);
	};

} // namespace lime