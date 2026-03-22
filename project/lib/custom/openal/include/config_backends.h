/* Define to 1 if the given backend is enabled, else 0 */

#if defined(_WIN32) || defined(_WIN64) || defined(__CYGWIN__)
    #include "platforms/windows/config_backends.h"
#elif defined(__APPLE__) || defined(__MACH__)
    #include "platforms/apple/config_backends.h"
#elif defined(__ANDROID__)
    #include "platforms/android/config_backends.h"
#elif defined(__linux__)
    #include "platforms/linux/config_backends.h"
#endif

#define HAVE_WAVE 0

#ifdef NATIVE_TOOLKIT_HAVE_SDL
#define HAVE_SDL3 1
#else
#define HAVE_SDL3 0
#endif

#define HAVE_SDL2 0
