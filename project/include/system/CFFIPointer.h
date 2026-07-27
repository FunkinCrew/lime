#pragma once


#include <hx/CFFIPrime.h>


namespace hx {

	class Object;
	typedef void (*finalizer)(value v);

}


namespace lime {


	value CFFIPointer (void* ptr, hx::finalizer finalizer = 0);
	value CFFIPointer (value handle, hx::finalizer finalizer = 0);


}