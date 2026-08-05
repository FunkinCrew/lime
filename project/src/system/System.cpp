#include <graphics/PixelFormat.h>
#include <math/Rectangle.h>
#include <system/DisplayMode.h>
#include <system/JNI.h>
#include <system/System.h>

#if defined(IPHONE)
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#elif defined(HX_WINDOWS)
#define _WIN32_DCOM

#include <comutil.h>
#include <iostream>
#include <wbemidl.h>
#endif

#include <codecvt>
#include <locale>
#include <SDL3/SDL.h>
#include <string>

namespace lime
{

	void System::GCEnterBlocking()
	{
		gc_enter_blocking();
	}

	void System::GCExitBlocking()
	{
		gc_exit_blocking();
	}

	void System::GCTryEnterBlocking()
	{
		gc_try_blocking();
	}

	void System::GCTryExitBlocking()
	{
		gc_try_unblocking();
	}

#ifdef HX_WINDOWS
	char *GetWMIValue(BSTR query, BSTR field)
	{
		HRESULT hres = 0;
		IWbemLocator *pLoc = NULL;
		IWbemServices *pSvc = NULL;
		IEnumWbemClassObject *pEnumerator = NULL;
		IWbemClassObject *pclsObj = NULL;
		ULONG uReturn = 0;
		char *result = NULL;

		hres = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (LPVOID *)&pLoc);

		if (FAILED(hres))
		{
			return NULL;
		}

		hres = pLoc->ConnectServer(_bstr_t(L"ROOT\\CIMV2"), NULL, NULL, 0, NULL, 0, 0, &pSvc);

		if (FAILED(hres))
		{
			pLoc->Release();
			return NULL;
		}

		hres = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, NULL, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, NULL, EOAC_NONE);

		if (FAILED(hres))
		{
			pSvc->Release();
			pLoc->Release();
			return NULL;
		}

		hres = pSvc->ExecQuery(bstr_t(L"WQL"), query, WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, NULL, &pEnumerator);

		if (FAILED(hres))
		{
			pSvc->Release();
			pLoc->Release();
			return NULL;
		}

		while (pEnumerator)
		{
			HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pclsObj, &uReturn);

			if (uReturn == 0)
			{
				break;
			}

			VARIANT vtProp;
			hr = pclsObj->Get(field, 0, &vtProp, 0, 0);
			int len = WideCharToMultiByte(CP_UTF8, 0, vtProp.bstrVal, -1, NULL, 0, NULL, NULL);
			result = (char *)malloc(len);
			WideCharToMultiByte(CP_UTF8, 0, vtProp.bstrVal, -1, result, len, NULL, NULL);
			VariantClear(&vtProp);
			pclsObj->Release();
		}

		pSvc->Release();
		pLoc->Release();
		pEnumerator->Release();

		return result;
	}
