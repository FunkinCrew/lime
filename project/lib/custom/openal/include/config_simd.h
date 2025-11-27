#if defined(HX_MACOS) && defined(HXCPP_ARM64)

#include "config/simd/config_simd-macos-arm64.h"

#elif defined(HX_MACOS)

#include "config/simd/config_simd-macos-x86_64.h"

#elif defined(HX_WINDOWS)

#ifdef HXCPP_M64
#include "config/simd/config_simd-windows-x86_64.h"
#else
#include "config/simd/config_simd-windows-x86.h"
#endif

#elif defined(HX_LINUX)

#include "config/simd/config_simd-linux-x86_64.h"

#elif defined (HX_ANDROID)

#include "config/simd/config_simd-android.h"

#elif defined(IPHONE)

#include "config/simd/config_simd-iphoneos.h"

#endif
