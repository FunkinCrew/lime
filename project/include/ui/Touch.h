#pragma once

#include <system/CFFI.h>

namespace lime
{

	class Touch
	{
	  public:
		static value GetDevices();
		static const char *GetDeviceName(int id);
		static int GetDeviceType(int id);
	};

} // namespace lime
