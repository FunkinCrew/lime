/**
 * @file SDL_build_config.h
 * @brief SDL3 Build Configuration Header
 *
 * This file contains platform-specific configuration macros that enable or disable
 * various SDL subsystems and drivers based on the target platform. It is automatically
 * generated during the build process and should not be manually edited.
 */

#pragma once

#include <SDL3/SDL_platform_defines.h>

/* ============================================================================
 * COMPILER AND STANDARD LIBRARY CONFIGURATION
 * ============================================================================ */

/**
 * @brief Indicates that standard C library functions are available.
 */
#define HAVE_LIBC 1

/**
 * @name GCC Atomic Operations
 * @brief Compiler intrinsics for atomic operations (GCC/Clang).
 * @{
 */
#if defined(__GNUC__)
# define HAVE_GCC_ATOMICS 1                  /**< GCC/Clang atomic built-ins available */
# define HAVE_GCC_SYNC_LOCK_TEST_AND_SET 1   /**< GCC/Clang sync lock test-and-set available */
#endif
/** @} */

/**
 * @name Standard Headers
 * @brief Availability of standard C headers.
 * @{
 */
#define HAVE_STDARG_H 1   /**< Variable argument list support (stdarg.h) */
#define HAVE_STDDEF_H 1   /**< Standard definitions (stddef.h) */
#define HAVE_STDINT_H 1   /**< Fixed-width integer types (stdint.h) */
/** @} */

/**
 * @brief Enable dynamic API loading via dlopen on Linux.
 */
#if defined(SDL_PLATFORM_LINUX)
# define DYNAPI_NEEDS_DLOPEN 1
#endif

/* ============================================================================
 * COMMON C LIBRARY FEATURES - Available on ALL platforms
 * ============================================================================ */

/**
 * @name Standard C Headers (Common)
 * @brief Standard C headers available on all platforms.
 * @{
 */
#define HAVE_FLOAT_H 1      /**< Floating-point limits and characteristics */
#define HAVE_INTTYPES_H 1   /**< Integer type format conversion */
#define HAVE_LIMITS_H 1     /**< Implementation-defined limits */
#define HAVE_MATH_H 1       /**< Mathematical functions */
#define HAVE_SIGNAL_H 1     /**< Signal handling */
#define HAVE_STDIO_H 1      /**< Standard input/output */
#define HAVE_STDLIB_H 1     /**< General utilities */
#define HAVE_STRING_H 1     /**< String handling */
#define HAVE_SYS_TYPES_H 1  /**< System data types */
#define HAVE_WCHAR_H 1      /**< Wide character handling */
/** @} */

/**
 * @name Math Functions (Common)
 * @brief Standard math functions available on all platforms.
 * @{
 */
#define HAVE_ABS 1       /**< Absolute value (integer) */
#define HAVE_ACOS 1      /**< Arc cosine */
#define HAVE_ACOSF 1     /**< Arc cosine (float) */
#define HAVE_ASIN 1      /**< Arc sine */
#define HAVE_ASINF 1     /**< Arc sine (float) */
#define HAVE_ATAN 1      /**< Arc tangent */
#define HAVE_ATAN2 1     /**< Arc tangent of y/x */
#define HAVE_ATAN2F 1    /**< Arc tangent of y/x (float) */
#define HAVE_ATANF 1     /**< Arc tangent (float) */
#define HAVE_CEIL 1      /**< Ceiling function */
#define HAVE_CEILF 1     /**< Ceiling function (float) */
#define HAVE_COPYSIGN 1  /**< Copy sign of a number */
#define HAVE_COPYSIGNF 1 /**< Copy sign of a number (float) */
#define HAVE_COS 1       /**< Cosine */
#define HAVE_COSF 1      /**< Cosine (float) */
#define HAVE_EXP 1       /**< Exponential function */
#define HAVE_EXPF 1      /**< Exponential function (float) */
#define HAVE_FABS 1      /**< Absolute value (floating-point) */
#define HAVE_FABSF 1     /**< Absolute value (float) */
#define HAVE_FLOOR 1     /**< Floor function */
#define HAVE_FLOORF 1    /**< Floor function (float) */
#define HAVE_FMOD 1      /**< Floating-point remainder */
#define HAVE_FMODF 1     /**< Floating-point remainder (float) */
#define HAVE_LOG 1       /**< Natural logarithm */
#define HAVE_LOG10 1     /**< Base-10 logarithm */
#define HAVE_LOG10F 1    /**< Base-10 logarithm (float) */
#define HAVE_LOGF 1      /**< Natural logarithm (float) */
#define HAVE_LROUND 1    /**< Round to nearest integer (long) */
#define HAVE_LROUNDF 1   /**< Round to nearest integer (long, float input) */
#define HAVE_MODF 1      /**< Extract integer and fractional parts */
#define HAVE_MODFF 1     /**< Extract integer and fractional parts (float) */
#define HAVE_POW 1       /**< Power function */
#define HAVE_POWF 1      /**< Power function (float) */
#define HAVE_ROUND 1     /**< Round to nearest integer */
#define HAVE_ROUNDF 1    /**< Round to nearest integer (float) */
#define HAVE_SCALBN 1    /**< Scale by power of radix */
#define HAVE_SCALBNF 1   /**< Scale by power of radix (float) */
#define HAVE_SIN 1       /**< Sine */
#define HAVE_SINF 1      /**< Sine (float) */
#define HAVE_SQRT 1      /**< Square root */
#define HAVE_SQRTF 1     /**< Square root (float) */
#define HAVE_TAN 1       /**< Tangent */
#define HAVE_TANF 1      /**< Tangent (float) */
#define HAVE_TRUNC 1     /**< Truncate to integer */
#define HAVE_TRUNCF 1    /**< Truncate to integer (float) */
/** @} */

