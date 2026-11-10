#include <system/CFFI.h>

value alloc_int64(int64_t val)
{
	int32_t high = (val >> 32);
	int32_t low = val;

	value int64Value = alloc_empty_object();
	alloc_field(int64Value, val_id("high"), alloc_int(high));
	alloc_field(int64Value, val_id("low"), alloc_int(low));
	return int64Value;
}

int64_t val_int64(value inValue)
{
	if (val_is_null(inValue))
	{
		return 0;
	}

	value lowVal = val_field(inValue, val_id("low"));
	value highVal = val_field(inValue, val_id("high"));

	if (val_is_null(lowVal) || val_is_null(highVal))
	{
		return 0;
	}

	return (((int64_t)val_int(highVal)) << 32) | (uint32_t)val_int(lowVal);
}
