#include <math/Vector2.h>

namespace lime
{

	Vector2::Vector2()
	{
		this->x = 0;
		this->y = 0;
	}

	Vector2::Vector2(double x, double y)
	{
		this->x = x;
		this->y = y;
	}

	Vector2::Vector2(value vec)
	{
		this->x = val_number(val_field(vec, val_id("x")));
		this->y = val_number(val_field(vec, val_id("y")));
	}

	value Vector2::Value()
	{
		return Value(alloc_empty_object());
	}

	value Vector2::Value(value vec)
	{
		alloc_field(vec, val_id("x"), alloc_float(x));
		alloc_field(vec, val_id("y"), alloc_float(y));

		return vec;
	}

} // namespace lime