/**
 * @name Floating Point Classification (Common)
 * @brief Functions to check for special floating-point values.
 * @{
 */
#define HAVE_ISINF 1                /**< Check for infinity */
#define HAVE_ISINF_FLOAT_MACRO 1    /**< isinf() available as macro */
#define HAVE_ISNAN 1                /**< Check for NaN */
#define HAVE_ISNAN_FLOAT_MACRO 1    /**< isnan() available as macro */
/** @} */

/**
 * @name String/Memory Functions (Common)
 * @brief Standard string and memory manipulation functions.
 * @{
 */
#define HAVE_ATOF 1      /**< Convert string to double */
#define HAVE_ATOI 1      /**< Convert string to integer */
#define HAVE_MEMCMP 1    /**< Compare memory blocks */
#define HAVE_MEMCPY 1    /**< Copy memory block */
#define HAVE_MEMMOVE 1   /**< Move memory block (handles overlap) */
#define HAVE_MEMSET 1    /**< Fill memory block */
#define HAVE_STRCHR 1    /**< Find character in string */
#define HAVE_STRCMP 1    /**< Compare strings */
#define HAVE_STRLEN 1    /**< Get string length */
#define HAVE_STRNCMP 1   /**< Compare strings (n characters) */
#define HAVE_STRRCHR 1   /**< Find last occurrence of character */
#define HAVE_STRSTR 1    /**< Find substring */
#define HAVE_STRTOD 1    /**< Convert string to double */
#define HAVE_STRTOL 1    /**< Convert string to long */
#define HAVE_STRTOLL 1   /**< Convert string to long long */
#define HAVE_STRTOUL 1   /**< Convert string to unsigned long */
#define HAVE_STRTOULL 1  /**< Convert string to unsigned long long */
/** @} */

/**
 * @name Standard Library Functions (Common)
 * @brief General utility functions available on all platforms.
 * @{
 */
#define HAVE_GETENV 1      /**< Get environment variable */
#define HAVE_MALLOC 1      /**< Allocate memory */
#define HAVE_PUTENV 1      /**< Add/change environment variable */
#define HAVE_VSNPRINTF 1   /**< Formatted output to buffer (va_list) */
#define HAVE_VSSCANF 1     /**< Formatted input from string (va_list) */
/** @} */

/* ============================================================================
 * UNIX-LIKE PLATFORMS (Android, iOS, Linux, macOS)
 * ============================================================================ */

#if !defined(SDL_PLATFORM_WIN32)

/**
 * @name POSIX/Unix Functions
 * @brief Functions available on Unix-like platforms.
 * @{
 */
# define HAVE_BCOPY 1        /**< Copy byte sequence (legacy BSD) */
# define HAVE_DLOPEN 1       /**< Dynamic library loading */
# define HAVE_GETHOSTNAME 1  /**< Get hostname */
# define HAVE_GMTIME_R 1     /**< Convert time to GMT (reentrant) */
# define HAVE_LOCALTIME_R 1  /**< Convert time to local time (reentrant) */
# define HAVE_NANOSLEEP 1    /**< High-resolution sleep */
# define HAVE_SETENV 1       /**< Set environment variable */
# define HAVE_SETJMP 1       /**< Non-local jump support */
# define HAVE_SIGACTION 1    /**< Signal handling (POSIX) */
# define HAVE_STRLCAT 1      /**< Safe string concatenation (BSD) */
# define HAVE_STRLCPY 1      /**< Safe string copy (BSD) */
# define HAVE_STRTOK_R 1     /**< Tokenize string (reentrant) */
# define HAVE_SYSCONF 1      /**< Get system configuration */
# define HAVE_UNSETENV 1     /**< Remove environment variable */
/** @} */

