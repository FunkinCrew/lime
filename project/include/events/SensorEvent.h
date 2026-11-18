#pragma once

#include <system/CFFI.h>

namespace lime
{

	enum SensorEventType
	{
		SENSOR_ACCELEROMETER,
		SENSOR_GYROSCOPE
	};

	struct SensorEvent
	{
		int id;
		double x;
		double y;
		double z;
		SensorEventType type;

		static AutoGCRoot *callback;
		static AutoGCRoot *eventObject;

		SensorEvent();

		static void Dispatch(SensorEvent *event);
	};

} // namespace lime