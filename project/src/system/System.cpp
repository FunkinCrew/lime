#include <graphics/PixelFormat.h>
#include <math/Rectangle.h>
#include <system/DisplayMode.h>
#include <system/JNI.h>
#include <system/System.h>

#if defined(IPHONE) || defined(APPLETV)
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#elif defined (HX_WINDOWS)
#define _WIN32_DCOM

#include <iostream>
#include <wbemidl.h>
#include <comutil.h>
#endif

#include <SDL3/SDL.h>

#include <string>
#include <locale>
#include <codecvt>


namespace lime {


	void System::GCEnterBlocking () {

		#ifndef LIME_HASHLINK
		gc_enter_blocking ();
		#endif

	}


	void System::GCExitBlocking () {

		#ifndef LIME_HASHLINK
		gc_exit_blocking ();
		#endif

	}


	void System::GCTryEnterBlocking () {

		#ifndef LIME_HASHLINK
		gc_try_blocking ();
		#endif

	}


	void System::GCTryExitBlocking () {

		#ifndef LIME_HASHLINK
		gc_try_unblocking ();
		#endif

	}


	#ifdef HX_WINDOWS
	char* GetWMIValue (BSTR query, BSTR field) {

		HRESULT hres = 0;
		IWbemLocator *pLoc = NULL;
		IWbemServices *pSvc = NULL;
		IEnumWbemClassObject* pEnumerator = NULL;
		IWbemClassObject *pclsObj = NULL;
		ULONG uReturn = 0;
		char* result = NULL;

		hres = CoCreateInstance (CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (LPVOID *) &pLoc);

		if (FAILED (hres)) {

			return NULL;

		}

		hres = pLoc->ConnectServer (_bstr_t (L"ROOT\\CIMV2"), NULL, NULL, 0, NULL, 0, 0, &pSvc);

		if (FAILED (hres)) {

			pLoc->Release ();
			return NULL;

		}

		hres = CoSetProxyBlanket (pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, NULL, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, NULL, EOAC_NONE);

		if (FAILED (hres)) {

			pSvc->Release ();
			pLoc->Release ();
			return NULL;

		}

		hres = pSvc->ExecQuery (bstr_t (L"WQL"), query, WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, NULL, &pEnumerator);

		if (FAILED (hres)) {

			pSvc->Release ();
			pLoc->Release ();
			return NULL;

		}

		while (pEnumerator) {

			HRESULT hr = pEnumerator->Next (WBEM_INFINITE, 1, &pclsObj, &uReturn);

			if (uReturn == 0) {

				break;

			}

			VARIANT vtProp;
			hr = pclsObj->Get (field, 0, &vtProp, 0, 0);
			int len = WideCharToMultiByte (CP_UTF8, 0, vtProp.bstrVal, -1, NULL, 0, NULL, NULL);
			result = (char*)malloc(len);
			WideCharToMultiByte (CP_UTF8, 0, vtProp.bstrVal, -1, result, len, NULL, NULL);
			VariantClear (&vtProp);
			pclsObj->Release ();

		}

		pSvc->Release ();
		pLoc->Release ();
		pEnumerator->Release ();

		return result;

	}
	#endif


	char* System::GetDeviceModel () {

		#if defined(IPHONE) || defined(APPLETV)
		struct utsname systemInfo;
		uname (&systemInfo);
		return SDL_strdup (systemInfo.machine);
		#elif defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Version"));
		#else
		return NULL;
		#endif

	}


	char* System::GetDeviceVendor () {

		#ifdef HX_WINDOWS
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Vendor"));
		#else
		return NULL;
		#endif

	}


	char* System::GetPlatformLabel () {

		#ifdef HX_WINDOWS
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Caption"));
		#else
		return NULL;
		#endif

	}


	char* System::GetPlatformName () {

		return NULL;

	}


	char* System::GetPlatformVersion () {

		#if defined(IPHONE) || defined(APPLETV)
		return SDL_strdup(UIDevice.currentDevice.systemVersion.UTF8String);
		#elif defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Version"));
		#else
		return NULL;
		#endif

	}


	bool System::GetAllowScreenTimeout () {

		return SDL_ScreenSaverEnabled ();

	}


	bool System::SetAllowScreenTimeout (bool allow) {

		if (allow) {

			SDL_EnableScreenSaver ();

		} else {

			SDL_DisableScreenSaver ();

		}

		return allow;

	}