#endif /* !SDL_PLATFORM_WIN32 */

/* ============================================================================
 * APPLE PLATFORMS (iOS, macOS)
 * ============================================================================ */

#if defined(SDL_PLATFORM_MACOS) || defined(SDL_PLATFORM_IOS)

/**
 * @name Apple Platform Functions
 * @brief Functions available on macOS and iOS.
 * @{
 */
# define HAVE_NL_LANGINFO 1    /**< Get locale information */
# define HAVE_O_CLOEXEC 1      /**< Close-on-exec flag support */
# define HAVE_STRPBRK 1        /**< Find first occurrence of characters in set */
# define HAVE_SYSCTLBYNAME 1   /**< Get system information by name */
/** @} */

#endif /* SDL_PLATFORM_MACOS || SDL_PLATFORM_IOS */

/* ============================================================================
 * ANDROID-SPECIFIC CONFIGURATION
 * ============================================================================ */

#if defined(SDL_PLATFORM_ANDROID)

/**
 * @name Android Functions
 * @brief Functions available on Android.
 * @{
 */
# define HAVE_CLOCK_GETTIME 1  /**< POSIX clock functions */
# define HAVE_FDATASYNC 1      /**< Synchronize file data to disk */
# define HAVE_GETAUXVAL 1      /**< Get auxiliary vector entry */
# define HAVE_GETRESUID 1      /**< Get real, effective, and saved user IDs */
# define HAVE_GETRESGID 1      /**< Get real, effective, and saved group IDs */
/** @} */

/**
 * @name Android API Level-Dependent Features
 * @{
 */
# if __ANDROID_API__ >= 24
#  define HAVE_ICONV 1      /**< Character set conversion (API 24+) */
#  define HAVE_ICONV_H 1    /**< iconv.h header (API 24+) */
# endif

# if __ANDROID_API__ >= 26
#  define HAVE_NL_LANGINFO 1  /**< Get locale information (API 26+) */
#  define HAVE_ST_MTIM 1      /**< High-resolution file modification time (API 26+) */
# endif
/** @} */

#endif /* SDL_PLATFORM_ANDROID */

/* ============================================================================
 * LINUX-SPECIFIC CONFIGURATION
 * ============================================================================ */

#if defined(SDL_PLATFORM_LINUX)

/**
 * @name Linux System Functions
 * @brief System-level functions specific to Linux.
 * @{
 */
# define HAVE__EXIT 1                                      /**< Exit immediately */
# define HAVE_CLOCK_GETTIME 1                              /**< POSIX clock functions */
# define HAVE_FDATASYNC 1                                  /**< Synchronize file data */
# define HAVE_FOPEN64 1                                    /**< Open large files */
# define HAVE_FSEEKO 1                                     /**< Seek with off_t */
# define HAVE_FSEEKO64 1                                   /**< Seek large files */
# define HAVE_GETAUXVAL 1                                  /**< Get auxiliary vector */
# define HAVE_GETPAGESIZE 1                                /**< Get memory page size */
# define HAVE_GETRESUID 1                                  /**< Get real, effective, and saved user IDs */
# define HAVE_GETRESGID 1                                  /**< Get real, effective, and saved group IDs */
# define HAVE_INDEX 1                                      /**< Find character (legacy) */
# define HAVE_INOTIFY 1                                    /**< File system event monitoring */
# define HAVE_INOTIFY_INIT1 1                              /**< Initialize inotify with flags */
# define HAVE_MEMFD_CREATE 1                               /**< Create anonymous file */
# define HAVE_NL_LANGINFO 1                                /**< Get locale information */
# define HAVE_O_CLOEXEC 1                                  /**< Close-on-exec flag */
# define HAVE_POSIX_FALLOCATE 1                            /**< Allocate file space */
# define HAVE_POSIX_SPAWN_FILE_ACTIONS_ADDCHDIR_NP 1       /**< Change dir in posix_spawn */
# define HAVE_PPOLL 1                                      /**< Poll with signal mask */
# define HAVE_PTHREAD_SETNAME_NP 1                         /**< Set thread name */
# define HAVE_RINDEX 1                                     /**< Find character from end (legacy) */
# define HAVE_SA_SIGACTION 1                               /**< sigaction with extended info */
# define HAVE_SEM_TIMEDWAIT 1                              /**< Timed semaphore wait */
# define HAVE_SIGTIMEDWAIT 1                               /**< Timed signal wait */
# define HAVE_ST_MTIM 1                                    /**< High-res file mod time */
# define HAVE_STRNLEN 1                                    /**< Get string length (bounded) */
# define HAVE_STRPBRK 1                                    /**< Find characters in set */
/** @} */

