#pragma once

/* https://github.com/xiph/opusfile/pull/53 */
#if defined(__ANDROID_API__) && (__ANDROID_API__ < 24) && (defined __arm__ || defined __i386__)
# define fseeko fseek
# define ftello ftell
#endif