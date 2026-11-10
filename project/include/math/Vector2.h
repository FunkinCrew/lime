#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	struct Vector2
	{
		double x;
		double y;

		Vector2();
		Vector2(double x, double y);
		Vector2(value vec);

		value Value();
		value Value(value vec);
	};

} // namespace lime