/**
 * @name Linux Math Functions
 * @brief Additional math functions on Linux.
 * @{
 */
# define HAVE_ISINFF 1   /**< Check for infinity (float-specific) */
# define HAVE_ISNANF 1   /**< Check for NaN (float-specific) */
/** @} */

/**
 * @name Linux Wide Character Functions
 * @brief Wide character string functions.
 * @{
 */
# define HAVE_WCSCMP 1    /**< Compare wide strings */
# define HAVE_WCSLCAT 1   /**< Safe wide string concatenation */
# define HAVE_WCSLCPY 1   /**< Safe wide string copy */
# define HAVE_WCSLEN 1    /**< Get wide string length */
# define HAVE_WCSNCMP 1   /**< Compare wide strings (n chars) */
# define HAVE_WCSNLEN 1   /**< Get wide string length (bounded) */
# define HAVE_WCSSTR 1    /**< Find wide substring */
# define HAVE_WCSTOL 1    /**< Convert wide string to long */
/** @} */

/**
 * @name Linux-Specific Headers
 * @brief Headers specific to Linux systems.
 * @{
 */
# define HAVE_DBUS_DBUS_H 1    /**< D-Bus IPC system */
# define HAVE_ICONV 1          /**< Character set conversion */
# define HAVE_ICONV_H 1        /**< iconv.h header */
# define HAVE_LIBUDEV_H 1      /**< Device management library */
# define HAVE_LINUX_INPUT_H 1  /**< Linux input subsystem */
# define HAVE_MALLOC_H 1       /**< Memory allocation (glibc) */
# define HAVE_MEMORY_H 1       /**< Memory operations (deprecated) */
# define HAVE_STRINGS_H 1      /**< String operations (BSD) */
/** @} */

/**
 * @name Linux-Specific Features
 * @{
 */
# define HAVE_FCITX 1  /**< Fcitx input method framework */
/** @} */

#endif /* SDL_PLATFORM_LINUX */

/* ============================================================================
 * WINDOWS-SPECIFIC CONFIGURATION
 * ============================================================================ */

#if defined(SDL_PLATFORM_WIN32)

/**
 * @name Windows-Specific Functions
 * @brief Functions available only on Windows.
 * @{
 */
# define HAVE__COPYSIGN 1   /**< Copy sign (Windows CRT) */
# define HAVE__EXIT 1       /**< Exit immediately (Windows CRT) */
# define HAVE__FSEEKI64 1   /**< 64-bit file seek (Windows CRT) */
# define HAVE__I64TOA 1     /**< Convert 64-bit int to string */
# define HAVE__LTOA 1       /**< Convert long to string */
# define HAVE__STRREV 1     /**< Reverse string in place */
# define HAVE__UI64TOA 1    /**< Convert unsigned 64-bit int to string */
# define HAVE__ULTOA 1      /**< Convert unsigned long to string */
# define HAVE_ITOA 1        /**< Convert int to string */
# define HAVE_STRNLEN 1     /**< Get string length (bounded) */
# define HAVE_STRPBRK 1     /**< Find characters in set */
/** @} */

/**
 * @name Windows Wide Character Functions
 * @brief Wide character string functions on Windows.
 * @{
 */
# define HAVE_WCSCMP 1    /**< Compare wide strings */
# define HAVE_WCSLEN 1    /**< Get wide string length */
# define HAVE_WCSNCMP 1   /**< Compare wide strings (n chars) */
# define HAVE_WCSNLEN 1   /**< Get wide string length (bounded) */
# define HAVE_WCSSTR 1    /**< Find wide substring */
# define HAVE_WCSTOL 1    /**< Convert wide string to long */
/** @} */

/**
 * @name Windows-Specific Headers
 * @brief Windows API headers.
 * @{
 */
