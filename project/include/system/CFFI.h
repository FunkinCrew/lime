#pragma once

#include <hx/CFFIPrime.h>

// Makes an `Int64` as an object with `low` and `high`.
value alloc_int64(int64_t val);

// Retrives an `Int64` from an object made of `low` and `high`.
int64_t val_int64(value inValue);
