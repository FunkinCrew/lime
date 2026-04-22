#pragma once


#include <system/CFFI.h>
#include <stdio.h>
#include <string>


namespace lime {


	enum SystemDirectory {

		APPLICATION,
		APPLICATION_STORAGE,
		DESKTOP,
		DOCUMENTS,
		USER

	};

	enum SystemTheme {

		UNKNOWN,
		LIGHT,
		DARK

	};


	class System {


		public:

			static void GCEnterBlocking ();
			static void GCExitBlocking ();

			static void GCTryEnterBlocking ();
			static void GCTryExitBlocking ();

			#if defined(HX_WINDOWS) || defined(IPHONE) || defined(APPLETV)
			static char* GetDeviceModel ();
			static char* GetDeviceVendor ();
			static char* GetPlatformLabel ();
			static char* GetPlatformName ();
			static char* GetPlatformVersion ();
			#endif

			static char* GetDirectory (SystemDirectory type, const char* company, const char* title);

			static int GetNumDisplays ();
			static void* GetDisplay (bool useCFFIValue, int id);

			static int GetFirstGyroscopeSensorId ();
			static int GetFirstAccelerometerSensorId ();

			static double GetTimer ();

			static SystemTheme GetTheme ();

			static void OpenFile (const char* path);
			static void OpenURL (const char* url, const char* target);

			static const char* GetHint (const char* key);
			static void SetHint (const char* key, const char* value);

			static bool GetAllowScreenTimeout ();
			static bool SetAllowScreenTimeout (bool allow);

			#if defined(HX_WINDOWS)
			static int GetWindowsConsoleMode (int handleType);
			static bool SetWindowsConsoleMode (int handleType, int mode);
			#endif


	};


	struct FILE_HANDLE {

		void *handle;

		FILE_HANDLE (void* handle) : handle (handle) {}

	};


	extern int fclose (FILE_HANDLE *stream);
	extern FILE_HANDLE *fopen (const char *filename, const char *mode);
	extern size_t fread (void *ptr, size_t size, size_t count, FILE_HANDLE *stream);
	extern int fseek (FILE_HANDLE *stream, long int offset, int origin);
	extern long int ftell (FILE_HANDLE *stream);
	extern size_t fwrite (const void *ptr, size_t size, size_t count, FILE_HANDLE *stream);


}