# define HAVE_DDRAW_H 1                   /**< DirectDraw (legacy graphics) */
# define HAVE_DINPUT_H 1                  /**< DirectInput (input devices) */
# define HAVE_DSOUND_H 1                  /**< DirectSound (audio) */
# define HAVE_DXGI_H 1                    /**< DirectX Graphics Infrastructure */
# define HAVE_DXGI1_5_H 1                 /**< DXGI 1.5 features */
# define HAVE_DXGI1_6_H 1                 /**< DXGI 1.6 features */
# if defined(__has_include) && __has_include(<gameinput.h>)
#  define HAVE_GAMEINPUT_H 1              /**< GameInput API joystick support */
# endif
# define HAVE_MALLOC_H 1                  /**< Memory allocation */
# define HAVE_MEMORY_H 1                  /**< Memory operations (deprecated) */
# define HAVE_MMDEVICEAPI_H 1             /**< Core Audio device enumeration */
# define HAVE_ROAPI_H 1                   /**< Windows Runtime API */
# define HAVE_SENSORSAPI_H 1              /**< Sensor API */
# define HAVE_SHELLSCALINGAPI_H 1         /**< DPI scaling */
# define HAVE_TPCSHRD_H 1                 /**< Tablet PC shared definitions */
# define HAVE_WINDOWS_GAMING_INPUT_H 1    /**< Windows.Gaming.Input */
# define HAVE_XINPUT_H 1                  /**< XInput controller API */
/** @} */

#endif /* SDL_PLATFORM_WIN32 */

/* ============================================================================
 * DISABLED SUBSYSTEMS
 * ============================================================================ */

/**
 * @name Disabled Subsystems
 * @brief SDL subsystems that are disabled in this build configuration.
 * @{
 */
#define SDL_GPU_DISABLED 1      /**< GPU/Graphics subsystem is disabled */
#define SDL_CAMERA_DISABLED 1   /**< Camera subsystem is disabled */
/** @} */

/* ============================================================================
 * PLATFORM-SPECIFIC SDL DRIVERS AND SUBSYSTEMS
 * ============================================================================ */

#if defined(SDL_PLATFORM_WIN32)

/**
 * @name Windows Platform Drivers
 * @brief Drivers and subsystems enabled for Windows platforms.
 * @{
 */
# define SDL_AUDIO_DRIVER_WASAPI 1            /**< WASAPI (modern low-latency) audio driver */
# define SDL_AUDIO_DRIVER_DSOUND 1            /**< DirectSound legacy audio driver */
# define SDL_CAMERA_DRIVER_MEDIAFOUNDATION 1  /**< Media Foundation camera driver */
# define SDL_FILESYSTEM_WINDOWS 1             /**< Windows filesystem operations */
# define SDL_HAPTIC_DINPUT 1                  /**< DirectInput haptic (force feedback) support */
# define SDL_JOYSTICK_DINPUT 1                /**< DirectInput joystick support */
# define SDL_JOYSTICK_GAMEINPUT 1             /**< GameInput API joystick support */
# ifdef HAVE_GAMEINPUT_H
#  define SDL_JOYSTICK_GAMEINPUT 1            /**< GameInput API joystick support */
# endif
# define SDL_JOYSTICK_RAWINPUT 1              /**< Raw Input joystick support */
# define SDL_JOYSTICK_WGI 1                   /**< Windows.Gaming.Input joystick support */
# define SDL_JOYSTICK_XINPUT 1                /**< XInput controller support */
# define SDL_POWER_WINDOWS 1                  /**< Windows power management */
# define SDL_SENSOR_WINDOWS 1                 /**< Windows sensor support */
# define SDL_VIDEO_DRIVER_WINDOWS 1           /**< Windows video driver */
# define SDL_VIDEO_OPENGL 1                   /**< OpenGL support */
# define SDL_VIDEO_OPENGL_EGL 1               /**< EGL (Embedded OpenGL) support */
# define SDL_VIDEO_OPENGL_ES2 1               /**< OpenGL ES 2.0 support */
# define SDL_VIDEO_OPENGL_WGL 1               /**< Windows GL (WGL) support */
/** @} */

#elif defined(SDL_PLATFORM_MACOS)

/**
 * @name macOS Platform Drivers
 * @brief Drivers and subsystems enabled for macOS platforms.
 * @{
 */
