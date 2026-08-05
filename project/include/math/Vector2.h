#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	struct Vector2
	{
		double x;
		double y;

		Vector2(double x, double y);
		Vector2(value vec);

		void SetTo(double x, double y);
		value Value();
		value Value(value vec);
	};

} // namespace lime
