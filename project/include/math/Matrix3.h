#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	struct Matrix3
	{
		double a;
		double b;
		double c;
		double d;
		double tx;
		double ty;

		Matrix3();
		Matrix3(double a, double b, double c, double d, double tx, double ty);
		Matrix3(value matrix3);

		value Value();
		value Value(value matrix3);
	};

} // namespace lime
