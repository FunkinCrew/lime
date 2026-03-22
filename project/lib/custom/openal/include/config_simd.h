/* Define to 1 if we have SSE CPU extensions, else 0 */
#if defined(_M_IX86) || defined(_M_X64) || defined(__i386__) || defined(__x86_64__)
    #define HAVE_SSE 1
    #define HAVE_SSE2 1
    #define HAVE_SSE3 1
    #define HAVE_SSE4_1 1
    #define HAVE_SSE_INTRINSICS 1
#else
    #define HAVE_SSE 0
    #define HAVE_SSE2 0
    #define HAVE_SSE3 0
    #define HAVE_SSE4_1 0
    #define HAVE_SSE_INTRINSICS 0
#endif

/* Define to 1 if we have ARM Neon CPU extensions, else 0 */
#if defined(_M_ARM64) || defined(__aarch64__)
    #define HAVE_NEON 1
#else
    #define HAVE_NEON 0
#endif
