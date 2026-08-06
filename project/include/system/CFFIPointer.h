#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	value CFFIPointer(void *ptr, hxFinalizer finalizer = 0);
	value CFFIPointer(value handle, hxFinalizer finalizer = 0);

} // namespace lime