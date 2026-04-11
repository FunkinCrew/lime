#include <math/Matrix3.h>


namespace lime {


	Matrix3::Matrix3 (double a, double b, double c, double d, double tx, double ty) {

		t = 0;

		SetTo (a, b, c, d, tx, ty);

	}


	Matrix3::Matrix3 (value mat3) {

		a = val_number (val_field (mat3, val_id ("a")));
		b = val_number (val_field (mat3, val_id ("b")));
		c = val_number (val_field (mat3, val_id ("c")));
		d = val_number (val_field (mat3, val_id ("d")));
		tx = val_number (val_field (mat3, val_id ("tx")));
		ty = val_number (val_field (mat3, val_id ("ty")));

	}


	void Matrix3::SetTo (double a, double b, double c, double d, double tx, double ty) {

		this->a = a;
		this->b = b;
		this->c = c;
		this->d = d;
		this->tx = tx;
		this->ty = ty;

	}


	value Matrix3::Value () {

		return Value (alloc_empty_object ());

	}


	value Matrix3::Value (value matrix3) {

		alloc_field (matrix3, val_id ("a"), alloc_float (a));
		alloc_field (matrix3, val_id ("b"), alloc_float (b));
		alloc_field (matrix3, val_id ("c"), alloc_float (c));
		alloc_field (matrix3, val_id ("d"), alloc_float (d));
		alloc_field (matrix3, val_id ("tx"), alloc_float (tx));
		alloc_field (matrix3, val_id ("ty"), alloc_float (ty));

		return matrix3;

	}


}