# define SDL_AUDIO_DRIVER_COREAUDIO 1    /**< Core Audio sound system driver */
# define SDL_CAMERA_DRIVER_COREMEDIA 1   /**< Core Media camera driver */
# define SDL_FILESYSTEM_COCOA 1          /**< Cocoa filesystem operations */
# define SDL_HAPTIC_IOKIT 1              /**< IOKit haptic (force feedback) support */
# define SDL_JOYSTICK_IOKIT 1            /**< IOKit joystick support */
# define SDL_JOYSTICK_MFI 1              /**< MFi (Made for iPhone/iPad/Mac) controller support */
# define SDL_POWER_MACOSX 1              /**< macOS power management */
# define SDL_SENSOR_DUMMY 1              /**< Dummy sensor driver (no native support) */
# define SDL_VIDEO_DRIVER_COCOA 1        /**< Cocoa video driver */
# define SDL_VIDEO_OPENGL 1              /**< OpenGL support */
# define SDL_VIDEO_OPENGL_CGL 1          /**< Core Graphics Layer (CGL) OpenGL support */
/** @} */

#elif defined(SDL_PLATFORM_IOS)

/**
 * @name iOS Platform Drivers
 * @brief Drivers and subsystems enabled for iOS, tvOS, and visionOS platforms.
 * @{
 */
# define SDL_AUDIO_DRIVER_COREAUDIO 1    /**< Core Audio sound system driver */

# if !defined(SDL_PLATFORM_TVOS) && !defined(SDL_PLATFORM_VISIONOS)
#  define SDL_CAMERA_DRIVER_COREMEDIA 1  /**< Core Media camera driver (not on tvOS/visionOS) */
# endif

# define SDL_DIALOG_DUMMY 1          /**< Dummy dialog driver (no native support) */
# define SDL_FILESYSTEM_COCOA 1      /**< Cocoa filesystem operations */
# define SDL_HAPTIC_DUMMY 1          /**< Dummy haptic driver (no native support) */
# define SDL_JOYSTICK_MFI 1          /**< MFi controller support */
# define SDL_POWER_UIKIT 1           /**< UIKit power management */
# define SDL_TRAY_DUMMY 1            /**< Dummy system tray driver (not applicable on iOS) */

# ifndef SDL_PLATFORM_TVOS
#  define SDL_SENSOR_COREMOTION 1   /**< Core Motion sensor support (iOS, not tvOS) */
# else
#  define SDL_SENSOR_DUMMY 1        /**< Dummy sensor driver (tvOS) */
# endif

# define SDL_VIDEO_DRIVER_UIKIT 1    /**< UIKit video driver */
# define SDL_VIDEO_OPENGL_ES2 1      /**< OpenGL ES 2.0 support */
/** @} */

#elif defined(SDL_PLATFORM_ANDROID)

/**
 * @name Android Platform Drivers
 * @brief Drivers and subsystems enabled for Android platforms.
 * @{
 */
# define SDL_AUDIO_DRIVER_OPENSLES 1   /**< OpenSL ES audio driver */
# define SDL_AUDIO_DRIVER_AAUDIO 1     /**< AAudio low-latency audio driver (Android 8.0+) */
# define SDL_CAMERA_DRIVER_ANDROID 1   /**< Android camera driver */
# define SDL_FILESYSTEM_ANDROID 1      /**< Android filesystem operations */
# define SDL_HAPTIC_ANDROID 1          /**< Android haptic (vibration) support */
# define SDL_JOYSTICK_ANDROID 1        /**< Android joystick/gamepad support */
# define SDL_POWER_ANDROID 1           /**< Android power management */
# define SDL_SENSOR_ANDROID 1          /**< Android sensor support */
# define SDL_TRAY_DUMMY 1              /**< Dummy system tray driver (not applicable on Android) */
# define SDL_VIDEO_DRIVER_ANDROID 1    /**< Android video driver */
# define SDL_VIDEO_OPENGL_EGL 1     /**< EGL support */
# define SDL_VIDEO_OPENGL_ES2 1        /**< OpenGL ES 2.0 support */
/** @} */

#elif defined(SDL_PLATFORM_LINUX)

/**
 * @name Linux Platform Drivers
 * @brief Drivers and subsystems enabled for Linux platforms.
 * @{
 */
# define SDL_AUDIO_DRIVER_ALSA 1                             /**< ALSA (Advanced Linux Sound Architecture) audio driver */
# define SDL_AUDIO_DRIVER_ALSA_DYNAMIC "libasound.so.2"      /**< Dynamically loaded ALSA shared library */
# define SDL_AUDIO_DRIVER_PULSEAUDIO 1                       /**< PulseAudio sound server audio driver */
# define SDL_AUDIO_DRIVER_PULSEAUDIO_DYNAMIC "libpulse.so.0" /**< Dynamically loaded PulseAudio shared library */
# define SDL_CAMERA_DRIVER_V4L2 1                            /**< Video4Linux2 camera driver */
# define SDL_FILESYSTEM_UNIX 1                               /**< Unix filesystem operations */
# define SDL_HAPTIC_LINUX 1                                  /**< Linux haptic (force feedback) support */
# define SDL_JOYSTICK_LINUX 1                                /**< Linux joystick support */
# define SDL_POWER_LINUX 1                                   /**< Linux power management */
# define SDL_SENSOR_DUMMY 1                                  /**< Dummy sensor driver (no native support) */
# define SDL_STORAGE_STEAM 1                                 /**< Steam cloud storage support */