#endif

	char *System::GetDeviceModel()
	{
#if defined(IPHONE)
		struct utsname systemInfo;
		uname(&systemInfo);
		return SDL_strdup(systemInfo.machine);
#elif defined(HX_WINDOWS)
		return GetWMIValue(_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Version"));
#else
		return NULL;
#endif
	}

	char *System::GetDeviceVendor()
	{
#ifdef HX_WINDOWS
		return GetWMIValue(_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Vendor"));
#else
		return NULL;
#endif
	}

	char *System::GetPlatformLabel()
	{
#ifdef HX_WINDOWS
		return GetWMIValue(_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Caption"));
#else
		return NULL;
#endif
	}

	char *System::GetPlatformName()
	{
		return NULL;
	}

	char *System::GetPlatformVersion()
	{
#if defined(IPHONE)
		return SDL_strdup(UIDevice.currentDevice.systemVersion.UTF8String);
#elif defined(HX_WINDOWS)
		return GetWMIValue(_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Version"));
#else
		return NULL;
#endif
	}

	bool System::GetAllowScreenTimeout()
	{
		return SDL_ScreenSaverEnabled();
	}

	bool System::SetAllowScreenTimeout(bool allow)
	{
		if (allow)
		{
			SDL_EnableScreenSaver();
		}
		else
		{
			SDL_DisableScreenSaver();
		}

		return allow;
	}

	char *System::GetDirectory(SystemDirectory type, const char *company, const char *title)
	{
		char *result = nullptr;

		System::GCEnterBlocking();

		switch (type)
		{
			case APPLICATION: {
				result = SDL_strdup(SDL_GetBasePath());
				break;
			}

			case APPLICATION_STORAGE: {
				result = SDL_GetPrefPath(company, title);
				break;
			}

			case DESKTOP: {
				result = SDL_strdup(SDL_GetUserFolder(SDL_FOLDER_DESKTOP));
				break;
			}

			case DOCUMENTS: {
				result = SDL_strdup(SDL_GetUserFolder(SDL_FOLDER_DOCUMENTS));
				break;
			}

			case USER: {
				result = SDL_strdup(SDL_GetUserFolder(SDL_FOLDER_HOME));
				break;
			}
		}

		System::GCExitBlocking();

		return result;
	}

	int System::GetNumDisplays()
	{
		int numDisplays;

		SDL_DisplayID *displays = SDL_GetDisplays(&numDisplays);

		SDL_free(displays);

		return numDisplays;
	}

	void *System::GetDisplay(int id)
	{
		if (id == 0)
			id = SDL_GetPrimaryDisplay();

		const char *displayName = SDL_GetDisplayName(id);

		if (displayName == NULL)
		{
			return alloc_null();
		}

		value display = alloc_empty_object();
		alloc_field(display, val_id("name"), alloc_string(displayName));

		SDL_Rect bounds = {0, 0, 0, 0};
		SDL_GetDisplayBounds(id, &bounds);
		alloc_field(display, val_id("bounds"), Rectangle(bounds.x, bounds.y, bounds.w, bounds.h).Value());

		SDL_Rect usable = {0, 0, 0, 0};
		SDL_GetDisplayUsableBounds(id, &usable);
		alloc_field(display, val_id("safeArea"), Rectangle(usable.x, usable.y, usable.w, usable.h).Value());

		const SDL_DisplayMode *displayMode = SDL_GetDesktopDisplayMode(id);

		float pixelDensity = displayMode ? displayMode->pixel_density : 1.0f;

		float contentScale = SDL_GetDisplayContentScale(id);

		if (contentScale == 0.0f)
		{
			contentScale = 1.0f;
		}

#if defined(ANDROID) || defined(IPHONE)
		float dpi = pixelDensity * contentScale * 160.0f;
#else
		float dpi = pixelDensity * contentScale * 96.0f;
#endif

		alloc_field(display, val_id("dpi"), alloc_float(dpi));

		alloc_field(display, val_id("orientation"), alloc_int((int)SDL_GetCurrentDisplayOrientation(id)));

		DisplayMode mode;

		mode.height = displayMode->h;

		switch (displayMode->format)
		{
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

		alloc_field(display, val_id("currentMode"), (value)mode.Value());

		int numDisplayModes;
		SDL_DisplayMode **displayModes = SDL_GetFullscreenDisplayModes(id, &numDisplayModes);
		value supportedModes = alloc_array(numDisplayModes);

		for (int i = 0; i < numDisplayModes; i++)
		{
			const SDL_DisplayMode *sdlDisplayMode = displayModes[i];

			mode.height = sdlDisplayMode->h;

			switch (sdlDisplayMode->format)
			{
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

			val_array_set_i(supportedModes, i, (value)mode.Value());
		}

		alloc_field(display, val_id("supportedModes"), supportedModes);
		return display;
	}

	int System::GetFirstGyroscopeSensorId()
	{
		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors(&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++)
		{
			if (SDL_GetSensorTypeForID(sensors[i]) == SDL_SENSOR_GYRO)
			{
				SDL_free(sensors);
				return sensors[i];
			}
		}

		SDL_free(sensors);
		return -1;
	}

	int System::GetFirstAccelerometerSensorId()
	{
		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors(&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++)
		{
			if (SDL_GetSensorTypeForID(sensors[i]) == SDL_SENSOR_ACCEL)
			{
				SDL_free(sensors);
				return sensors[i];
			}
		}

		SDL_free(sensors);
		return -1;
	}

	double System::GetTimer()
	{
		return SDL_GetTicksNS();
	}

	SystemTheme System::GetTheme()
	{
		return (SystemTheme)SDL_GetSystemTheme();
	}

	void System::OpenFile(const char *path)
	{
		OpenURL(path, NULL);
	}

	void System::OpenURL(const char *url, const char *target)
	{
		SDL_OpenURL(url);
	}

	const char *System::GetHint(const char *key)
	{
		std::string hintKey(key);

		if (hintKey.rfind("SDL_", 0) != 0)
		{
			hintKey = "SDL_" + hintKey;
		}

		const char *hint = SDL_GetHint(hintKey.c_str());

		if (!hint)
		{
			return nullptr;
		}

		return hint;
	}

	void System::SetHint(const char *key, const char *value)
	{
		std::string hintKey(key);

		if (hintKey.rfind("SDL_", 0) != 0)
		{
			hintKey = "SDL_" + hintKey;
		}

		SDL_SetHint(hintKey.c_str(), value);
	}

#ifdef HX_WINDOWS
	int System::GetWindowsConsoleMode(int handleType)
	{
		DWORD mode = 0;

		HANDLE handle = GetStdHandle((DWORD)handleType);

		if (handle)
		{
			GetConsoleMode(handle, &mode);
		}

		return mode;
	}

	bool System::SetWindowsConsoleMode(int handleType, int mode)
	{
		HANDLE handle = GetStdHandle((DWORD)handleType);

		if (handle)
		{
			return SetConsoleMode(handle, (DWORD)mode);
		}

		return false;
	}
#endif

} // namespace lime
