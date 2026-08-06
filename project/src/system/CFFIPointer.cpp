#include <system/CFFIPointer.h>

namespace lime
{

	value CFFIPointer(void *ptr, hxFinalizer finalizer)
	{
		if (ptr)
		{
			value handle = cffi::alloc_pointer(ptr);

			if (finalizer)
			{
				val_gc(handle, finalizer);
			}

			return handle;
		}
		else
		{
			return alloc_null();
		}
	}

	value CFFIPointer(value handle, hxFinalizer finalizer)
	{
		if (!val_is_null(handle) && finalizer)
		{
			val_gc(handle, finalizer);
		}

		return handle;
	}

} // namespace lime