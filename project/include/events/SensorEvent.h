#pragma once

#include <hx/CFFIPrime.h>
#include <system/ValuePointer.h>

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

		static ValuePointer *callback;
		static ValuePointer *eventObject;

		SensorEvent();

		static void Dispatch(SensorEvent *event);
	};

} // namespace lime