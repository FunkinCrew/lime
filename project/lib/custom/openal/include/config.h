#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
	#include "platforms/windows/config.h"
#elif defined(__APPLE__) || defined(__MACH__)
	#include "platforms/apple/config.h"
#elif defined(__ANDROID__)
	#include "platforms/android/config.h"
#elif defined(__linux__)
    #include "platforms/linux/config.h"
#elif defined(__EMSCRIPTEN__)
	#include "platforms/emscripten/config.h"
#endif
