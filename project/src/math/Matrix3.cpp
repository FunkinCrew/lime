#include <math/Matrix3.h>

namespace lime
{

	Matrix3::Matrix3()
	{
		this->a = 0;
		this->b = 0;
		this->c = 0;
		this->d = 0;
		this->tx = 0;
		this->ty = 0;
	}

	Matrix3::Matrix3(double a, double b, double c, double d, double tx, double ty)
	{
		this->a = a;
		this->b = b;
		this->c = c;
		this->d = d;
		this->tx = tx;
		this->ty = ty;
	}

	Matrix3::Matrix3(value mat3)
	{
		this->a = val_number(val_field(mat3, val_id("a")));
		this->b = val_number(val_field(mat3, val_id("b")));
		this->c = val_number(val_field(mat3, val_id("c")));
		this->d = val_number(val_field(mat3, val_id("d")));
		this->tx = val_number(val_field(mat3, val_id("tx")));
		this->ty = val_number(val_field(mat3, val_id("ty")));
	}

	value Matrix3::Value()
	{
		return Value(alloc_empty_object());
	}

	value Matrix3::Value(value matrix3)
	{
		alloc_field(matrix3, val_id("a"), alloc_float(a));
		alloc_field(matrix3, val_id("b"), alloc_float(b));
		alloc_field(matrix3, val_id("c"), alloc_float(c));
		alloc_field(matrix3, val_id("d"), alloc_float(d));
		alloc_field(matrix3, val_id("tx"), alloc_float(tx));
		alloc_field(matrix3, val_id("ty"), alloc_float(ty));

		return matrix3;
	}

} // namespace lime