#if defined(HX_MACOS)

#ifdef HXCPP_ARM64
#include "config/config-macos-arm64.h"
#else
#include "config/config-macos-x86_64.h"
#endif

#elif defined(HX_WINDOWS)

#ifdef HXCPP_M64
#include "config/config-windows-x86_64.h"
#else
#include "config/config-windows-x86.h"
#endif

#elif defined(HX_LINUX)

#include "config/config-linux-x86_64.h"

#elif defined (HX_ANDROID)

#include "config/config-android.h"

#elif defined(IPHONE)

#include "config/config-iphoneos.h"

#endif
