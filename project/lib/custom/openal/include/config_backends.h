#if defined(HX_MACOS) && defined(HXCPP_ARM64)

#include "config/backends/config_backends-macos-arm64.h"

#elif defined(HX_MACOS)

#include "config/backends/config_backends-macos-x86_64.h"

#elif defined(HX_WINDOWS)

#ifdef HXCPP_M64
#include "config/backends/config_backends-windows-x86_64.h"
#else
#include "config/backends/config_backends-windows-x86.h"
#endif

#elif defined(HX_LINUX)

#include "config/backends/config_backends-linux-x86_64.h"

#elif defined (HX_ANDROID)

#include "config/backends/config_backends-android.h"

#elif defined(IPHONE)

#include "config/backends/config_backends-iphoneos.h"

#endif