	char* System::GetDirectory (SystemDirectory type, const char* company, const char* title) {

		char* result = nullptr;

		System::GCEnterBlocking ();

		switch (type) {

			case APPLICATION: {

				result = SDL_strdup (SDL_GetBasePath ());
				break;

			}

			case APPLICATION_STORAGE: {

				result = SDL_GetPrefPath (company, title);
				break;

			}

			case DESKTOP: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_DESKTOP));
				break;

			}

			case DOCUMENTS: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_DOCUMENTS));
				break;

			}

			case USER: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_HOME));
				break;

			}

		}

		System::GCExitBlocking ();

		return result;

	}


	int System::GetNumDisplays () {

		int numDisplays;

		SDL_DisplayID *displays = SDL_GetDisplays (&numDisplays);

		SDL_free (displays);

		return numDisplays;

	}

	void* System::GetDisplay (bool useCFFIValue, int id) {

		if (id == 0)
			id = SDL_GetPrimaryDisplay();

		if (useCFFIValue) {

			const char* displayName = SDL_GetDisplayName (id);
			if (displayName == NULL) {

				return alloc_null ();

			}

			value display = alloc_empty_object ();
			alloc_field (display, val_id ("name"), alloc_string (displayName));

			SDL_Rect bounds = { 0, 0, 0, 0 };
			SDL_GetDisplayBounds (id, &bounds);
			alloc_field (display, val_id ("bounds"), Rectangle (bounds.x, bounds.y, bounds.w, bounds.h).Value ());

			SDL_Rect usable = { 0, 0, 0, 0 };
			SDL_GetDisplayUsableBounds(id, &usable);
			alloc_field(display, val_id ("safeArea"), Rectangle (usable.x, usable.y, usable.w, usable.h).Value ());

			const SDL_DisplayMode *displayMode = SDL_GetDesktopDisplayMode (id);

			float pixelDensity = displayMode ? displayMode->pixel_density : 1.0f;

			float contentScale = SDL_GetDisplayContentScale (id);

			if (contentScale == 0.0f) {

				contentScale = 1.0f;

			}

			#if defined (ANDROID) || defined (IPHONE)
			float dpi = pixelDensity * contentScale * 160.0f;
			#else
			float dpi = pixelDensity * contentScale * 96.0f;
			#endif

			alloc_field (display, val_id ("dpi"), alloc_float (dpi));

			alloc_field (display, val_id ("orientation"), alloc_int ((int) SDL_GetCurrentDisplayOrientation (id)));

			DisplayMode mode;

			mode.height = displayMode->h;

			switch (displayMode->format) {

				case SDL_PIXELFORMAT_ARGB8888:

					mode.pixelFormat = ARGB32;
					break;

				case SDL_PIXELFORMAT_BGRA8888:
				case SDL_PIXELFORMAT_BGRX8888:

					mode.pixelFormat = BGRA32;
					break;

				default:

					mode.pixelFormat = RGBA32;

			}

			mode.refreshRate = displayMode->refresh_rate;
			mode.width = displayMode->w;

			alloc_field (display, val_id ("currentMode"), (value)mode.Value ());

			int numDisplayModes;
			SDL_DisplayMode **displayModes = SDL_GetFullscreenDisplayModes (id, &numDisplayModes);
			value supportedModes = alloc_array (numDisplayModes);

			for (int i = 0; i < numDisplayModes; i++) {

				const SDL_DisplayMode *sdlDisplayMode = displayModes[i];

				mode.height = sdlDisplayMode->h;

				switch (sdlDisplayMode->format) {

					case SDL_PIXELFORMAT_ARGB8888:

						mode.pixelFormat = ARGB32;
						break;

					case SDL_PIXELFORMAT_BGRA8888:
					case SDL_PIXELFORMAT_BGRX8888:

						mode.pixelFormat = BGRA32;
						break;

					default:

						mode.pixelFormat = RGBA32;

				}

				mode.refreshRate = sdlDisplayMode->refresh_rate;
				mode.width = sdlDisplayMode->w;

				val_array_set_i (supportedModes, i, (value)mode.Value ());

			}

			alloc_field (display, val_id ("supportedModes"), supportedModes);
			return display;

		} else {

			const char* displayName = SDL_GetDisplayName (id);
			if (displayName == NULL) {

				return 0;

			}

			vdynamic* display = (vdynamic*)hl_alloc_dynobj ();

			char* _displayName = (char*)malloc(strlen(displayName) + 1);
			strcpy (_displayName, displayName);
			hl_dyn_setp (display, hl_hash_utf8 ("bounds"), &hlt_bytes, _displayName);

			SDL_Rect bounds = { 0, 0, 0, 0 };
			SDL_GetDisplayBounds (id, &bounds);

			vdynamic* _bounds = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_bounds, hl_hash_utf8 ("x"), &hlt_i32, bounds.x);
			hl_dyn_seti (_bounds, hl_hash_utf8 ("y"), &hlt_i32, bounds.y);
			hl_dyn_seti (_bounds, hl_hash_utf8 ("width"), &hlt_i32, bounds.w);
			hl_dyn_seti (_bounds, hl_hash_utf8 ("height"), &hlt_i32, bounds.h);

			hl_dyn_setp (display, hl_hash_utf8 ("bounds"), &hlt_dynobj, _bounds);

			SDL_Rect usable = { 0, 0, 0, 0 };
			SDL_GetDisplayUsableBounds(id, &usable);

			vdynamic* _usable = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_usable, hl_hash_utf8 ("x"), &hlt_i32, usable.x);
			hl_dyn_seti (_usable, hl_hash_utf8 ("y"), &hlt_i32, usable.y);
			hl_dyn_seti (_usable, hl_hash_utf8 ("width"), &hlt_i32, usable.w);
			hl_dyn_seti (_usable, hl_hash_utf8 ("height"), &hlt_i32, usable.h);

			hl_dyn_setp (display, hl_hash_utf8 ("safeArea"), &hlt_dynobj, _usable);

			const SDL_DisplayMode *displayMode = SDL_GetDesktopDisplayMode (id);

			float pixelDensity = displayMode ? displayMode->pixel_density : 1.0f;

			float contentScale = SDL_GetDisplayContentScale (id);

			if (contentScale == 0.0f) {

				contentScale = 1.0f;

			}

			#if defined (ANDROID) || defined (IPHONE)
			float dpi = pixelDensity * contentScale * 160.0f;
			#else
			float dpi = pixelDensity * contentScale * 96.0f;
			#endif

			hl_dyn_setf (display, hl_hash_utf8 ("dpi"), dpi);

			hl_dyn_seti (display, hl_hash_utf8 ("orientation"), &hlt_i32, (int) SDL_GetCurrentDisplayOrientation (id));

			DisplayMode mode;

			mode.height = displayMode->h;

			switch (displayMode->format) {

				case SDL_PIXELFORMAT_ARGB8888:

					mode.pixelFormat = ARGB32;
					break;

				case SDL_PIXELFORMAT_BGRA8888:
				case SDL_PIXELFORMAT_BGRX8888:

					mode.pixelFormat = BGRA32;
					break;

				default:

					mode.pixelFormat = RGBA32;

			}

			mode.refreshRate = displayMode->refresh_rate;
			mode.width = displayMode->w;

			vdynamic* _displayMode = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_displayMode, hl_hash_utf8 ("height"), &hlt_i32, mode.height);
			hl_dyn_seti (_displayMode, hl_hash_utf8 ("pixelFormat"), &hlt_i32, mode.pixelFormat);
			hl_dyn_seti (_displayMode, hl_hash_utf8 ("refreshRate"), &hlt_i32, mode.refreshRate);
			hl_dyn_seti (_displayMode, hl_hash_utf8 ("width"), &hlt_i32, mode.width);
			hl_dyn_setp (display, hl_hash_utf8 ("currentMode"), &hlt_dynobj, _displayMode);

			int numDisplayModes;
			SDL_DisplayMode **displayModes = SDL_GetFullscreenDisplayModes (id, &numDisplayModes);

			hl_varray* supportedModes = (hl_varray*)hl_alloc_array (&hlt_dynobj, numDisplayModes);
			vdynamic** supportedModesData = hl_aptr (supportedModes, vdynamic*);

			for (int i = 0; i < numDisplayModes; i++) {

				const SDL_DisplayMode *sdlDisplayMode = displayModes[i];

				mode.height = sdlDisplayMode->h;

				switch (sdlDisplayMode->format) {

					case SDL_PIXELFORMAT_ARGB8888:

						mode.pixelFormat = ARGB32;
						break;

					case SDL_PIXELFORMAT_BGRA8888:
					case SDL_PIXELFORMAT_BGRX8888:

						mode.pixelFormat = BGRA32;
						break;

					default:

						mode.pixelFormat = RGBA32;

				}

				mode.refreshRate = sdlDisplayMode->refresh_rate;
				mode.width = sdlDisplayMode->w;

				vdynamic* _displayMode = (vdynamic*)hl_alloc_dynobj ();
				hl_dyn_seti (_displayMode, hl_hash_utf8 ("height"), &hlt_i32, mode.height);
				hl_dyn_seti (_displayMode, hl_hash_utf8 ("pixelFormat"), &hlt_i32, mode.pixelFormat);
				hl_dyn_seti (_displayMode, hl_hash_utf8 ("refreshRate"), &hlt_i32, mode.refreshRate);
				hl_dyn_seti (_displayMode, hl_hash_utf8 ("width"), &hlt_i32, mode.width);

				*supportedModesData++ = _displayMode;

			}

			hl_dyn_setp (display, hl_hash_utf8 ("supportedModes"), &hlt_array, supportedModes);
			return display;

		}

	}


	int System::GetFirstGyroscopeSensorId () {

		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors (&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++)
		{
			if (SDL_GetSensorTypeForID (sensors[i]) == SDL_SENSOR_GYRO) {

				SDL_free (sensors);
				return sensors[i];

			}

		}

		SDL_free (sensors);
		return -1;

	}


	int System::GetFirstAccelerometerSensorId () {

		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors(&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++) {

			if (SDL_GetSensorTypeForID(sensors[i]) == SDL_SENSOR_ACCEL) {

				SDL_free(sensors);
				return sensors[i];

			}

		}

		SDL_free (sensors);
		return -1;

	}


	double System::GetTimer () {

		return SDL_GetTicksNS ();

	}

	SystemTheme System::GetTheme () {

		return (SystemTheme)SDL_GetSystemTheme ();

	}


	void System::OpenFile (const char* path) {

		OpenURL (path, NULL);

	}


	void System::OpenURL (const char* url, const char* target) {

		SDL_OpenURL (url);

	}


	const char* System::GetHint (const char* key) {

		std::string hintKey (key);

		if (hintKey.rfind ("SDL_", 0) != 0) {

			hintKey = "SDL_" + hintKey;

		}

		const char* hint = SDL_GetHint (hintKey.c_str ());

		if (!hint) {

			return nullptr;

		}

		return hint;

	}

	void System::SetHint (const char* key, const char* value) {

		std::string hintKey (key);

		if (hintKey.rfind ("SDL_", 0) != 0) {

			hintKey = "SDL_" + hintKey;

		}

		SDL_SetHint (hintKey.c_str (), value);

	}


	#ifdef HX_WINDOWS
	int System::GetWindowsConsoleMode (int handleType) {

		DWORD mode = 0;

		HANDLE handle = GetStdHandle ((DWORD)handleType);

		if (handle) {

			GetConsoleMode (handle, &mode);

		}

		return mode;

	}


	bool System::SetWindowsConsoleMode (int handleType, int mode) {

		HANDLE handle = GetStdHandle ((DWORD)handleType);

		if (handle) {

			return SetConsoleMode (handle, (DWORD)mode);

		}

		return false;

	}
	#endif


	int fclose (FILE_HANDLE *stream) {

		if (stream) {

			System::GCEnterBlocking ();

			int code = SDL_CloseIO ((SDL_IOStream*)stream->handle);

			delete stream;

			System::GCExitBlocking ();

			return code;

		}

		return 0;

	}


	FILE_HANDLE *fopen (const char *filename, const char *mode) {

		System::GCEnterBlocking ();

		SDL_IOStream *result = SDL_IOFromFile (filename, mode);

		if (!result) {

			const char *base = SDL_GetBasePath ();

			if (base) {

				char *fullpath;

				if (SDL_asprintf (&fullpath, "%s%s", base, filename) >= 0) {

					result = SDL_IOFromFile (fullpath, mode);

					SDL_free (fullpath);

				}

			}

		}

		System::GCExitBlocking ();

		if (result) {

			return new FILE_HANDLE (result);

		}

		return NULL;

	}


	size_t fread (void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

	  	size_t nmem = size > 0 && count > 0 ? SDL_ReadIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size : 0;

		System::GCExitBlocking ();

		return nmem;

	}


	int fseek (FILE_HANDLE *stream, long int offset, int origin) {

		System::GCEnterBlocking ();

		int success = SDL_SeekIO (stream ? (SDL_IOStream*)stream->handle : NULL, offset, (SDL_IOWhence)origin);

		System::GCExitBlocking ();

		return success;

	}


	long int ftell (FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

		long int pos = SDL_TellIO (stream ? (SDL_IOStream*)stream->handle : NULL);

		System::GCExitBlocking ();

		return pos;

	}


	size_t fwrite (const void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

        size_t nmem = size > 0 && count > 0 ? SDL_WriteIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size : 0;

		System::GCExitBlocking ();

		return nmem;

	}


}
