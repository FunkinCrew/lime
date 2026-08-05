#pragma once

#include <hx/CFFIPrime.h>

namespace lime
{

	class ValuePointer
	{
	  public:
		ValuePointer(value handle);
		~ValuePointer();

		void *Call();
		void *Call(void *arg0);
		void *Call(void *arg0, void *arg1);
		void *Call(void *arg0, void *arg1, void *arg2);
		void *Call(void *arg0, void *arg1, void *arg2, void *arg3);
		void *Call(void *arg0, void *arg1, void *arg2, void *arg3, void *arg4);
		void *Get() const;
		void Set(value handle);

	  private:
		gcroot cffiRoot;
		value *cffiValue;
	};

} // namespace lime