/**
 * @name KMS/DRM Video Driver
 * @brief Kernel Mode Setting / Direct Rendering Manager video driver.
 * @{
 */
# define SDL_VIDEO_DRIVER_KMSDRM 1                        /**< KMS/DRM video driver */
# define SDL_VIDEO_DRIVER_KMSDRM_DYNAMIC "libdrm.so.2"   /**< Dynamic libdrm loading */
# define SDL_VIDEO_DRIVER_KMSDRM_DYNAMIC_GBM "libgbm.so.1" /**< Dynamic libgbm loading */
/** @} */

/**
 * @name X11 Video Driver
 * @brief X Window System video driver with extensions.
 * @{
 */
# define SDL_VIDEO_DRIVER_X11 1                                    /**< X11 video driver */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC "libX11.so.6"                /**< Dynamic libX11 loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XCURSOR "libXcursor.so.1"    /**< Dynamic Xcursor loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XEXT "libXext.so.6"          /**< Dynamic Xext loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XFIXES "libXfixes.so.3"      /**< Dynamic Xfixes loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XINPUT2 "libXi.so.6"         /**< Dynamic XInput2 loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XRANDR "libXrandr.so.2"      /**< Dynamic XRandR loading */
# define SDL_VIDEO_DRIVER_X11_DYNAMIC_XSS "libXss.so.1"            /**< Dynamic Xss loading */
# define SDL_VIDEO_DRIVER_X11_HAS_XKBLIB 1                         /**< XKB library support */
# define SDL_VIDEO_DRIVER_X11_SUPPORTS_GENERIC_EVENTS 1            /**< Generic event support */
# define SDL_VIDEO_DRIVER_X11_XCURSOR 1                            /**< Xcursor extension support */
# define SDL_VIDEO_DRIVER_X11_XDBE 1                               /**< Double buffer extension support */
# define SDL_VIDEO_DRIVER_X11_XFIXES 1                             /**< Xfixes extension support */
# define SDL_VIDEO_DRIVER_X11_XINPUT2 1                            /**< XInput2 extension support */
# define SDL_VIDEO_DRIVER_X11_XINPUT2_SUPPORTS_GESTURE 1           /**< XInput2 gesture support */
# define SDL_VIDEO_DRIVER_X11_XINPUT2_SUPPORTS_MULTITOUCH 1        /**< XInput2 multitouch support */
# define SDL_VIDEO_DRIVER_X11_XINPUT2_SUPPORTS_SCROLLINFO 1        /**< XInput2 scroll info support */
# define SDL_VIDEO_DRIVER_X11_XRANDR 1                             /**< XRandR extension support */
# define SDL_VIDEO_DRIVER_X11_XSCRNSAVER 1                         /**< Screen saver extension support */
# define SDL_VIDEO_DRIVER_X11_XSHAPE 1                             /**< Shape extension support */
# define SDL_VIDEO_DRIVER_X11_XSYNC 1                              /**< Sync extension support */
/** @} */

/**
 * @name OpenGL Support
 * @brief OpenGL rendering contexts on Linux.
 * @{
 */
# define SDL_VIDEO_OPENGL 1         /**< OpenGL support */
# define SDL_VIDEO_OPENGL_EGL 1     /**< EGL support */
# define SDL_VIDEO_OPENGL_ES2 1     /**< OpenGL ES 2.0 support */
# define SDL_VIDEO_OPENGL_GLX 1     /**< GLX (OpenGL Extension to X) support */
/** @} */

#endif
/** @} */ /* End of platform-specific configurations */

/* ============================================================================
 * CROSS-PLATFORM JOYSTICK SUPPORT
 * ============================================================================ */

/**
 * @name Joystick Drivers
 * @brief Additional joystick drivers available on all platforms.
 * @{
 */
#define SDL_JOYSTICK_HIDAPI 1   /**< HIDAPI joystick driver for USB/Bluetooth controllers */
#define SDL_JOYSTICK_VIRTUAL 1  /**< Virtual joystick driver for software-emulated controllers */
/** @} */

