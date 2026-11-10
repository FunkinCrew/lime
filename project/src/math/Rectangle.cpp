#include <math/Rectangle.h>

namespace lime
{

	Rectangle::Rectangle()
	{
		this->height = 0;
		this->width = 0;
		this->x = 0;
		this->y = 0;
	}

	Rectangle::Rectangle(double x, double y, double width, double height)
	{
		this->height = height;
		this->width = width;
		this->x = x;
		this->y = y;
	}

	Rectangle::Rectangle(value rect)
	{
		this->width = val_number(val_field(rect, val_id("width")));
		this->height = val_number(val_field(rect, val_id("height")));
		this->x = val_number(val_field(rect, val_id("x")));
		this->y = val_number(val_field(rect, val_id("y")));
	}

	value Rectangle::Value()
	{
		return Value(alloc_empty_object());
	}

	value Rectangle::Value(value rect)
	{
		alloc_field(rect, val_id("height"), alloc_float(height));
		alloc_field(rect, val_id("width"), alloc_float(width));
		alloc_field(rect, val_id("x"), alloc_float(x));
		alloc_field(rect, val_id("y"), alloc_float(y));

		return rect;
	}

} // namespace lime