/* ============================================================================
 * DUMMY DRIVER IMPLEMENTATIONS
 * ============================================================================ */

/**
 * @name Dummy Drivers
 * @brief Fallback drivers that provide no-op implementations when native support is unavailable.
 * @{
 */
#define SDL_AUDIO_DRIVER_DUMMY 1   /**< Dummy audio driver (no sound output) */
#define SDL_VIDEO_DRIVER_DUMMY 1   /**< Dummy video driver (no display output) */
#define SDL_CAMERA_DRIVER_DUMMY 1  /**< Dummy camera driver (no camera input) */
/** @} */

/* ============================================================================
 * INPUT DRIVERS
 * ============================================================================ */

/**
 * @name Linux Input Drivers
 * @brief Low-level input drivers for Linux systems.
 * @{
 */
#if defined(SDL_PLATFORM_LINUX)
# define SDL_INPUT_LINUXEV 1   /**< Linux event device (evdev) input support */
# define SDL_INPUT_LINUXKD 1   /**< Linux keyboard device input support */
#endif
/** @} */

/* ============================================================================
 * FILESYSTEM OPERATIONS
 * ============================================================================ */

/**
 * @name Filesystem Operations
 * @brief Platform-specific filesystem operation implementations.
 * @{
 */
#if defined(SDL_PLATFORM_WIN32)
# define SDL_FSOPS_WINDOWS 1   /**< Windows filesystem operations */
#else
# define SDL_FSOPS_POSIX 1     /**< POSIX filesystem operations */
#endif
/** @} */

/* ============================================================================
 * PROCESS MANAGEMENT
 * ============================================================================ */

/**
 * @name Process Management
 * @brief Platform-specific process creation and management.
 * @{
 */
#if defined(SDL_PLATFORM_WIN32)
# define SDL_PROCESS_WINDOWS 1   /**< Windows process management */
#else
# define SDL_PROCESS_POSIX 1     /**< POSIX process management */
#endif
/** @} */

/* ============================================================================
 * SHARED OBJECT LOADING
 * ============================================================================ */

/**
 * @name Shared Object Loading
 * @brief Platform-specific dynamic library loading systems.
 * @{
 */
#if defined(SDL_PLATFORM_WIN32)
# define SDL_LOADSO_WINDOWS 1   /**< Windows LoadLibrary/GetProcAddress */
#else
# define SDL_LOADSO_DLOPEN 1    /**< POSIX dlopen/dlsym */
#endif
/** @} */

/* ============================================================================
 * THREADING SYSTEMS
 * ============================================================================ */

/**
 * @name Threading Systems
 * @brief Platform-specific thread implementation and synchronization primitives.
 * @{
 */
#if defined(SDL_PLATFORM_WIN32)
# define SDL_THREAD_GENERIC_COND_SUFFIX 1    /**< Generic condition variable implementation */
# define SDL_THREAD_GENERIC_RWLOCK_SUFFIX 1  /**< Generic read-write lock implementation */
# define SDL_THREAD_WINDOWS 1                /**< Windows threading (CreateThread, etc.) */
#else
# define SDL_THREAD_PTHREAD_RECURSIVE_MUTEX 1  /**< Pthread recursive mutex support */
# define SDL_THREAD_PTHREAD 1                  /**< POSIX threads (pthread) */
#endif
/** @} */

/* ============================================================================
 * TIMER AND RTC SYSTEMS
 * ============================================================================ */

/**
 * @name Timer and Real-Time Clock
 * @brief Platform-specific timer and time retrieval implementations.
 * @{
 */
#if defined(SDL_PLATFORM_WIN32)
# define SDL_TIME_WINDOWS 1    /**< Windows time functions (QueryPerformanceCounter, etc.) */
# define SDL_TIMER_WINDOWS 1   /**< Windows timer implementation */
#else
# define SDL_TIME_UNIX 1       /**< Unix time functions (clock_gettime, etc.) */
# define SDL_TIMER_UNIX 1      /**< Unix timer implementation */
#endif
/** @} */

/* ============================================================================
 * iOS-SPECIFIC FEATURES
 * ============================================================================ */

/**
 * @name iOS-Specific Support
 * @brief Features specific to iOS platforms.
 * @{
 */
#if defined(SDL_PLATFORM_IOS)
# define SDL_IPHONE_KEYBOARD 1      /**< iOS on-screen keyboard support */
# define SDL_IPHONE_LAUNCHSCREEN 1  /**< iOS launch screen support */
#endif
/** @} */
